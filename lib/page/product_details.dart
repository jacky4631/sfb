/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sufenbao/models/data_model.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/util/launchApp.dart';
import 'package:sufenbao/util/tao_util.dart';
import 'package:sufenbao/widget/auth_tip.dart';
import 'package:sufenbao/widget/product_info_img_widget.dart';
import 'package:sufenbao/service.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../util/toast_utils.dart';
import '../listener/detail_value_change.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/aspect_ratio_image.dart';
import '../widget/goods_buy_history_widget.dart';
import '../widget/detail_lunbo_widget.dart';

DetailValueChange valueChange = DetailValueChange();

///产品详情
class ProductDetails extends StatefulWidget {
  final Map data;
  const ProductDetails(this.data, {Key? key}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> with AuthTip {
  ScrollController controller = ScrollController();

  List tabList = ['商品', '详情', '同款'];
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  late String goodsId = '';
  late String suffixGoodsId = '';
  late String title = '';
  late String listMainPic = '';
  late String startPrice = '0';
  late String endPrice = '0';
  late bool collect = false;
  bool loading = true;
  String sellerId = '';
  String shopName = '';
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    listMainPic = getTbMainPic(widget.data);
    goodsId = getGoodsId();
    List goodsIdSplit = goodsId.split('-');
    if (goodsIdSplit.length > 1) {
      suffixGoodsId = goodsIdSplit[1];
    } else {
      suffixGoodsId = goodsId;
    }
    await this.getDetailData();
    await this.listSimilarGoodsByOpen();
    await this.getKlData();
    await this.getShopData();
    await this.getCollect();

    valueChange.changeTabIndex(0);
    this.controllerListener();
    super.initChannelId(callback: () {
      setState(() {});
    });
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
      if (controller.offset > key1H + key2H - 56 - MediaQuery.of(context).padding.top) {
        valueChange.changeTabIndex(2);
      } else if (controller.offset > key1H - 56 - MediaQuery.of(context).padding.top) {
        valueChange.changeTabIndex(1);
      } else {
        valueChange.changeTabIndex(0);
      }
    });
  }

  ///详情数据
  var detailDm = DataModel(object: {'actualPrice': ''});
  var res;
  Future<int> getDetailData() async {
    if (goodsId.isEmpty) {
      ToastUtils.showToast('商品已下架');
      Navigator.pop(context);
    }
    res = await BService.getGoodsDetail(goodsId).catchError((v) {
      detailDm.toError('网络异常');
    });
    if (res.isNotEmpty) {
      sellerId = res['sellerId'];
      shopName = res['shopName'];
      if (listMainPic.isEmpty) {
        listMainPic = res['mainPic'];
      }
      startPrice = res['originalPrice'].toString();
      endPrice = res['actualPrice'].toString();
      title = res['dtitle'] == '' ? res['title'] : res['dtitle'];
      detailDm.addObject(res);

      setState(() {
        loading = false;
      });
    } else {
      detailDm.addObject({});
      ToastUtils.showToast('商品已下架');
      Navigator.pop(context);
    }

    return detailDm.flag;
  }

  getGoodsId() {
    //wtf 返回那么乱
    var goodsId = widget.data['goodsSign'];
    if (Global.isEmpty(goodsId)) {
      goodsId = widget.data['goodsId'];
    }
    if (Global.isEmpty(goodsId)) {
      goodsId = widget.data['goodsid'];
    }
    if (Global.isEmpty(goodsId)) {
      goodsId = widget.data['itemId'].toString();
    }
    if (Global.isEmpty(goodsId)) {
      goodsId = widget.data['itemid'].toString();
    }
    if (Global.isEmpty(goodsId)) {
      goodsId = widget.data['item_id'];
    }
    if (Global.isEmpty(goodsId)) {
      goodsId = widget.data['originalProductId'];
    }
    return goodsId.toString();
  }

  var klDm = DataModel();
  Future<int> getKlData() async {
    var res = await BService.getGoodsWord(goodsId, uid: widget.data['uid'] ?? 0);
    if (res != null) klDm.addObject(res);
    return klDm.flag;
  }

  Future getCollect() async {
    collect = await BService.collect(suffixGoodsId);
    setState(() {});
  }

  var shopDm = DataModel();
  Future<int> getShopData() async {
    if (Global.isEmpty(sellerId)) {
      sellerId = widget.data['sellerId'] ?? widget.data['seller_id'];
    }
    if (Global.isEmpty(shopName)) {
      shopName = widget.data['shopName'] ?? widget.data['ship_title'];
    }
    var res = await BService.shopConvert(sellerId, shopName);
    if (res != null) shopDm.addObject(res);
    return shopDm.flag;
  }

  ///类似商品
  var listSimilarGoodsByOpenDm = DataModel();
  Future<int> listSimilarGoodsByOpen() async {
    List res = await BService.goodsSimilarList(goodsId);
    if (res == null || res.isEmpty) {
      res = [];
    }
    listSimilarGoodsByOpenDm.addList(res, true, 0);

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
          if (showChannelWidget) createChannelAuthWidget(context, 'tb.png'),
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
      child: Global.openFadeContainer(createSimilarItem(i, v), ProductDetails(v)),
    );
  }

  tipClick() {
    Global.showChannelAuthDialog(() async {
      Navigator.pop(context);
      await Future.delayed(
        Duration(seconds: 2),
      );
      await initChannelId();
      setState(() {});
    });
  }

  Widget createSimilarItem(i, v) {
    String sale = BService.formatNum(v['monthSales']);
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
                getTbMainPic(v),
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
                Text(
                  v['dtitle'],
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '¥',
                        style: TextStyle(
                          color: Colours.app_main,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '${v['actualPrice']} ',
                        style: TextStyle(
                          color: Colours.app_main,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '¥${v['originalPrice']}',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  v['shopName'],
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
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
              BService.collectProduct(context, collect, suffixGoodsId, 'tb', listMainPic, title, startPrice, endPrice,
                      originalId: goodsId)
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
                              res['klUrl'] = klDm.object?['longTpwd'];
                              Navigator.pushNamed(context, '/sellPage', arguments: {'res': res, 'platType': 'TB'});
                            });
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colours.share_bg,
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
                            FlutterClipboard.copy(klDm.object?['longTpwd'])
                                .then((value) => ToastUtils.showToast('复制成功，打开【淘宝】领券购买'));
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colours.hb_bg,
                            ),
                            child: Center(
                              child: Text(
                                '口令购买',
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
                        onTap: () {
                          onTapDialogLogin(context, fun: launchTb);
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colours.app_main,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(56),
                              bottomRight: Radius.circular(56),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '领券购买',
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              //todo 隐藏截图
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
                                color: Colours.app_main.withValues(alpha: (valueChange.tabIndex == i) ? 1 : 0),
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
    var shopLogo = detailDm.object != null ? '${detailDm.object?['shopLogo']}' : '';
    if (!Global.isEmpty(shopLogo)) {
      //部分logo包含重复的地址，图片打不开
      if (!Global.isBlank(shopLogo) &&
          shopLogo.contains('https://gw.alicdn.com') &&
          shopLogo.contains('https://img.alicdn.com')) {
        shopLogo = shopLogo.replaceAll('https://img.alicdn.com', '');
      }
      if (shopLogo == 'https://gw.alicdn.com') {
        shopLogo =
            'https://img.alicdn.com/imgextra/i1/O1CN01t0gpBw1rDvwz5VXgK_!!6000000005598-2-tps-120-99.png_160x160Q50s50.jpg_.webp';
      }
      shopLogo = BService.formatUrl(shopLogo);
    }
    String sale = BService.formatNum(detailDm.object?['monthSales']);
    double fee = detailDm.object?['commissionRate'] * detailDm.object?['actualPrice'] / 100;
    num divi = detailDm.object?['subdivisionRank'];
    if (divi == null || divi == 0) {
      divi = 1;
    }
    var shopType = detailDm.object?['shopType'] ?? 0;
    num couponPrice = detailDm.object?['couponPrice'];
    String couponStartTime = '';
    String couponEndTime = '';
    if (couponPrice > 0) {
      couponStartTime = detailDm.object?['couponStartTime'];
      couponEndTime = detailDm.object?['couponEndTime'];
      if (!Global.isEmpty(couponStartTime)) {
        couponStartTime = couponStartTime.split(' ')[0];
      }
      if (!Global.isEmpty(couponEndTime)) {
        couponEndTime = couponEndTime.split(' ')[0];
      }
    }
    return [
      Column(
        key: key1,
        children: [
          Stack(
            children: [
              _buildDetailLunboWidget(),
              //todo 隐藏截图
              GoodsBuyHistoryWidget(),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                                  color: Colours.app_main,
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
                        padding: EdgeInsets.only(top: 4),
                        child: Image.asset(
                          'assets/images/mall/${shopType == 1 ? 'tm' : 'tb'}.png',
                          width: 14,
                          height: 14,
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: getTitleWidget(title, size: 16),
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
                        startPrefix: '原价 ',
                        endPrefixSize: 16,
                      ),
                      Spacer(),
                      Text(
                        '已售${sale}件',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 12),
                  child: Row(
                    children: [
                      getMoneyWidget(context, fee, TB, column: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (detailDm.object?['desc'] != '')
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      detailDm.object?['desc'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (detailDm.object?['couponPrice'] > 0)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colours.hb_bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GestureDetector(
                  onTap: () => launchTb(),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '¥',
                              style: TextStyle(
                                color: Colours.app_main,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '$couponPrice\t',
                              style: TextStyle(
                                color: Colours.app_main,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '优惠券使用期限',
                              style: TextStyle(
                                color: Colours.app_main,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '$couponStartTime至$couponEndTime',
                              style: TextStyle(
                                color: Colours.app_main,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          '立即领券',
                          style: TextStyle(
                            color: Colours.app_main,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                if (!Global.isEmpty(shopLogo))
                  AspectRatioImage.network(
                    shopLogo,
                    builder: (context, snapshot, url) {
                      return Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            shopLogo,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Icon(Icons.image_not_supported, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                SizedBox(width: 8),
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
                          GestureDetector(
                            onTap: () {
                              LaunchApp.launchTb(context, shopDm.object?['shopLinks']);
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(12, 6, 12, 7),
                              decoration: BoxDecoration(
                                color: Colours.yellow_bg,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '全部商品',
                                style: TextStyle(
                                  color: Colours.dark_text_color,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          var data = detailDm.object!;
                          var descScore = data['descScore'];
                          if (descScore == null ||
                              Global.isEmpty(descScore.toString()) ||
                              descScore.toString().length == 5) {
                            descScore = 4.8;
                          }
                          var shipScore = data['shipScore'];
                          if (shipScore == null || shipScore == 0 || Global.isEmpty(shipScore.toString())) {
                            shipScore = 4.8;
                          }
                          var serviceScore = data['serviceScore'];
                          if (serviceScore == null || serviceScore == 0 || Global.isEmpty(serviceScore.toString())) {
                            serviceScore = 4.8;
                          }
                          return Text(
                            '描述：$descScore   卖家：$serviceScore   物流：$shipScore',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ProductInfoImgWidget({'isExpand': false, 'imgs': getDetailImages()}, key: key2),
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

  getBannerImages() {
    List imgs = '${detailDm.object?['imgs'] ?? ''}'.trim().split(',');
    imgs.removeWhere((w) => w == '');
    imgs.insert(0, listMainPic);
    return imgs;
  }

  getDetailImages() {
    if (detailDm.object?['detailPics'] == '') {
      return getBannerImages();
    }
    return detailDm.object?['detailPics'];
  }

  Future launchTb() async {
    var clickUrl = klDm.object?['couponClickUrl'];
    if (clickUrl == '') {
      clickUrl = klDm.object?['itemUrl'];
    }
    //百川官方sdk 会显示返回按钮
    // FlutterAlibc.openByUrl(url: clickUrl,
    //     schemeType:AlibcSchemeType.AlibcSchemeTaoBao,
    //     backUrl: 'alisdk://');
    //
    LaunchApp.launch(context, clickUrl, LaunchApp.taobao, color: Color(0XFFFF5E00));
  }
}
