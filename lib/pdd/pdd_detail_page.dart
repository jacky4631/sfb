/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
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

import '../util/toast_utils.dart';
import '../util/colors.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../util/paixs_fun.dart';
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

class _PddDetailPageState extends State<PddDetailPage> with AuthTip{
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
    super.initChannelId(callback: (){
      setState(() {

      });
    });
  }
  Future getCollect() async {
    collect = await BService.collect(goodsId);
    setState(() {
    });
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
  initGoodsId() {
    goodsId = widget.data['goods_sign']??widget.data['goodsSign']??widget.data['productId']??widget.data['itemId'];
  }
  var res;
  //详情数据
  Map klMap = {};
  var detailDm = DataModel<Map>(object: {'minGroupPrice': '', 'goodsName': '', 'mallName':''});
  Future<int> getDetailData() async {
     res = await BService.goodsDetailPDD(goodsId);
    if (res.isNotEmpty) {
      img = res['goodsThumbnailUrl'];
      title = res['goodsName'];
      List materialList = res['materialList'];
      detailImgs = res['goodsGalleryUrls'] ?? [];
      if(materialList != null && materialList.length > 0) {
        var material = materialList.elementAt(0);
        detailImgs = material['goodsGalleryUrls'];
      }
      detailDm.addObject(res);
      int coupon = detailDm.object?['couponDiscount'];
      if(coupon == 0) {
        endPrice = detailDm.object!['minGroupPrice'].toString();
      } else {
        num endPriceD = detailDm.object?['minGroupPrice']-detailDm.object?['couponDiscount'];
        endPrice = endPriceD.toStringAsFixed(2);
      }

      setState(() {
        loading = false;
      });
      klMap = await BService.goodsWordPDD(goodsId, uid: widget.data['uid']);
    }else {
      ToastUtils.showToast('商品已下架');
      Navigator.pop(context);
    }
    return detailDm.flag;
  }
  var listSimilarGoodsByOpenDm = DataModel();
  Future<int> listSimilarGoodsByOpen() async {
    var res = await BService.pddSearch(1, keyword: title,)
        .catchError((v) {
      listSimilarGoodsByOpenDm.toError('网络异常');
    });
    if (res != null) {
      listSimilarGoodsByOpenDm.addList(res['goodsList'], false, res['totalCount']);
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
              Global.openFadeContainer(createSimilarItem(i, v), PddDetailPage(v)),
              [null, null, Colors.white],
              {'crr': 8, 'mg': PFun.lg(PFun.lg2(0, 1).contains(i) ? 0 : 10)},
            );
          },
        ),
        titleBarView(),
        btmBarView(),
        if(showChannelWidget)
          createChannelAuthWidget('pdd.png'),

      ]),
    );
  }

  tipClick(){
    Global.showPddAuthDialog((){
      Navigator.pop(context);
      // initChannelId();
      // setState(() {});
    });
  }

  Widget createSimilarItem(i, v) {
    String img = v['goodsThumbnailUrl'];
    String sale = v['salesTip'] == '' ? '0' : v['salesTip'];
    return PWidget.container(
      PWidget.column([
        PWidget.wrapperImage(img, {'ar': 1 / 1}),
        PWidget.container(
          PWidget.column([
            PWidget.row([
              PWidget.text(v['goodsName'], [Colors.black.withOpacity(0.75)], {'exp': true}),
            ]),
            // PWidget.text('${v['dtitle']}'),
            PWidget.boxh(8),
            PWidget.text('', [], {}, [
              PWidget.textIs('¥', [Colors.red, 12, true]),
              PWidget.textIs('${v['minGroupPrice']}', [Colors.red, 20, true]),
            ]),
            PWidget.boxh(8),
            PWidget.text('', [], {}, [
              PWidget.textIs('已售', [Colors.black45, 12]),
              PWidget.textIs(sale, [Colors.black45, 12]),
            ]),
            PWidget.boxh(8),
            PWidget.text(v['mallName'], [Colors.black45, 12]),
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
          PWidget.boxw(16),
          btmBtnView('收藏', Icons.star_rate_rounded, () {
            BService.collectProduct(context, collect, goodsId, 'pdd', img, title, startPrice, endPrice).then((value){
              getCollect();
            });
          }),
          PWidget.boxw(24),
          PWidget.container(
            PWidget.row([
              if(showShareBuy)
              PWidget.container(
                PWidget.text('转卖', [Colours.app_main, 14, true], {'ct': true}),
                [null, null, Color(0xffFAEDE0)],
                {
                  'exp': true,
                  'fun': () {
                    res['klUrl'] = klMap['mobileShortUrl'];
                    Navigator.pushNamed(context, '/sellPage', arguments: {'res':res,'platType':'PDD'});
                    // onTapDialogLogin(context, fun: share)
                  }
                },
              ),
              PWidget.container(
                PWidget.ccolumn([

                  PWidget.text('立即购买', [Colors.white, 16], {'ct': true})
                ], '221'),
                [null, null, Colours.pdd_main],
                {'exp': true, 'fun': () => onTapDialogLogin(context,
                    fun: (){
                  launch(false);
                })
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

  Future launch(showLoading) async {
    if(klMap['mobileUrl'] == null) {
      if(!showLoading) {
        Loading.show(context);
      }
      await Future.delayed(Duration(milliseconds: 300));
      launch(true);
    } else {
      if(showLoading) {
        Loading.hide(context);
      }
      LaunchApp.launchPdd(context, klMap['mobileUrl'], klMap['mobileShortUrl'], fun: ()async
      {
        bool installed = await isWeChatInstalled;
        if(installed) {
          launchWeChatMiniProgram(
            username: 'gh_0e7477744313',
            path: klMap['weAppPagePath'],
          );
        }
      });
    }
  }
  Widget btmBtnView(name, icon, fun) {
    return PWidget.column(
      [PWidget.icon(icon ?? Icons.star_rate_rounded, PFun.lg1(Colours.getCollectColor(name, collect))),
        PWidget.boxh(4), PWidget.text(name ?? '收藏', PFun.lg1(Colors.black45))],
      '000',
      {'fun': fun},
    );
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
        return PWidget.container(
          PWidget.row([
            PWidget.container(
              PWidget.icon(Icons.keyboard_arrow_left_rounded, [isGo ? Colors.black : Colors.white]),
              [32, 32, if (!isGo) Colors.black26],
              {'br': 56, 'fun': () => Navigator.pop(context)},
            ),
            if (isGo) PWidget.spacer(),
            if (isGo)
              PWidget.row(
                List.generate(tabList.length, (i) {
                  if (i == 1 && ['', null].contains(detailImgs)) {
                    return PWidget.boxh(0);
                  }
                  return PWidget.container(
                    PWidget.column([
                      PWidget.text(tabList[i]),
                      PWidget.boxh(4),
                      PWidget.container(null, [24, 2, Colors.red.withOpacity((valueChange.tabIndex == i) ? 1 : 0)]),
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
                            this.animateTo((key1.currentContext?.size?.height ?? 0.0) - 48 - pmPadd.top);
                            break;
                          case '同款':
                            var key1H = (key1.currentContext?.size?.height ?? 0.0);
                            var key2H = (key2.currentContext?.size?.height ?? 0.0);
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
    double fee = detailDm.object?['promotionRate']*detailDm.object?['minGroupPrice']/100;
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
              var imgs = detailDm.object?['goodsGalleryUrls'] ?? [];
              imgs.removeWhere((w) => w == '');
              return DetailLunboWidget(imgs);
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
                  PWidget.textIs('${detailDm.object?['subdivisionName'] ?? ''}热销排行榜第', [Color(0xffB08E55), 12]),
                  PWidget.textIs(' ${divi} ', [Colours.pdd_main, 12, true]),
                  PWidget.textIs('名', [Color(0xffB08E55), 12]),
                ]),
                PWidget.spacer(),
                PWidget.container(
                  PWidget.row([
                    PWidget.text('查看', [Color(0xffB08E55), 10], {'pd': PFun.lg(0.5)}),
                    PWidget.icon(Icons.chevron_right_rounded, [Color(0xffB08E55), 16]),
                  ]),
                  {'pd': PFun.lg(0, 0, 8, 0), 'br': 56, 'bd': PFun.bdAllLg(Color(0xffB08E55), 1)},
                ),
              ]),
              [null, null, Color(0xffF7F3DB)],
              {'pd': 12, 'br': 8, 'mg': 8, 'fun':()=>{
                Navigator.pushNamed(context, '/top')
              }},
            ),
            PWidget.container(
              PWidget.row([
                PWidget.image('assets/images/mall/pdd.png', [14, 14],{'pd':[6,0,0,0]}),
                PWidget.boxw(4),
                getTitleWidget(detailDm.object?['goodsName'], size: 16, max: 2)
              ], '001',),
              {'pd': [8,8,12,8]},
            ),

            PWidget.container(
              PWidget.row([
                getPriceWidget(detailDm.object?['minGroupPrice']??''
                    , detailDm.object?['minNormalPrice']??'', endTextSize: 24, startPrefix: '原价 '
                    ,endPrefixSize: 16
                  ,endTextColor: Colours.pdd_main),
                PWidget.spacer(),
                PWidget.text('', [], {}, [
                  PWidget.textIs('已售', [Colors.black45, 12]),
                  PWidget.textIs('${detailDm.object?['salesTip']}', [Colours.pdd_main, 12]),
                ]),
              ]),
              {'pd': [8,8,12,8]},
            ),
            fee == 0 ? SizedBox() : PWidget.container(PWidget.row([
              getMoneyWidget(context, fee, PDD, column: false, priceTxtColor: Colours.pdd_main),
            ]),
              {'pd': [8,0,12,8]},
            ),
            getBuyTipWidget(color: Colours.pdd_main)
          ]),
          [null, null, Colors.white],
        ),
        PWidget.container(
          PWidget.row([
            PWidget.boxw(8),
            PWidget.column([
              PWidget.row([
                PWidget.image('assets/images/mall/pdd.png', [18, 18]),
                PWidget.boxw(4),
                PWidget.text(detailDm.object?['mallName'], [Colors.black, 14, true], {'exp': true}),
              ]),
              PWidget.boxh(8),
              Builder(builder: (context) {
                Map? data = detailDm.object;
                var servTxt = data?['servTxt'];
                var descTxt = data?['descTxt'];
                var shipTxt = data?['lgstTxt'];
                return PWidget.text('描述：$descTxt   服务：$servTxt   物流：$shipTxt', [Colors.black54]);
              }),
            ], {
              'exp': 1,
            }),
          ]),
          [null, null, Colors.white],
          {'mg': PFun.lg(10, 0), 'br': 12, 'pd': 16},
        ),
      ], null, null, key1),
      ProductInfoImgWidget({'isExpand':false, 'imgs': detailImgs, 'expandColor': Colours.pdd_main}, key: key2, imgRatio: 1,),
      listSimilarGoodsByOpenDm.list.length == 0 ? SizedBox() : PWidget.text('热销同款', [Colors.black.withOpacity(0.75), 16, true], {'ct': true, 'pd': PFun.lg(8)}),
    ];
  }
}
