/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:sufenbao/models/data_model.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/util/launchApp.dart';
import 'package:sufenbao/widget/product_info_img_widget.dart';
import 'package:sufenbao/service.dart';

import '../util/toast_utils.dart';
import '../util/colors.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../listener/detail_value_change.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/auth_tip.dart';
import '../widget/goods_buy_history_widget.dart';
import '../widget/detail_lunbo_widget.dart';
import '../widget/loading.dart';

DetailValueChange valueChange = DetailValueChange();

///产拼多多品详情
class PddDetailPage extends StatefulWidget {
  final Map data;
  const PddDetailPage(this.data, {Key? key}) : super(key: key);
  @override
  _PddDetailPageState createState() => _PddDetailPageState();
}

class _PddDetailPageState extends State<PddDetailPage> with AuthTip {
  ScrollController controller = ScrollController();
  List tabList = ['商品', '详情', '同款'];
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  late String goodsId;
  late String title = '';
  late String img = '';
  late String startPrice = '0';
  late String endPrice = '0';
  late List detailImgs = [];
  late bool collect = false;
  bool loading = true;

  EdgeInsets get pmPadd => MediaQuery.of(context).padding;
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    initGoodsId();
    valueChange.changeTabIndex(0);
    this.controllerListener();
    await this.getDetailData();
    await this.getCollect();
    await this.listSimilarGoodsByOpen();
    super.initChannelId(callback: () {
      setState(() {});
    });
  }

  Future getCollect() async {
    collect = await BService.collect(goodsId);
    setState(() {});
  }

  Future isShowTip() async {
    int data = await BService.pddAuthQuery();
    return data == 0;
  }

  @override
  void dispose() {
    disposeTimer();
    super.dispose();
  }

  ///监听列表滚动
  void controllerListener() {
    controller.addListener(() {
      valueChange.changeValue(controller.offset);
      var key1H = 0.0;
      var key2H = 0.0;
      if (key1.currentContext != null) {
        key1H = (key1.currentContext?.size?.height) ?? 0.0;
      }
      if (key2.currentContext != null) {
        key2H = (key2.currentContext?.size?.height) ?? 0.0;
      }
      if (controller.offset > key1H + key2H - 56 - pmPadd.top) {
        valueChange.changeTabIndex(2);
      } else if (controller.offset > key1H - 56 - pmPadd.top) {
        valueChange.changeTabIndex(1);
      } else {
        valueChange.changeTabIndex(0);
      }
    });
  }

  initGoodsId() {
    goodsId = widget.data['goods_sign'] ??
        widget.data['goodsSign'] ??
        widget.data['productId'] ??
        widget.data['itemId'];
  }

  var res;
  //详情数据
  Map klMap = {};
  var detailDm =
      DataModel(object: {'minGroupPrice': '', 'goodsName': '', 'mallName': ''});
  Future<int> getDetailData() async {
    res = await BService.goodsDetailPDD(goodsId);
    if (res.isNotEmpty) {
      img = res['goodsThumbnailUrl'];
      title = res['goodsName'];
      List materialList = res['materialList'];
      detailImgs = res['goodsGalleryUrls'] ?? [];
      if (materialList.isNotEmpty) {
        var material = materialList.elementAt(0);
        detailImgs = material['goodsGalleryUrls'];
      }
      detailDm.addObject(res);
      int coupon = detailDm.object?['couponDiscount'];
      if (coupon == 0) {
        endPrice = detailDm.object!['minGroupPrice'].toString();
      } else {
        num endPriceD = detailDm.object?['minGroupPrice'] -
            detailDm.object?['couponDiscount'];
        endPrice = endPriceD.toStringAsFixed(2);
      }

      setState(() {
        loading = false;
      });
      klMap = await BService.goodsWordPDD(goodsId, uid: widget.data['uid']);
    } else {
      ToastUtils.showToast('商品已下架');
      Navigator.pop(context);
    }
    return detailDm.flag;
  }

  var listSimilarGoodsByOpenDm = DataModel();
  Future<int> listSimilarGoodsByOpen() async {
    var res = await BService.pddSearch(
      1,
      keyword: title,
    ).catchError((v) {
      listSimilarGoodsByOpenDm.toError('网络异常');
    });
    if (res != null) {
      listSimilarGoodsByOpenDm.addList(
          res['goodsList'], false, res['totalCount']);
    }
    setState(() {});
    return listSimilarGoodsByOpenDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color(0xffF3F3F3),
        body: Stack(children: [
          loading
              ? Global.showLoading2()
              : CustomScrollView(
                  controller: controller,
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(headers),
                    ),
                    if (listSimilarGoodsByOpenDm.list.isNotEmpty)
                      SliverPadding(
                        padding: EdgeInsets.all(16).copyWith(
                            bottom: MediaQuery.of(context).padding.bottom + 70),
                        sliver: SliverWaterfallFlow(
                          gridDelegate:
                              SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              var v = listSimilarGoodsByOpenDm.list[i];
                              return Container(
                                margin: EdgeInsets.only(
                                  top: [0, 1].contains(i) ? 0 : 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Global.openFadeContainer(
                                    createSimilarItem(i, v), PddDetailPage(v)),
                              );
                            },
                            childCount: listSimilarGoodsByOpenDm.list.length,
                          ),
                        ),
                      ),
                  ],
                ),
          titleBarView(),
          btmBarView(),
          if (showChannelWidget) createChannelAuthWidget(context, 'pdd.png'),
        ]),
      ),
    );
  }

  tipClick() {
    Global.showPddAuthDialog(() {
      Navigator.pop(context);
      // initChannelId();
      // setState(() {});
    });
  }

  Widget createSimilarItem(i, v) {
    String img = v['goodsThumbnailUrl'];
    String sale = v['salesTip'] == '' ? '0' : v['salesTip'];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                img,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        v['goodsName'],
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '¥',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '${v['minGroupPrice']}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '已售',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: sale,
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  v['mallName'],
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///底部操作栏
  Widget btmBarView() {
    return Positioned(
      bottom: detailDm.object!.isEmpty ? -64 : 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(
            8, 8, 8, MediaQuery.of(context).padding.bottom + 8),
        child: Row(
          children: [
            SizedBox(width: 4),
            createBottomBackArrow(context),
            SizedBox(width: 8),
            btmBtnView('收藏', Icons.star_rate_rounded, () {
              BService.collectProduct(context, collect, goodsId, 'pdd', img,
                      title, startPrice, endPrice)
                  .then((value) {
                getCollect();
              });
            }, collect),
            SizedBox(width: 24),
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(56),
                ),
                child: Row(
                  children: [
                    if (showShareBuy)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            onTapDialogLogin(context, fun: () {
                              res['klUrl'] = klMap['mobileShortUrl'];
                              Navigator.pushNamed(context, '/sellPage',
                                  arguments: {'res': res, 'platType': 'PDD'});
                            });
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Color(0xffFAEDE0),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(56),
                                bottomLeft: Radius.circular(56),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '转卖',
                                style: TextStyle(
                                  color: Colours.app_main,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onTapDialogLogin(context, fun: () {
                          launch(false);
                        }),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colours.pdd_main,
                            borderRadius: BorderRadius.circular(56),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '立即购买',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future launch(showLoading) async {
    if (klMap['mobileUrl'] == null) {
      if (!showLoading) {
        Loading.show(context);
      }
      await Future.delayed(Duration(milliseconds: 300));
      launch(true);
    } else {
      if (showLoading) {
        Loading.hide(context);
      }
      LaunchApp.launchPdd(context, klMap['mobileUrl'], klMap['mobileShortUrl'],
          fun: () async {
        bool installed = await fluwx.isWeChatInstalled;
        if (installed) {
          fluwx.open(
              target: MiniProgram(
            username: 'gh_0e7477744313',
            path: klMap['weAppPagePath'],
          ));
        }
      });
    }
  }

  void animateTo(offset) {
    return controller.jumpTo(offset ?? 0.0);
  }

  ///标题栏视图
  Widget titleBarView() {
    return ValueListenableBuilder(
      valueListenable: valueChange,
      builder: (_, __, ___) {
        var isGo = valueChange.value >= 100;
        return Container(
          height: 56 + pmPadd.top,
          decoration: BoxDecoration(
            color: isGo ? Colors.white : null,
          ),
          padding: EdgeInsets.fromLTRB(
            16,
            pmPadd.top + 8,
            16,
            8,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isGo ? null : Colors.black26,
                    borderRadius: BorderRadius.circular(56),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_left_rounded,
                    color: isGo ? Colors.black : Colors.white,
                  ),
                ),
              ),
              if (isGo) Spacer(),
              if (isGo)
                Row(
                  children: List.generate(tabList.length, (i) {
                    if (i == 1 && ['', null].contains(detailImgs)) {
                      return SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: () {
                        valueChange.changeTabIndex(i);
                        switch (tabList[i]) {
                          case '商品':
                            this.animateTo(0.0);
                            break;
                          case '详情':
                            this.animateTo(
                                (key1.currentContext?.size?.height ?? 0.0) -
                                    48 -
                                    pmPadd.top);
                            break;
                          case '同款':
                            var key1H =
                                (key1.currentContext?.size?.height ?? 0.0);
                            var key2H =
                                (key2.currentContext?.size?.height ?? 0.0);
                            this.animateTo((key1H + key2H) - 48 - pmPadd.top);
                            break;
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 16, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(tabList[i]),
                            SizedBox(height: 4),
                            Container(
                              width: 24,
                              height: 2,
                              color: Colors.red.withValues(
                                  alpha: (valueChange.tabIndex == i) ? 1 : 0),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              if (isGo) Spacer(),
              if (isGo) Container(width: 32, height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailLunboWidget() {
    if (detailDm.object == null || detailDm.object!.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    var imgs = detailDm.object?['goodsGalleryUrls'] ?? [];
    imgs.removeWhere((w) => w == '');
    return DetailLunboWidget(imgs);
  }

  List<Widget> get headers {
    double fee = (detailDm.object?['promotionRate'] ?? 0) *
        (detailDm.object?['minGroupPrice'] ?? 0) /
        100;
    var divi = detailDm.object?['subdivisionRank'];
    if (divi == null || divi == 0) {
      divi = 1;
    }
    return [
      Column(
        key: key1,
        children: [
          Stack(children: [
            _buildDetailLunboWidget(),
            GoodsBuyHistoryWidget(),
          ]),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/top'),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xffF7F3DB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/mall/fqb.png',
                          width: 162 / 3,
                          height: 54 / 3,
                        ),
                        SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${detailDm.object?['subdivisionName'] ?? ''}热销排行榜第',
                                style: TextStyle(
                                  color: Color(0xffB08E55),
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: ' $divi ',
                                style: TextStyle(
                                  color: Colours.pdd_main,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '名',
                                style: TextStyle(
                                  color: Color(0xffB08E55),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(56),
                            border:
                                Border.all(color: Color(0xffB08E55), width: 1),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(0.5),
                                child: Text(
                                  '查看',
                                  style: TextStyle(
                                    color: Color(0xffB08E55),
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xffB08E55),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 8, 12, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Image.asset(
                          'assets/images/mall/pdd.png',
                          width: 14,
                          height: 14,
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: getTitleWidget(detailDm.object?['goodsName'],
                            size: 16, max: 2),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 8, 12, 8),
                  child: Row(
                    children: [
                      getPriceWidget(
                        detailDm.object?['minGroupPrice'] ?? '',
                        detailDm.object?['minNormalPrice'] ?? '',
                        endTextSize: 24,
                        startPrefix: '原价 ',
                        endPrefixSize: 16,
                        endTextColor: Colours.pdd_main,
                      ),
                      Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '已售',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: '${detailDm.object?['salesTip']}',
                              style: TextStyle(
                                color: Colours.pdd_main,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (fee > 0)
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 8, 12, 8),
                    child: Row(
                      children: [
                        getMoneyWidget(context, fee, PDD,
                            column: false, priceTxtColor: Colours.pdd_main),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/mall/pdd.png',
                            width: 18,
                            height: 18,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              detailDm.object?['mallName'] ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Builder(builder: (context) {
                        Map? data = detailDm.object;
                        var servTxt = data?['servTxt'];
                        var descTxt = data?['descTxt'];
                        var shipTxt = data?['lgstTxt'];
                        return Text(
                          '描述：$descTxt   服务：$servTxt   物流：$shipTxt',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ProductInfoImgWidget(
        {
          'isExpand': false,
          'imgs': detailImgs,
          'expandColor': Colours.pdd_main
        },
        key: key2,
        imgRatio: 1,
      ),
      if (listSimilarGoodsByOpenDm.list.isNotEmpty)
        Container(
          padding: EdgeInsets.all(8),
          child: Text(
            '热销同款',
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.75),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
    ];
  }
}
