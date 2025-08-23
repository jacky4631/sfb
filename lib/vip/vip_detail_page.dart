/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:sufenbao/models/data_model.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/util/launchApp.dart';
import 'package:sufenbao/widget/product_info_img_widget.dart';
import 'package:sufenbao/service.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../listener/detail_value_change.dart';
import '../util/toast_utils.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/goods_buy_history_widget.dart';
import '../widget/detail_lunbo_widget.dart';
import '../widget/loading.dart';

DetailValueChange valueChange = DetailValueChange();

///唯品会详情
class VipDetailPage extends StatefulWidget {
  final Map data;
  const VipDetailPage(this.data, {Key? key}) : super(key: key);
  @override
  _VipDetailPageState createState() => _VipDetailPageState();
}

class _VipDetailPageState extends State<VipDetailPage> {
  ScrollController controller = ScrollController();
  List tabList = ['商品', '详情', '同款'];
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  late String goodsId = '';
  late String title = '';
  late String img = '';
  late String startPrice = '0';
  late String endPrice = '0';
  late bool collect = false;
  Map klMap = {};
  final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    valueChange.changeTabIndex(0);
    this.controllerListener();
    await this.getDetailData();
    await this.getCollect();
    await this.listSimilarGoodsByOpen();
  }

  Future getCollect() async {
    collect = await BService.collect(goodsId);
    setState(() {});
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
      if (controller.offset > key1H + key2H - 56 - MediaQuery.of(context).padding.top) {
        valueChange.changeTabIndex(2);
      } else if (controller.offset > key1H - 56 - MediaQuery.of(context).padding.top) {
        valueChange.changeTabIndex(1);
      } else {
        valueChange.changeTabIndex(0);
      }
    });
  }

  var res;

  ///详情数据
  var detailDm = DataModel();
  Future<int> getDetailData() async {
    if (widget.data['category'] == 'vip') {
      //说明是从收藏进入详情
      //从订单跳转
      if (widget.data['detailList'] != null && (widget.data['detailList'] as List).isNotEmpty) {
        goodsId = widget.data['detailList'][0]['goodsId'] ?? '';
      } else {
        goodsId = widget.data['productId'] ?? widget.data['itemId'] ?? '';
      }
      if (goodsId.isEmpty) {
        ToastUtils.showToast('商品已下架');
        Navigator.pop(context);
      }

      res = await BService.vipGoodsDetail(goodsId);
      if (res != null) {
        detailDm.addObject(res);
        img = res['goodsMainPicture'];
        title = res['goodsName'];
        endPrice = res['marketPrice'];
        startPrice = res['vipPrice'];

        setState(() {});
        klMap = await BService.goodsWordVIP(res['destUrl'], res['adCode'], uid: widget.data['uid']);
      }
      ;
    } else {
      detailDm.addObject(widget.data);

      setState(() {});
      goodsId = widget.data['goodsId'];
      img = widget.data['goodsMainPicture'];
      title = widget.data['goodsName'];
      startPrice = widget.data['marketPrice'];
      endPrice = widget.data['vipPrice'];

      klMap = await BService.goodsWordVIP(widget.data['destUrl'], widget.data['adCode']);
    }

    return detailDm.flag;
  }

  var listSimilarGoodsByOpenDm = DataModel();
  Future<int> listSimilarGoodsByOpen() async {
    var res = await BService.vipSearch(
      1,
      keyword: title,
    ).catchError((v) {
      listSimilarGoodsByOpenDm.toError('网络异常');
    });
    if (res != null) {
      listSimilarGoodsByOpenDm.addList(res['goodsInfoList'], false, res['total']);
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
          CustomScrollView(
            controller: controller,
            slivers: [
              if (detailDm.object != null) ...[
                SliverList(
                  delegate: SliverChildListDelegate(headers),
                ),
                if (listSimilarGoodsByOpenDm.list.isNotEmpty)
                  SliverWaterfallFlow(
                    gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        var v = listSimilarGoodsByOpenDm.list[i];
                        return _buildSimilarItemContainer(i, v);
                      },
                      childCount: listSimilarGoodsByOpenDm.list.length,
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 70,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                ),
              ] else
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
          titleBarView(),
          btmBarView(),
        ]),
      ),
    );
  }

  Widget _buildDetailLunboWidget() {
    if (detailDm.object == null) {
      return Container(
        width: double.infinity,
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    var imgs = detailDm.object?['goodsCarouselPictures'];
    return DetailLunboWidget(imgs);
  }

  Widget _buildSimilarItemContainer(int i, dynamic v) {
    return Container(
      margin: EdgeInsets.only(
        top: [0, 1].contains(i) ? 0 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Global.openFadeContainer(createSimilarItem(i, v), VipDetailPage(v)),
    );
  }

  Widget createSimilarItem(i, v) {
    String img = v['goodsThumbUrl'];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/mall/vip.png',
                      width: 14,
                      height: 14,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        v['goodsName'],
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.75),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                          color: Colours.vip_main,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '${v['vipPrice']}',
                        style: TextStyle(
                          color: Colours.vip_main,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
      bottom: detailDm.object == null || detailDm.object!.isEmpty ? -64 : 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(8, 8, 8, MediaQuery.of(context).padding.bottom + 8),
        child: Row(
          children: [
            SizedBox(width: 4),
            createBottomBackArrow(context),
            SizedBox(width: 8),
            btmBtnView('收藏', Icons.star_rate_rounded, () {
              BService.collectProduct(context, collect, goodsId, 'vip', img, title, startPrice, endPrice).then((value) {
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
                              Map data = res ?? widget.data;
                              //为了配合后端查券接口
                              data['klUrl'] = Uri.encodeComponent('mst.vip.com?goodsId=$goodsId');
                              Navigator.pushNamed(context, '/sellPage', arguments: {'res': data, 'platType': 'VIP'});
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
                          launchVip(false);
                        }),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colours.vip_main,
                            borderRadius: BorderRadius.circular(56),
                          ),
                          child: Center(
                            child: Text(
                              '立即购买',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
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

  Future launchVip(showLoading) async {
    if (klMap['deeplinkUrl'] == null) {
      if (!showLoading) {
        Loading.show(context);
      }
      await Future.delayed(Duration(milliseconds: 300));
      launchVip(true);
    } else {
      if (showLoading) {
        Loading.hide(context);
      }
      LaunchApp.launchVip(context, klMap['deeplinkUrl'], klMap['longUrl'], fun: () async {
        //唤起微信小程序
        bool installed = await fluwx.isWeChatInstalled;
        if (installed) {
          fluwx.open(
              target: MiniProgram(
            username: 'gh_8ed2afad9972',
            path: klMap['vipWxUrl'],
          ));
        } else {
          LaunchApp.launchWebView(context, klMap['longUrl'], color: Colours.vip_main);
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
          height: 56 + MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            color: isGo ? Colors.white : null,
          ),
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.of(context).padding.top + 8,
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
                    if (i == 1 && ['', null].contains(detailDm.object?['goodsDetailPictures'])) {
                      return SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: () {
                        valueChange.changeTabIndex(i);
                        switch (tabList[i]) {
                          case '商品':
                            animateTo(0.0);
                            break;
                          case '详情':
                            animateTo(
                                (key1.currentContext?.size?.height ?? 0.0) - 48 - MediaQuery.of(context).padding.top);
                            break;
                          case '同款':
                            var key1H = (key1.currentContext?.size?.height ?? 0.0);
                            var key2H = (key2.currentContext?.size?.height ?? 0.0);
                            animateTo((key1H + key2H) - 48 - MediaQuery.of(context).padding.top);
                            break;
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(tabList[i]),
                            SizedBox(height: 4),
                            Container(
                              width: 24,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity((valueChange.tabIndex == i) ? 1 : 0),
                              ),
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

  List<Widget> get headers {
    List imageList = detailDm.object?['goodsDetailPictures'] ?? [];
    Map storeInfo = detailDm.object?['storeInfo'] ?? {};
    String storeName = '';
    if (storeInfo != null) {
      storeName = storeInfo['storeName'];
    }
    double fee = double.parse(detailDm.object?['commission']);
    var divi = detailDm.object?['subdivisionRank'];
    if (divi == null || divi == 0) {
      divi = 1;
    }
    return [
      Column(
        key: key1,
        children: [
          Stack(
            children: [
              _buildDetailLunboWidget(),
              GoodsBuyHistoryWidget(),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xffF7F3DB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/top'),
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
                                text: '${detailDm.object?['subdivisionName'] ?? ''}热销排行榜第',
                                style: TextStyle(
                                  color: Color(0xffB08E55),
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: ' $divi ',
                                style: TextStyle(
                                  color: Colours.vip_main,
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
                            border: Border.all(
                              color: Color(0xffB08E55),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.5),
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
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Image.asset(
                          'assets/images/mall/vip.png',
                          width: 14,
                          height: 14,
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: getTitleWidget(
                          detailDm.object?['goodsName'] ?? '',
                          size: 16,
                          max: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 12),
                  child: Row(
                    children: [
                      getPriceWidget(
                        detailDm.object?['vipPrice'] ?? '',
                        detailDm.object?['marketPrice'] ?? '',
                        endTextSize: 24,
                        endPrefix: '折扣价 ',
                        endPrefixSize: 16,
                        startPrefix: '原价',
                        endPrefixColor: Colours.vip_main,
                        endTextColor: Colours.vip_main,
                      ),
                    ],
                  ),
                ),
                if (fee != 0)
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 12),
                    child: Row(
                      children: [
                        getMoneyWidget(
                          context,
                          fee,
                          VIP,
                          column: false,
                          priceTxtColor: Colours.vip_main,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                if (detailDm.object?['brandLogoFull'] != null)
                  Container(
                    width: 80,
                    height: 40,
                    padding: EdgeInsets.fromLTRB(2, 2, 4, 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(
                      detailDm.object?['brandLogoFull'],
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                if (detailDm.object?['brandLogoFull'] != null) SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              storeName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ProductInfoImgWidget(
        {'isExpand': false, 'imgs': imageList, 'expandColor': Colours.vip_main},
        key: key2,
        imgRatio: 1.1,
      ),
      listSimilarGoodsByOpenDm.list.length == 0
          ? SizedBox()
          : Container(
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  '热销同款',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    ];
  }
}
