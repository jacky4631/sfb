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
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../util/paixs_fun.dart';
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
  var detailDm = DataModel<Map>();
  Future<int> getDetailData() async {
    if(widget.data['category'] == 'vip') {
      //说明是从收藏进入详情
      //从订单跳转
      if(widget.data['detailList'] != null && (widget.data['detailList'] as List).isNotEmpty ) {
        goodsId = widget.data['detailList'][0]['goodsId']??'';
      } else {
        goodsId = widget.data['productId']??widget.data['itemId']??'';
      }
      if(goodsId.isEmpty) {
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
      };
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
    var res = await BService.vipSearch(1, keyword: title,)
        .catchError((v) {
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
    return ScaffoldWidget(
      // brightness: Brightness.light,
      bgColor: Color(0xffF3F3F3),
      body: Stack(children: [
        MyCustomScroll(
          isGengduo: false,
          isShuaxin: false,
          headers: detailDm.object == null ? [SizedBox()] : headers,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          controller: controller,
          itemPadding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 70),
          itemModel: listSimilarGoodsByOpenDm,
          itemModelBuilder: (i, v) {
            return PWidget.container(
              Global.openFadeContainer(createSimilarItem(i, v), VipDetailPage(v)),
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
    String img = v['goodsThumbUrl'];
    return PWidget.container(
      PWidget.column([
        PWidget.wrapperImage(img, {'ar': 1 / 1}),
        PWidget.container(
          PWidget.column([
            PWidget.row([
              PWidget.image('assets/images/mall/vip.png', [14, 14]),
              PWidget.boxw(4),
              PWidget.text(v['goodsName'], [Colors.black.withOpacity(0.75)], {'exp': true}),
            ]),
            // PWidget.text('${v['dtitle']}'),
            PWidget.boxh(8),
            PWidget.text('', [], {}, [
              PWidget.textIs('¥', [Colours.vip_main, 12, true]),
              PWidget.textIs('${v['vipPrice']}', [Colours.vip_main, 20, true]),
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
            BService.collectProduct(context, collect, goodsId, 'vip', img, title, startPrice, endPrice).then((value){
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
                      Map data = res??widget.data;
                      //为了配合后端查券接口
                      data['klUrl'] = Uri.encodeComponent('mst.vip.com?goodsId=$goodsId');
                      Navigator.pushNamed(context, '/sellPage', arguments: {'res':data,'platType':'VIP'});
                      // shareGoods(context,
                      //     detailDm.object!['goodsName'],
                      //     detailDm.object!['marketPrice'],
                      //     detailDm.object!['vipPrice'],
                      //     klMap['url'])
                    })
                  }
                },
              ),
              PWidget.container(
                PWidget.ccolumn([
                  PWidget.textNormal('立即购买', [Colors.white, 16], {'ct': true})
                ], '221'),
                [null, null, Colours.vip_main],
                {'exp': true, 'fun': () => onTapDialogLogin(context, fun: (){
                  launchVip(false);
                })},
              ),
            ]),
            [null, 45],
            {'crr': 56, 'exp': true},
          ),
        ]),
        [null, null, Colors.white],
        {'pd': [8,MediaQuery.of(context).padding.bottom+8,8,8]},
      ),
      [null, detailDm.object==null || detailDm.object!.isEmpty ? -64 : 0, 0, 0],
    );
  }

  Future launchVip(showLoading) async {
    if(klMap['deeplinkUrl'] == null) {
      if(!showLoading) {
        Loading.show(context);
      }
      await Future.delayed(Duration(milliseconds: 300));
      launchVip(true);
    } else {
      if(showLoading) {
        Loading.hide(context);
      }
      LaunchApp.launchVip(context, klMap['deeplinkUrl'], klMap['longUrl'], fun: () async {
          //唤起微信小程序
          bool installed = await fluwx.isWeChatInstalled;
          if(installed) {
            fluwx.open(target: MiniProgram(
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
                  if (i == 1 &&
                      ['', null].contains(detailDm.object?['goodsDetailPictures'])) {
                    return PWidget.boxh(0);
                  }
                  return PWidget.container(
                    PWidget.column([
                      PWidget.text(tabList[i]),
                      PWidget.boxh(4),
                      PWidget.container(null, [
                        24,
                        2,
                        Colors.red
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
    List imageList = detailDm.object?['goodsDetailPictures']??[];
    Map storeInfo = detailDm.object?['storeInfo']??{};
    String storeName = '';
    if(storeInfo != null) {
      storeName = storeInfo['storeName'];
    }
    double fee = double.parse(detailDm.object?['commission']);
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
              var imgs = detailDm.object?['goodsCarouselPictures'];
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
                  PWidget.textIs(
                      '${detailDm.object?['subdivisionName'] ?? ''}热销排行榜第',
                      [Color(0xffB08E55), 12]),
                  PWidget.textIs(
                      ' ${divi} ',
                      [Colours.vip_main, 12, true]),
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
                PWidget.image('assets/images/mall/vip.png', [14, 14],{'pd':[6,0,0,0]}),
                PWidget.boxw(4),
                getTitleWidget(detailDm.object?['goodsName'], size: 16, max: 2)
              ], '001',),
              {'pd': [8,8,12,8]},
            ),
            PWidget.container(
              PWidget.row([
                getPriceWidget(detailDm.object?['vipPrice']??''
                    , detailDm.object?['marketPrice']??'', endTextSize: 24, endPrefix: '折扣价 ',
                    endPrefixSize: 16, startPrefix: '原价',endPrefixColor: Colours.vip_main
                    ,endTextColor: Colours.vip_main),
              ]),
              {'pd': [8,8,12,8]},
            ),
            fee == 0 ? SizedBox() : PWidget.container(PWidget.row([
              getMoneyWidget(context, fee, VIP, column: false, priceTxtColor: Colours.vip_main),
            ]),
              {'pd': [8,8,12,8]},
            ),
          ]),
          [null, null, Colors.white],
        ),
        PWidget.container(
          PWidget.row([
            detailDm.object?['brandLogoFull'] == null ? SizedBox() :
            PWidget.wrapperImage(
                detailDm.object?['brandLogoFull'], [80, 40], {'br': 8, 'fix':BoxFit.fitWidth,
            'pd':[2,2,4,4]}),
            detailDm.object?['brandLogoFull'] == null ? SizedBox() : PWidget.boxw(8),
            PWidget.column([
              PWidget.row([
                PWidget.text(storeName,
                    [Colors.black, 18, true], {'exp': true}),
              ]),
            ], {
              'exp': 1,
            }),
          ]),
          [null, null, Colors.white],
          {'mg': PFun.lg(10, 0), 'br': 12, 'pd': 16},
        ),
      ], null, null, key1),
      ProductInfoImgWidget(
        {'isExpand':false, 'imgs': imageList, 'expandColor': Colours.vip_main},
        key: key2,
        imgRatio: 1.1,
      ),
      listSimilarGoodsByOpenDm.list.length == 0
          ? SizedBox()
          : PWidget.text('热销同款', [Colors.black.withOpacity(0.75), 16, true],
              {'ct': true, 'pd': PFun.lg(8)}),
    ];
  }
}
