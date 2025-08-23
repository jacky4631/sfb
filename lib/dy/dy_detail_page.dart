/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sufenbao/models/data_model.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/util/launchApp.dart';
import 'package:sufenbao/widget/product_info_img_widget.dart';
import 'package:sufenbao/service.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../util/toast_utils.dart';
import '../listener/detail_value_change.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/goods_buy_history_widget.dart';
import '../widget/detail_lunbo_widget.dart';
import '../widget/loading.dart';

DetailValueChange valueChange = DetailValueChange();

///产品详情
class DyDetailPage extends StatefulWidget {
  final Map data;
  const DyDetailPage(this.data, {Key? key}) : super(key: key);
  @override
  _DyDetailPageState createState() => _DyDetailPageState();
}

class _DyDetailPageState extends State<DyDetailPage> {
  ScrollController controller = ScrollController();
  List tabList = ['商品', '详情', '同款'];
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  String goodsId = '';
  String title = '';
  String img = '';
  String startPrice = '0';
  String endPrice = '0';
  bool collect = false;
  bool loading = true;
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.getDetailData();
    await this.listSimilarGoodsByOpen();
    await this.getCollect();
    valueChange.changeTabIndex(0);
    this.controllerListener();
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
  var detailDm = DataModel(object: {
    'price': '',
    'sales': 0,
    'shopTotalScore': {'productScore': {}, 'serviceScore': {}, 'logisticsScore': {}}
  });
  Future<int> getDetailData() async {
    res = await BService.dyGoodsDetail(getGoodsId()).catchError((v) {
      detailDm.toError('网络异常');
      return {};
    });
    if (res.isNotEmpty) {
      Map detail = res['list'][0];
      detailDm.addObject(detail);
      await this.getKlData();
      setState(() {
        loading = false;
      });
      img = detail['cover'];
      title = detail['title'];
      endPrice = detail['couponPrice'] > 0 ? detail['couponPrice'].toString() : detail['price'].toString();
      startPrice = detail['price'].toString();
    } else {
      ToastUtils.showToast('商品已下架');
      Navigator.pop(context);
    }

    return detailDm.flag;
  }

  Future getCollect() async {
    collect = await BService.collect(goodsId);
    setState(() {});
  }

  getGoodsId() {
    goodsId = widget.data['product_id'] ?? widget.data['productId'] ?? widget.data['itemId'] ?? widget.data['item_id'];
    return goodsId;
  }

  var klDm = DataModel();
  Future<int> getKlData() async {
    var res = await BService.dyWord(detailDm.object?['detailUrl'], uid: widget.data['uid'] ?? 0);
    if (res != null) klDm.addObject(res);
    return klDm.flag;
  }

  ///类似商品
  var listSimilarGoodsByOpenDm = DataModel();
  Future<int> listSimilarGoodsByOpen() async {
    Random random = Random.secure();
    //获取指定范围内的 int 类型随机数
    //这里是 0~100
    int randomInt = random.nextInt(60);
    var res = await BService.dyList(0, randomInt, firstCid: detailDm.object?['firstCid'], pageSize: 10, searchType: 1)
        .catchError((v) {
      listSimilarGoodsByOpenDm.toError('网络异常');
      return null;
    });
    if (res != null) {
      listSimilarGoodsByOpenDm.addList(res['products'], true, 0);
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

    return DetailLunboWidget(getBannerImages());
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
      child: Global.openFadeContainer(createSimilarItem(i, v), DyDetailPage(v)),
    );
  }

  Widget createSimilarItem(i, v) {
    String sales = BService.formatNum(v['sales']);
    double price = v['price'] / 100;
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
                '${v['cover']}',
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
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Image.asset(
                        'assets/images/mall/dy.png',
                        width: 14,
                        height: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        v['title'],
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.75),
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
                        text: ' 抢购价 ',
                        style: TextStyle(
                          color: Colours.app_main,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: '¥',
                        style: TextStyle(
                          color: Colours.dy_main,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '$price',
                        style: TextStyle(
                          color: Colours.dy_main,
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
                        text: sales,
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: '+',
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
                  v['shop_name'],
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
          8,
          8,
          8,
          MediaQuery.of(context).padding.bottom + 8,
        ),
        child: Row(
          children: [
            SizedBox(width: 4),
            createBottomBackArrow(context),
            SizedBox(width: 8),
            btmBtnView('收藏', Icons.star_rate_rounded, () {
              BService.collectProduct(context, collect, goodsId, 'dy', img, title, startPrice, endPrice).then((value) {
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
                              res['list'][0]['klUrl'] = klDm.object?['dyPassword'];
                              Navigator.pushNamed(context, '/sellPage',
                                  arguments: {'res': res['list'][0], 'platType': 'DY'});
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
                    if (showShareBuy)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            FlutterClipboard.copy(klDm.object?['dyPassword'])
                                .then((value) => ToastUtils.showToast('复制成功，请打开【抖音app】下单'));
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colours.dy_main.withValues(alpha: 0.75),
                            ),
                            child: Center(
                              child: Text(
                                '口令购买',
                                style: TextStyle(
                                  color: Colors.white,
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
                        onTap: () {
                          onTapDialogLogin(context, fun: () {
                            launch(false);
                          });
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colours.dy_main,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(56),
                              bottomRight: Radius.circular(56),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '立即购买',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
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

  Future launch(showLoading) async {
    if (klDm.object == null) {
      if (!showLoading) {
        Loading.show(context);
      }
      await Future.delayed(Duration(milliseconds: 300));
      launch(true);
    } else {
      if (klDm.object!.isEmpty) {
        ToastUtils.showToast('该商品暂不支持购买');
        return;
      }
      if (showLoading) {
        Loading.hide(context);
      }
      LaunchApp.launchDy(context, klDm.object?['dyDeeplink'], klDm.object?['dyZlink']);
    }
  }

  void animateTo(offset) {
    return controller.jumpTo(offset ?? 0.0);
    // return controller.animateTo(offset ?? 0.0, duration: Duration(milliseconds: 500), curve: Curves.easeOutCubic);
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
                    if (i == 1 && ['', null].contains(getDetailImages())) {
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
                        padding: EdgeInsets.fromLTRB(0, 0, 16, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(tabList[i]),
                            SizedBox(height: 4),
                            Container(
                              width: 24,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colours.dy_main.withValues(alpha: (valueChange.tabIndex == i) ? 1 : 0),
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
    String sales = BService.formatNum(detailDm.object?['sales']);

    num fee = detailDm.object?['cosFee'];
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
                                  color: Colours.dy_main,
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
                          'assets/images/mall/dy.png',
                          width: 14,
                          height: 14,
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: getTitleWidget(
                          detailDm.object?['title'] ?? '',
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
                        endPrice,
                        startPrice,
                        endTextSize: 24,
                        endPrefix: '抢购价',
                        endTextColor: Colours.dy_main,
                        endPrefixSize: 16,
                        endPrefixColor: Colours.dy_main,
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
                              text: sales,
                              style: TextStyle(
                                color: Colours.dy_main,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: '+',
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
                ),
                if (fee != 0)
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 12),
                    child: Row(
                      children: [
                        getMoneyWidget(
                          context,
                          fee,
                          DY,
                          column: false,
                          priceTxtColor: Colours.dy_main,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              detailDm.object?['shopName'] ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (detailDm.object?['shopTotalScore'] != null) SizedBox(height: 16),
                      if (detailDm.object?['shopTotalScore'] != null)
                        Builder(
                          builder: (context) {
                            return Text(
                              getScoreText(),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      SizedBox(height: 16),
                      Text(
                        detailDm.object?['logisticsInfo'] ?? '',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
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
      ProductInfoImgWidget(
        {'isExpand': false, 'imgs': getDetailImages(), 'expandColor': Colours.dy_main},
        key: key2,
        imgRatio: 1,
      ),
      listSimilarGoodsByOpenDm.list.length == 0
          ? SizedBox()
          : Container(
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  '热销同款',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    ];
  }

  getScoreText() {
    if (detailDm.object?['shopTotalScore'] == null) {
      return '';
    }
    var data = detailDm.object?['shopTotalScore'];
    var pScore = data['productScore'];
    var serviceScore = data['serviceScore'];
    var logisticsScore = data['logisticsScore'];

    return '描述：${pScore['score'] ?? ''}   卖家：${serviceScore['score'] ?? ''}   物流：${logisticsScore['score'] ?? ''}';
  }

  getBannerImages() {
    return detailDm.object?['imgs'];
  }

  getDetailImages() {
    return detailDm.object?['imgs'];
  }
}
