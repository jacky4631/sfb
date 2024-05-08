/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/util/launchApp.dart';
import 'package:sufenbao/util/tao_util.dart';
import 'package:sufenbao/widget/auth_tip.dart';
import 'package:sufenbao/widget/product_info_img_widget.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../util/toast_utils.dart';
import '../util/paixs_fun.dart';
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

class _ProductDetailsState extends State<ProductDetails> with AuthTip{
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
    if(goodsIdSplit.length > 1) {
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
    super.initChannelId(callback: (){
      setState(() {

      });
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
      if(key1.currentContext != null) {
        key1H = (key1.currentContext?.size?.height) ?? 0.0;
      }
      if(key2.currentContext != null) {
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

  ///详情数据
  var detailDm = DataModel<Map>(object: {'actualPrice': ''});
  var res;
  Future<int> getDetailData() async {
    if(goodsId == null) {
      ToastUtils.showToast('商品已下架');
      Navigator.pop(context);
    }
     res = await BService.getGoodsDetail(goodsId)
        .catchError((v) {
      detailDm.toError('网络异常');
    });
    if (res.isNotEmpty) {
      sellerId = res['sellerId'];
      shopName = res['shopName'];
      if(listMainPic.isEmpty) {
        listMainPic = res['mainPic'];
      }
      startPrice = res['originalPrice'].toString();
      endPrice = res['actualPrice'].toString();
      title = res['dtitle']==''? res['title']: res['dtitle'];
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
    if(Global.isEmpty(goodsId)) {
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
    if(Global.isEmpty(goodsId)) {
      goodsId = widget.data['item_id'];
    }
    if(Global.isEmpty(goodsId)) {
      goodsId = widget.data['originalProductId'];
    }
    return goodsId.toString();
  }

  var klDm = DataModel<Map>();
  Future<int> getKlData() async {
    var res = await BService.getGoodsWord(goodsId, uid: widget.data['uid']??0);
    if (res != null) klDm.addObject(res);
    return klDm.flag;
  }
  Future getCollect() async {
    collect = await BService.collect(suffixGoodsId);
    setState(() {
    });
  }
  var shopDm = DataModel<Map>();
  Future<int> getShopData() async {
    if(Global.isEmpty(sellerId)) {
      sellerId = widget.data['sellerId']??widget.data['seller_id'];
    }
    if(Global.isEmpty(shopName)) {
      shopName = widget.data['shopName']??widget.data['ship_title'];
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
    return ScaffoldWidget(
      // brightness: Brightness.light,
      bgColor: Color(0xffF3F3F3),
      body: Stack(children: [
        loading ? Global.showLoading2() : MyCustomScroll(
          isGengduo: false,
          isShuaxin: false,
          headers: headers,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          controller: controller,
          itemPadding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 70),
          itemModel: listSimilarGoodsByOpenDm,
          itemModelBuilder: (i, v) {
            return PWidget.container(
              Global.openFadeContainer(createSimilarItem(i, v), ProductDetails(v)),
              [null, null, Colors.white],
              {'crr': 8, 'mg': PFun.lg(PFun.lg2(0, 1).contains(i) ? 0 : 10)},
            );
          },
        ),
        titleBarView(),
        btmBarView(),
        if(showChannelWidget)
          createChannelAuthWidget('tb.png'),

      ]),
    );
  }
  tipClick(){
    Global.showChannelAuthDialog(() async {
      Navigator.pop(context);
      await Future.delayed(Duration(seconds: 2), );
      await initChannelId();
      setState(() {

      });
    });
  }

  Widget createSimilarItem(i, v) {
    String sale = BService.formatNum(v['monthSales']);
    return PWidget.container(
      PWidget.column([
        PWidget.wrapperImage(getTbMainPic(v), {'ar': 1 / 1}),
        PWidget.container(
          PWidget.column([
            PWidget.text(v['dtitle'],
                [Colors.black.withOpacity(0.75)], {}),
            PWidget.boxh(8),
            PWidget.text('', [], {}, [
              PWidget.textIs('¥', [Colours.app_main, 12, true]),
              PWidget.textIs(
                  '${v['actualPrice']} ', [Colours.app_main, 16, true]),
              PWidget.textIs('¥${v['originalPrice']}', [Colors.black45, 12],
                  {'td': TextDecoration.lineThrough})
            ]),
            PWidget.boxh(8),
            PWidget.text(v['shopName'], [Colors.black45, 12]),
            PWidget.boxh(8),
            PWidget.text('', [], {}, [
              PWidget.textIs('已售', [Colors.black45, 12]),
              PWidget.textIs(
                  sale, [Colors.black45, 12]),
              PWidget.textIs('+', [Colors.black45, 12]),
            ]),
          ]),
          {'pd': 8},
        ),
      ]),
      [null, null, Colors.white],
    );
  }
  ///底部操作栏
  Widget btmBarView() {
    return PWidget.positioned(
      PWidget.container(
        PWidget.row([
          PWidget.boxw(4),
          createBottomBackArrow(context),
          PWidget.boxw(8),
          btmBtnView('收藏', Icons.star_rate_rounded, () {
            BService.collectProduct(context, collect, suffixGoodsId,
                'tb', listMainPic, title, startPrice, endPrice, originalId: goodsId).then((value){
                getCollect();
            });
          }),
          PWidget.boxw(24),
          PWidget.container(
            PWidget.row([
              if(showShareBuy)
              PWidget.container(
                PWidget.text('转卖', [Colours.app_main, 14, true], {'ct': true}),
                [null, null, Colours.share_bg],
                {
                  'exp': true,
                  'fun': () {
                    res['klUrl'] = klDm.object?['longTpwd'];
                    Navigator.pushNamed(context, '/sellPage', arguments: {'res':res,'platType':'TB'});
                    // onTapDialogLogin(context, fun: share)
                  }
                },
              ),
              if(showShareBuy)
              PWidget.container(
                PWidget.text('口令购买', [Colours.app_main, 14, true], {'ct': true}),
                [null, null, Colours.hb_bg],
                {
                  'exp': true,
                  'fun': () => {
                    FlutterClipboard.copy(klDm.object?['longTpwd']).then(
                            (value) =>
                            ToastUtils.showToast('复制成功，打开【淘宝】领券购买'))
                  }
                },
              ),
              PWidget.container(
                PWidget.text('领券购买', [Colors.white, 14,true], {'ct': true}),
                [null, null, Colours.app_main],
                {
                  'exp': true,
                  'fun': () {
                    onTapDialogLogin(context, fun: launchTb);
                  }

                },
              ),
            ]),
            [null, 45],
            {'crr': 56, 'exp': true},
          ),
        ]),
        [null, null, Colors.white],
        {'pd': [8,MediaQuery.of(context).padding.bottom+8,8,8],},
      ),
      [null, detailDm.object!.isEmpty ? -64 : 0, 0, 0],
    );
  }

  Widget btmBtnView(name, icon, fun) {

    return PWidget.column(
      [
        PWidget.icon(icon ?? Icons.star_rate_rounded, PFun.lg1(Colours.getCollectColor(name, collect))),
        PWidget.boxh(4),
        PWidget.text(name ?? '收藏', PFun.lg1(Colors.black45))
      ],
      '000',
      {'fun': fun},
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
        return PWidget.container(
          PWidget.row([
            //todo 隐藏截图
            PWidget.container(
              PWidget.icon(Icons.keyboard_arrow_left_rounded,
                  [isGo ? Colors.black : Colors.white]),
              [32, 32, if (!isGo) Colors.black26],
              {'br': 56, 'fun': () => Navigator.pop(context)},
            ),
            if (isGo) PWidget.spacer(),
            if (isGo)
              PWidget.row(
                List.generate(tabList.length, (i) {
                  if (i == 1 && ['', null].contains(getDetailImages())) {
                    return PWidget.boxh(0);
                  }
                  return PWidget.container(
                    PWidget.column([
                      PWidget.text(tabList[i]),
                      PWidget.boxh(4),
                      PWidget.container(null, [
                        24,
                        2,
                        Colours.app_main
                            .withOpacity((valueChange.tabIndex == i) ? 1 : 0)
                      ]),
                    ], '221'),
                    {
                      'pd': PFun.lg(0, 0, 16, 16),
                      'fun': () {
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
                    },
                  );
                }),
              ),
            if (isGo) PWidget.spacer(),
            if (isGo) PWidget.container(null, [32, 32]),
          ]),
          [null, 56 + pmPadd.top, if (isGo) Colors.white],
          {
            'pd': PFun.lg(pmPadd.top + 8, 8, 16, 16),
          },
        );
      },
    );
  }

  List<Widget> get headers {
    var shopLogo =
    detailDm.object != null ? '${detailDm.object?['shopLogo']}' : '';
    if(!Global.isEmpty(shopLogo)) {
      //部分logo包含重复的地址，图片打不开
      if(!Global.isBlank(shopLogo)
          && shopLogo.contains('https://gw.alicdn.com')
          && shopLogo.contains('https://img.alicdn.com')) {
        shopLogo = shopLogo.replaceAll('https://img.alicdn.com', '');
      }
      if(shopLogo == 'https://gw.alicdn.com') {
        shopLogo = 'https://img.alicdn.com/imgextra/i1/O1CN01t0gpBw1rDvwz5VXgK_!!6000000005598-2-tps-120-99.png_160x160Q50s50.jpg_.webp';
      }
      shopLogo = BService.formatUrl(shopLogo);
    }
    String sale = BService.formatNum(detailDm.object?['monthSales']);
    double fee = detailDm.object?['commissionRate'] * detailDm.object?['actualPrice'] / 100;
    num divi = detailDm.object?['subdivisionRank'];
    if(divi == null || divi == 0) {
      divi = 1;
    }
    var shopType = detailDm.object?['shopType']??0;
    num couponPrice = detailDm.object?['couponPrice'];
    String couponStartTime = '';
    String couponEndTime = '';
    if(couponPrice > 0) {
      couponStartTime = detailDm.object?['couponStartTime'];
      couponEndTime = detailDm.object?['couponEndTime'];
      if(!Global.isEmpty(couponStartTime)) {
        couponStartTime = couponStartTime.split(' ')[0];
      }
      if(!Global.isEmpty(couponEndTime)) {
        couponEndTime = couponEndTime.split(' ')[0];
      }
    }
    return [
      PWidget.column([
        Stack(children: [
          AnimatedSwitchBuilder(
            value: detailDm,
            errorOnTap: () => this.getDetailData(),
            isAnimatedSize: false,
            initialState: PWidget.container(null, [double.infinity, 200]),
            objectBuilder: (v) {
              return DetailLunboWidget(getBannerImages());
            },
          ),
          //todo 隐藏截图
          GoodsBuyHistoryWidget(),
        ]),
        PWidget.container(
          PWidget.column([
            PWidget.container(
              PWidget.row([
                PWidget.image('assets/images/mall/fqb.png', [162 / 3, 54 / 3]),
                PWidget.boxw(8),
                PWidget.text('', [], {}, [
                  PWidget.textIs(
                      '${detailDm.object?['subdivisionName'] ?? ''}热销排行榜第',
                      [Color(0xffB08E55), 12]),
                  PWidget.textIs(
                      ' ${divi} ',
                      [Colours.app_main, 12, true]),
                  PWidget.textIs('名', [Color(0xffB08E55), 12]),
                ]),
                PWidget.spacer(),
                PWidget.container(
                  PWidget.row([
                    PWidget.text(
                        '查看', [Color(0xffB08E55), 10], {'pd': PFun.lg(0.5)}),
                    PWidget.icon(
                        Icons.chevron_right_rounded, [Color(0xffB08E55), 16]),
                  ]),
                  {
                    'pd': PFun.lg(0, 0, 8, 0),
                    'br': 56,
                    'bd': PFun.bdAllLg(Color(0xffB08E55), 1)
                  },
                ),
              ]),
              [null, null, Color(0xffF7F3DB)],
              {
                'pd': 12,
                'br': 8,
                'mg': [8,8,8,0],
                'fun': () => {Navigator.pushNamed(context, '/top')}
              },
            ),
            PWidget.container(
              PWidget.row([
                PWidget.image('assets/images/mall/${shopType == 1 ? 'tm' : 'tb'}.png', [14, 14],{'pd':[4,0,0,0]}),
                PWidget.boxw(4),
                getTitleWidget(title, size: 16)
              ]),
              {'pd': [8,8,12,0]},
            ),
            PWidget.container(
              PWidget.row([
                getPriceWidget(endPrice, startPrice, endTextSize: 24, startPrefix: '原价 ',
                endPrefixSize: 16),
                PWidget.spacer(),
                PWidget.text('已售$sale件', [Colors.black45, 12], {},),
              ]),
              {'pd': [8,8,12,0]},
            ),
            PWidget.container(PWidget.row([
              getMoneyWidget(context, fee, TB, column: false),
            ]),
              {'pd': [8,0,12,8]},
            ),
          ]),
          [null, null, Colors.white],
          {'pd': [0,0,0,8]},
        ),
        detailDm.object?['desc'] == '' ? SizedBox() :
        PWidget.container(
          PWidget.row([
            PWidget.textNormal(detailDm.object?['desc'], {'isOf': false,'exp':true})
          ]),
          [null, null, Colors.white],
          {'pd': 16,},
        ),
        if(detailDm.object?['couponPrice'] > 0)
          PWidget.container(
            PWidget.container(PWidget.row([
            PWidget.boxw(10),
            PWidget.text('', [], {}, [
              PWidget.textIsNormal('¥', [Colours.app_main, 16, true]),
              PWidget.textIsNormal('$couponPrice\t',
                  [Colours.app_main, 24, true]),
            ]),
            PWidget.boxw(10),
            PWidget.column([
              PWidget.textNormal('优惠券使用期限', [Colours.app_main, 14, true], {'ct': true}),
              PWidget.boxh(4),
              PWidget.textNormal('$couponStartTime至$couponEndTime', [Colours.app_main]),
            ], {
              'exp': 1
            }),
            PWidget.textNormal('立即领券', [Colours.app_main, 14, true], {'pd': 24}),
          ]),
          [null, null, Colours.hb_bg],
          {
            'mg': 8,
            'br': 8,
            'fun': () => launchTb()
          },
        ),
          [null, null, Colors.white],
        ),
        PWidget.container(
          PWidget.row([
            Global.isEmpty(shopLogo)
                ? SizedBox()
                :     AspectRatioImage.network(shopLogo,  builder: (context, snapshot, url){
              return PWidget.wrapperImage(shopLogo, [56, 56], {'br': 8}
              );
            }),
            PWidget.boxw(8),
            PWidget.column([
              PWidget.row([
                PWidget.text(detailDm.object?['shopName'], [Colors.black, 14, true],
                    {'exp': true}),
                PWidget.container(
                  PWidget.text('全部商品', [Colours.dark_text_color]),
                  [null, null, Colours.yellow_bg],
                  {'pd': PFun.lg(6, 7, 12, 12), 'br': 16,'fun':(){
                    LaunchApp.launchTb(context, shopDm.object?['shopLinks']);
                  }},
                ),
              ]),
              PWidget.boxh(8),
              Builder(builder: (context) {
                var data = detailDm.object!;
                var descScore = data['descScore'];
                if(descScore == null || Global.isEmpty(descScore.toString()) || descScore.toString().length == 5) {
                  descScore = 4.8;
                }
                var shipScore = data['shipScore'];
                if(shipScore == null || shipScore == 0 || Global.isEmpty(shipScore.toString())) {
                  shipScore = 4.8;
                }
                var serviceScore = data['serviceScore'];
                if(serviceScore == null || serviceScore == 0  || Global.isEmpty(serviceScore.toString())) {
                  serviceScore = 4.8;
                }
                return PWidget.text(
                    '描述：$descScore   卖家：$serviceScore   物流：$shipScore', [Colors.black54]);
              }),
            ], {
              'exp': 1,
            }),
          ]),
          [null, null, Colors.white],
          {'pd': 16},
        ),
      ], null, null, key1),
      ProductInfoImgWidget({'isExpand':false, 'imgs': getDetailImages()}, key: key2),
      listSimilarGoodsByOpenDm.list.length == 0
          ? SizedBox()
          : PWidget.text('热销同款', [Colors.black.withOpacity(0.75), 16, true],
          {'ct': true, 'pd': PFun.lg(8)}),
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
    if(clickUrl == '') {
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
