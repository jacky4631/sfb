/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:math';

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
import 'package:sufenbao/widget/product_info_img_widget.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../util/paixs_fun.dart';
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
  var res;
  ///详情数据
  var detailDm = DataModel<Map>(object: {'price': '', 'sales': 0, 'shopTotalScore':{'productScore': {}, 'serviceScore':{}, 'logisticsScore':{}}});
  Future<int> getDetailData() async {
     res = await BService.dyGoodsDetail(getGoodsId()).catchError((v) {
      detailDm.toError('网络异常');
    });
    if (res.isNotEmpty) {
      Map detail = res['list'][0];
      detailDm.addObject(detail);
      await this.getKlData();
      setState(() {
        loading =false;
      });
      img = detail['cover'];
      title = detail['title'];
      endPrice = detail['couponPrice'] > 0 ? detail['couponPrice'].toString() : detail['price'].toString();
      startPrice = detail['price'].toString();
    }else {
      ToastUtils.showToast('商品已下架');
      Navigator.pop(context);
    }

    return detailDm.flag;
  }
  Future getCollect() async {
    collect = await BService.collect(goodsId);
    setState(() {
    });
  }
  getGoodsId() {
    goodsId = widget.data['product_id']??widget.data['productId']??widget.data['itemId']??widget.data['item_id'];
    return goodsId;
  }

  var klDm = DataModel<Map>();
  Future<int> getKlData() async {
    var res = await BService.dyWord(detailDm.object?['detailUrl'], uid: widget.data['uid']??0);
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
    var res = await BService.dyList(0, randomInt, firstCid: detailDm.object?['firstCid'], pageSize: 10, searchType: 1).catchError((v) {
      listSimilarGoodsByOpenDm.toError('网络异常');
    });
    if (res != null) {
      listSimilarGoodsByOpenDm.addList(res['products'], true, 0);
    }
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
              Global.openFadeContainer(createSimilarItem(i, v), DyDetailPage(v)),
              [null, null, Colors.white],
              {'crr': 8, 'mg': PFun.lg(PFun.lg2(0, 1).contains(i) ? 0 : 10)},
            );
          },
        ),
        titleBarView(),
        btmBarView(),
      ]),
    );
  }
  Widget createSimilarItem(i, v) {
    String sales = BService.formatNum(v['sales']);
    double price = v['price']/100;
    return PWidget.container(
      PWidget.column([
        PWidget.wrapperImage('${v['cover']}', {'ar': 1 / 1}),
        PWidget.container(
          PWidget.column([
            PWidget.row([
              PWidget.image('assets/images/mall/dy.png', [14, 14],{'pd':[4,0,0,0]}),
              PWidget.boxw(4),
              PWidget.text(v['title'], [Colors.black.withOpacity(0.75)],
                  {'exp': true}),
            ]),
            // PWidget.text('${v['dtitle']}'),
            PWidget.boxh(8),
            PWidget.text('', [], {}, [
              PWidget.textIs(' 抢购价 ', [Colours.app_main, 12]),
              PWidget.textIs('¥', [Colours.dy_main, 12, true]),
              PWidget.textIs(
                  '$price', [Colours.dy_main, 20, true]),
            ]),
            PWidget.boxh(8),
            PWidget.text('', [], {}, [
              PWidget.textIs('已售', [Colors.black45, 12]),
              PWidget.textIs(sales, [Colors.black45, 12]),
              PWidget.textIs('+', [Colors.black45, 12]),
            ]),
            PWidget.boxh(8),
            PWidget.text(v['shop_name'], [Colors.black45, 12]),
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
            BService.collectProduct(context, collect, goodsId, 'dy', img, title, startPrice, endPrice).then((value){
              getCollect();
            });
          }, collect),
          PWidget.boxw(24),
          PWidget.container(
            PWidget.row([
              if(showShareBuy)
              PWidget.container(
                PWidget.textNormal('转卖', [Colours.app_main, 14, true], {'ct': true}),
                [null, null, Color(0xffFAEDE0)],
                {
                  'exp': true,
                  'fun': () => {
                    onTapDialogLogin(context, fun: (){
                      res['list'][0]['klUrl'] = klDm.object?['dyPassword'];
                      Navigator.pushNamed(context, '/sellPage', arguments: {'res':res['list'][0],'platType':'DY'});
                    })
                  }
                },
              ),
              if(showShareBuy)
              PWidget.container(
                PWidget.textNormal(
                    '口令购买', [Colors.white, 14, true], {'ct': true}),
                [null, null, Colours.dy_main.withOpacity(0.75)],
                {
                  'exp': true,
                  'fun': () => {
                        FlutterClipboard.copy(klDm.object?['dyPassword']).then(
                            (value) => ToastUtils.showToast('复制成功，请打开【抖音app】下单'))
                      }
                },
              ),
              PWidget.container(
                PWidget.textNormal('立即购买', [Colors.white, 14], {'ct': true}),
                [null, null, Colours.dy_main],
                {
                  'exp': true,
                  'fun': () {
                    onTapDialogLogin(context, fun: (){
                      launch(false);
                    });
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

  Future launch(showLoading) async{
    if(klDm.object == null) {
      if(!showLoading) {
        Loading.show(context);
      }
      await Future.delayed(Duration(milliseconds: 300));
      launch(true);
    } else {
      if(klDm.object!.isEmpty) {
        ToastUtils.showToast('该商品暂不支持购买');
        return;
      }
      if(showLoading) {
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
        return PWidget.container(
          PWidget.row([
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
                        Colours.dy_main
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
    String sales = BService.formatNum(detailDm.object?['sales']);

    num fee = detailDm.object?['cosFee'];
    var divi = detailDm.object?['subdivisionRank'];
    if(divi == null || divi == 0) {
      divi = 1;
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
                      [Colours.dy_main, 12, true]),
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
                'mg': 8,
                'fun': () => {Navigator.pushNamed(context, '/top')}
              },
            ),
            PWidget.container(
              PWidget.row([
                PWidget.image('assets/images/mall/dy.png', [14, 14],{'pd':[6,0,0,0]}),
                PWidget.boxw(4),
                getTitleWidget(detailDm.object?['title'], size: 16, max: 2)
              ], '001',),
              {'pd': [8,8,12,8]},
            ),
            PWidget.container(
              PWidget.row([
                getPriceWidget(endPrice
                    , startPrice, endTextSize: 24, endPrefix: '抢购价'
                    ,endTextColor: Colours.dy_main, endPrefixSize: 16,endPrefixColor: Colours.dy_main),
                PWidget.spacer(),
                PWidget.text('', [], {}, [
                  PWidget.textIs('已售', [Colors.black45, 12]),
                  PWidget.textIs(sales, [Colours.dy_main, 12]),
                  PWidget.textIs('+', [Colors.black45, 12]),
                ]),
              ]),
              {'pd': [8,8,12,8]},
            ),

            fee == 0 ? SizedBox() : PWidget.container(PWidget.row([
              getMoneyWidget(context, fee, DY, column: false, priceTxtColor: Colours.dy_main),
            ]),
              {'pd': [8,8,12,8]},
            ),
          ]),
          [null, null, Colors.white],
        ),
        PWidget.container(
          PWidget.row([
            PWidget.column([
              PWidget.row([
                PWidget.text(detailDm.object?['shopName']??'', [Colors.black, 14, true],
                    {'exp': true}),
              ]),
              if(detailDm.object?['shopTotalScore'] != null)
                PWidget.boxh(16),
              if(detailDm.object?['shopTotalScore'] != null)
                Builder(builder: (context) {
                  return PWidget.textNormal(getScoreText(), [Colors.black54,12]);
                }),
              PWidget.boxh(16),
              PWidget.textNormal(
                  detailDm.object?['logisticsInfo'],[Colors.black54,12], {'isOf': false}),
            ], {
              'exp': 1,
            }),
          ]),
          [null, null, Colors.white],
          {'mg': PFun.lg(10), 'br': 12, 'pd': 16},
        ),
      ], null, null, key1),
      ProductInfoImgWidget(
        {'isExpand':false, 'imgs': getDetailImages(), 'expandColor':Colours.dy_main},
        key: key2,
        imgRatio: 1,
      ),
      listSimilarGoodsByOpenDm.list.length == 0
          ? SizedBox()
          : PWidget.text('热销同款', [Colors.black.withOpacity(0.75), 16, true],
              {'ct': true, 'pd': PFun.lg(8)}),
    ];
  }

  getScoreText() {
    if(detailDm.object?['shopTotalScore'] == null) {
      return '';
    }
    var data = detailDm.object?['shopTotalScore'];
    var pScore = data['productScore'];
    var serviceScore = data['serviceScore'];
    var logisticsScore = data['logisticsScore'];

    return '描述：${pScore['score']??''}   卖家：${serviceScore['score']??''}   物流：${logisticsScore['score']??''}';
  }

  getBannerImages() {
    return detailDm.object?['imgs'];
  }

  getDetailImages() {
    return detailDm.object?['imgs'];
  }
}
