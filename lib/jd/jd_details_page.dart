/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
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

import '../util/login_util.dart';
import '../util/toast_utils.dart';
import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../listener/detail_value_change.dart';
import '../page/product_details.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/goods_buy_history_widget.dart';
import '../widget/detail_lunbo_widget.dart';
import '../widget/loading.dart';

DetailValueChange valueChange = DetailValueChange();

///京东产品详情
class JDDetailsPage extends StatefulWidget {
  final Map data;
  const JDDetailsPage(this.data, {Key? key}) : super(key: key);
  @override
  _JDDetailsPageState createState() => _JDDetailsPageState();
}

class _JDDetailsPageState extends State<JDDetailsPage> {
  ScrollController controller = ScrollController();
  List tabList = ['商品', '详情', '同款'];
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  String? couponUrl;
  late String goodsIdStr = '';
  late String title = '';
  late String img = '';
  late String startPrice = '0';
  late String endPrice = '0';
  late bool collect = false;
  bool loading = true;
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
    collect = await BService.collect(goodsIdStr);
    setState(() {
    });
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
  var detailDm = DataModel<Map>(object: {'actualPrice': '', 'detailImages':[], 'dtitle':'', 'couponAmount':0});
  Future<int> getDetailData() async {
    var goodsId = widget.data['skuId']??widget.data['itemId']??widget.data['sku_id']
        ??widget.data['productId']??widget.data['item_id'];
    goodsIdStr = goodsId.toString();
    res = await BService.goodsDetailJD(goodsId);
    if (res != null) {
      detailDm.addObject(res);
      img = res['picMain'];
      title = res['skuName'];
      endPrice = res['actualPrice'].toString();
      startPrice = res['originPrice'].toString();
      
      setState(() {
        loading = false;
      });
      couponUrl = await BService.goodsWordJD(res['itemId'], res['couponLink'], res['materialUrl']);
    }else {
      ToastUtils.showToast('商品已下架');
      Navigator.pop(context);
    }


    return detailDm.flag;
  }

  ///类似商品
  var listSimilarGoodsByOpenDm = DataModel();
  Future<int> listSimilarGoodsByOpen() async {
    var res = await BService.goodsSearch(1, title,)
        .catchError((v) {
      listSimilarGoodsByOpenDm.toError('网络异常');
    });
    if (res != null) {
      listSimilarGoodsByOpenDm.addList(res, false, 10);
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
              Global.openFadeContainer(createSimilarItem(i, v), ProductDetails(v)),
              [null, null, Colors.white],
              {'crr': 8, 'mg': PFun.lg(PFun.lg2(0, 1).contains(i) ? 0 : 10)},
            );
            // return Global.openFadeContainer(createSimilarItem(i, v), ProductDetails(v));
          },
        ),
        titleBarView(),
        btmBarView(),
      ]),
    );
  }
  Widget createSimilarItem(i, v) {
    String img = v['white_image'] == "" ?v['pict_url'] : v['white_image'];
    String sale = '';
    if(!Global.isEmpty(v['tk_total_sales'])){
      sale = BService.formatNum(int.parse(v['tk_total_sales']));
    }
    return PWidget.container(
      PWidget.column([
        PWidget.wrapperImage(img, {'ar': 1 / 1}),
        PWidget.container(
          PWidget.column([
            PWidget.row([
              PWidget.image('assets/images/mall/jd.png', [14, 14],{'pd':[6,0,0,0]}),
              PWidget.boxw(4),
              PWidget.text(v['short_title'], [Colors.black.withOpacity(0.75)], {'exp': true}),
            ]),
            // PWidget.text('${v['dtitle']}'),
            PWidget.boxh(8),
            PWidget.text('', [], {}, [
              PWidget.textIs('¥', [Colours.app_main, 12, true]),
              PWidget.textIs('${v['zk_final_price']}', [Colours.app_main, 20, true]),
            ]),
            PWidget.boxh(8),
            PWidget.text('', [], {}, [
              PWidget.textIs('已售', [Colors.black45, 12]),
              PWidget.textIs(sale, [Colors.black45, 12]),
            ]),
            PWidget.boxh(8),
            PWidget.text(v['shop_title'], [Colors.black45, 12]),
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
            BService.collectProduct(context, collect, goodsIdStr, 'jd', img, title, startPrice, endPrice).then((value){
              getCollect();
            });
          },collect),
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
                      res['klUrl'] = couponUrl;
                      Navigator.pushNamed(context, '/sellPage', arguments: {'res':res,'platType':'JD'});
                      // shareGoods(context,
                      //     detailDm.object?['skuName'],
                      //     detailDm.object?['originPrice'],
                      //     detailDm.object?['actualPrice'],
                      //     couponUrl)
                    })

                  }
                },
              ),
              PWidget.container(
                PWidget.ccolumn([
                  PWidget.text('', [], {'ct': true}, [
                    PWidget.textIs('¥', [Colors.white, 16, true]),
                    PWidget.textIs('${detailDm.object?['actualPrice']??''} ', [Colors.white, 16, true]),
                    PWidget.textIs('¥${detailDm.object?['originPrice']??''}', [Colors.white54, 12], {'td': TextDecoration.lineThrough}),
                  ]),
                  PWidget.textNormal('领券购买', [Colors.white, 12], {'ct': true})
                ], '221'),
                [null, null, Colours.jd_main],
                {'exp': true, 'fun': () =>
                    onTapDialogLogin(context, fun: (){
                      launch(false);
                })},
              ),
            ]),
            [null, 45],
            {'crr': 56, 'exp': true},
          ),
        ]),
        [null, null, Colors.white],
        {'pd': [8,MediaQuery.of(context).padding.bottom+8,8,8], },
      ),
      [null, detailDm.object!.isEmpty ? -64 : 0, 0, 0],
    );
  }
  Future launch(showLoading) async {
    if(couponUrl == null) {
      if(!showLoading) {
        Loading.show(context);
      }
      await Future.delayed(Duration(milliseconds: 300));
      launch(true);
    } else {
      if(showLoading) {
        Loading.hide(context);
      }
      LaunchApp.launchJd(context, couponUrl);
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
              PWidget.icon(Icons.keyboard_arrow_left_rounded, [isGo ? Colors.black : Colors.white]),
              [32, 32, if (!isGo) Colors.black26],
              {'br': 56, 'fun': () => Navigator.pop(context)},
            ),
            if (isGo) PWidget.spacer(),
            if (isGo)
              PWidget.row(
                List.generate(tabList.length, (i) {
                  if (i == 1 && ['', null].contains(detailDm.object?['detailImages'])) {
                    return PWidget.boxh(0);
                  }
                  return PWidget.container(
                    PWidget.column([
                      PWidget.text(tabList[i]),
                      PWidget.boxh(4),
                      PWidget.container(null, [24, 2, Colours.jd_main.withOpacity((valueChange.tabIndex == i) ? 1 : 0)]),
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
    var shopLogo = detailDm.object?['shopLogo'];
    String sale = BService.formatNum(detailDm.object?['inOrderCount30Days']);
    List detailImgs = detailDm.object?['detailImages'];
    detailImgs.removeWhere((w) => w.contains('s800x800'));

    num fee = detailDm.object?['commission'];
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
              var imgs = detailDm.object?['smallImages'] ?? [];
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
                  PWidget.textIs(' ${divi} ', [Colours.jd_main, 12, true]),
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
                PWidget.image('assets/images/mall/jd.png', [14, 14],{'pd':[6,0,0,0]}),
                PWidget.boxw(4),
                getTitleWidget(detailDm.object?['skuName'], size: 16, max: 2)
              ], '001',),
              {'pd': [8,8,12,8]},
            ),

            PWidget.container(
              PWidget.row([
                getPriceWidget(detailDm.object?['actualPrice']??''
                    , detailDm.object?['originPrice']??'', endTextSize: 24, startPrefix: '原价 '
                    ,endPrefixSize: 16
                    ,endTextColor: Colours.jd_main),
                PWidget.spacer(),
                PWidget.text('', [], {}, [
                  PWidget.textIs('已售', [Colors.black45, 12]),
                  PWidget.textIs(sale, [Colours.jd_main, 12]),
                  PWidget.textIs('件', [Colors.black45, 12]),
                ]),
              ]),
              {'pd': [8,8,12,8]},
            ),
            fee == 0 ? SizedBox() : PWidget.container(PWidget.row([
              getMoneyWidget(context, fee, JD, column: false),
            ]),
              {'pd': [8,8,12,8]},
            ),
          ]),
          [null, null, Colors.white],
        ),
        !Global.isEmpty(detailDm.object?['extensionContent']) ? PWidget.container(
          PWidget.column([
            PWidget.text('达人说', [Colours.jd_main, 16, true]),
            PWidget.boxh(8),
            PWidget.container(
              PWidget.text(detailDm.object?['extensionContent'], {'isOf': false}),
              [null, null, Colors.black.withOpacity(0.05)],
              {'pd': 8, 'br': 8},
            ),
          ]),
          [null, null, Colors.white],
          {'mg': PFun.lg(10, 10), 'br': 12, 'pd': 16},
        ):SizedBox(),
        PWidget.container(
          PWidget.row([
            shopLogo == null ? SizedBox() : PWidget.wrapperImage(BService.formatUrl(shopLogo), [56, 56], {'br': 8}),
            PWidget.boxw(8),
            PWidget.column([
              PWidget.row([
                detailDm.object?['isOwner'] == 1 ? PWidget.container(
                  PWidget.text('自营', [Colors.white, 10]),
                  [null, null, Colours.jd_main],
                  {'bd': PFun.bdAllLg(Colours.jd_main, 0.5), 'pd': PFun.lg(1, 1, 4, 4), 'br': PFun.lg(4, 4, 4, 4)},
                ) : SizedBox(),
                detailDm.object?['isOwner'] == 1 ? PWidget.boxw(4): SizedBox(),
                PWidget.text(detailDm.object?['shopName'], [Colors.black, 14, true], {'exp': true}),
              ]),
              PWidget.boxh(8),
              Builder(builder: (context) {
                var data = detailDm.object!;
                String comments = BService.formatNum(data['comments']);
                var goodsCommentShare = data['goodsCommentShare'];

                return PWidget.textNormal('评论数：$comments   好评率：$goodsCommentShare%',
                    [Colors.black54, 12]);
              }),
            ], {
              'exp': 1,
            }),
          ]),
          [null, null, Colors.white],
          {'mg': PFun.lg(10, 0), 'br': 12, 'pd': 16},
        ),
      ], null, null, key1),
      ProductInfoImgWidget({'isExpand':false, 'imgs': detailImgs, 'expandColor': Colours.jd_main}, key: key2),
      listSimilarGoodsByOpenDm.list.length == 0 ? SizedBox() : PWidget.text('热销同款', [Colors.black.withOpacity(0.75), 16, true], {'ct': true, 'pd': PFun.lg(8)}),
    ];
  }
}
