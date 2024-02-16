/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alibc/alibc_model.dart';
import 'package:flutter_alibc/flutter_alibc.dart';
import 'package:fluwx/fluwx.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';
import 'package:sufenbao/index/widget/banner_widget.dart';
import 'package:sufenbao/index/widget/everyone_widget.dart';
import 'package:sufenbao/index/widget/tiles_widget.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';

import '../login/login_shanyan.dart';
import '../me/listener/WxPayNotifier.dart';
import '../page/product_details.dart';
import '../shop/ali_face.dart';
import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../util/tao_util.dart';
import 'widget/brand_widget.dart';
import 'widget/card_widget.dart';
import 'widget/menu_widget.dart';

class HuodongNotify extends ValueNotifier {
  HuodongNotify() : super(null);
  var isShowHuodong = false;
  void changeIsShowTabbar(v) {
    isShowHuodong = v;
    notifyListeners();
  }
}

HuodongNotify huodongNotify = HuodongNotify();

///首页
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String huodongImg = '';
  ShakeAnimationController _shakeAnimationController = new ShakeAnimationController();
  Timer? timer;
  bool showHuodong = true;
  late StreamSubscription subscription;
  bool init = false;
  bool agree = false;
  ScrollController _scrollController = ScrollController();
  var _showBackTop = false;
  @override
  void initState() {
    super.initState();
    initData();
    // checkNet();
    _scrollController.addListener(() {
      setState(() => _showBackTop = _scrollController.position.pixels >= 800);
    });
  }
  Future checkNet() async {
    // final connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        // Got a new connectivity status!
        if ((result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) && !init) {
          // I am connected to a mobile network.
          initData();
        } else {
          init =false;
        }
      });
    // }
  }

  ///初始化函数
  Future<int> initData() async {
    huodongNotify.changeIsShowTabbar(false);
    agree = await Global.getAgree();
    Global.init();
    await getBannerData();
    await getTilesData();
    await getSearchData(isRef: true);
    await getCardData();
    await getBrandList(isRef: true);
    await getListData(isRef: true);
    showHuodongDialog();
    initShake();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await Global.update(packageInfo);
    await initThird(packageInfo);
    return 0;
  }

  Future initThird(PackageInfo packageInfo) async {
    if (!agree) {
      return;
    }
    if(!Global.isWeb()) {
      bool init = await registerWxApi(
          appId: Global.wxAppId,
          universalLink: Global.wxUniversalLink);
      //监听微信授权返回结果 微信回调
      weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
        wxPayNotifier.value = res;
      });
      initFaceService();
      await LoginShanyan.getInstance().init();
      if(!this.init) {
        InitModel initModel = await FlutterAlibc.initAlibc(version:packageInfo.version,appName:APP_NAME);
      }
    }
    init = true;
  }

  Future initShake() async {
    if(Global.homeUrl['huodong']!= null) {
      huodongImg = Global.homeUrl['huodong']['img'];
    }
    if(Global.isEmpty(huodongImg)){
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 3), (t) {
      ///判断抖动动画是否正在执行
      if (_shakeAnimationController.animationRunging) {
        ///停止抖动动画
        _shakeAnimationController.stop();
      } else {
        ///开启抖动动画
        ///参数shakeCount 用来配置抖动次数
        ///通过 controller start 方法默认为 1
        _shakeAnimationController.start(shakeCount: 1);
      }
    });
  }
  @override
  void dispose() {
    if(timer != null) {
      timer!.cancel();
    }
    if(subscription != null) {
      subscription.cancel();
    }
    _scrollController.dispose();
    super.dispose();
  }

  Future showHuodongDialog() async {
    Map? huodong = Global.homeUrl['huodong'];
    String? todayString = await Global.getTodayString();
    if (agree && huodong != null && huodong.isNotEmpty && todayString == null) {
      //如果今天没有显示过，
      Global.showHuodongDialog(Global.homeUrl['huodong']);
    }
  }

  ///顶部banner
  var bannerDm = DataModel(value: [[], []]);
  Future<int> getBannerData() async {
    var res = await BService.banners().catchError((v) {
      bannerDm.toError('网络异常');
    });
    if (res != null) {
      //移除网络链接link_type=3 保留小样种草 移除抖音
      res.removeWhere((element) {
        return (element['link_type'] == 3 && element['id'] != 380) || element['id'] == 530;
      });
      // res.insertAll(0, pddBannerData);
      bannerDm.addList(res, true, 0);
    }
    setState(() {});
    return bannerDm.flag;
  }

  ///顶部banner
  var tilesDm = DataModel(value: [{}]);
  Future<int> getTilesData() async {
    var res = await BService.tiles().catchError((v) {
      tilesDm.toError('网络异常');
    });
    if (res != null) {
      res.removeWhere((element) {
        return element['link_type'] == 3;
      });
      tilesDm.addList(res, true, 0);
    }
    setState(() {});
    return tilesDm.flag;
  }

  ///卡片数据
  var cardDm = DataModel<Map>(object: {});
  Future<int> getCardData() async {
    ///热销榜url
    List res1 = await BService.homeCardHot().catchError((v) {
      cardDm.toError('网络异常');
    });
    if (res1 != null) {
      cardDm.value = res1;
      cardDm.setTime();
    }

    ///限时秒杀url
    var res2 = await BService.homeCardDDQ().catchError((v) {
      cardDm.toError('网络异常');
    });
    if (res2 != null) cardDm.addObject(res2);
    setState(() {});
    return cardDm.flag;
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    var res = await BService.getGoodsList(page).catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) {
      var list = res['list'];
      var totalNum = res['totalNum'];
      listDm.addList(list, isRef, totalNum);
    }
    setState(() {});
    return listDm.flag;
  }
  ///大家都在领
  var searchDm = DataModel();
  Future<int> getSearchData({int page = 1, bool isRef = false}) async {
    var res =
        await http.get(Uri.parse(BService.getEveryBuyUrl())).catchError((v) {
      searchDm.toError('网络异常');
    });
    if (res != null) {
      var json = jsonDecode(res.body);
      var list = json['data']['list'];
      var totalNum = int.parse('${json['data']['totalNum']}');
      searchDm.addList(list, isRef, totalNum);
    }
    setState(() {});
    return searchDm.flag;
  }

  ///品牌特卖
  var brandListDm = DataModel();
  Future<int> getBrandList({int page = 1, bool isRef = false}) async {
    var res = await http.get(Uri.parse(BService.getBrandUrl())).catchError((v) {
      brandListDm.toError('网络异常');
    });
    if (res != null) {
      var json = jsonDecode(res.body);
      brandListDm.addList(json, true, 10);
    }
    setState(() {});
    return brandListDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Color(0xfffafafa),
      body:Stack(children: [
        ScaffoldWidget(
            floatingActionButton:
            _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
                ? FloatingActionButton(
              backgroundColor: Colours.app_main,
              mini: true,
              onPressed: () {
                // scrollController 通过 animateTo 方法滚动到某个具体高度
                // duration 表示动画的时长，curve 表示动画的运行方式，flutter 在 Curves 提供了许多方式
                _scrollController.animateTo(0.0,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.decelerate);
              },
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            )
                : null,
            body: MyCustomScroll(
                controller: _scrollController,
                isGengduo: listDm.hasNext,
                isShuaxin: true,
                onRefresh: () => this.initData(),
                onLoading: (p) => this.getListData(page: p),
                refHeader: buildClassicHeader(color: Colors.grey),
                refFooter: buildCustomFooter(color: Colors.grey),
                headers: headers,
                itemPadding: EdgeInsets.all(8),
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                itemModel: listDm,
                onScrollToList: (b, v) => huodongNotify.changeIsShowTabbar(b),
                maskWidget: () => ValueListenableBuilder(
                  valueListenable: huodongNotify,
                  builder: (_, __, ___) {
                    if(Global.isEmpty(huodongImg)){
                      return SizedBox();
                    }
                    return createHuodongWidget();
                  },
                ),
                itemModelBuilder: (i, v) {
                  return PWidget.container(
                    Global.openFadeContainer(createListItem(i, v), ProductDetails(v)),
                    [null, null, Colors.white],
                    {
                      'sd': PFun.sdLg(Colors.black12),
                      'br': 8,
                      'mg': PFun.lg(0, 6),
                      'crr': [5,5,5,5]
                    },
                  );
                },
              ),
        )
      ],)
    );
  }

  Widget createHuodongWidget() {
    // PWidget.positioned(
    //     PWidget.container(PWidget.wrapperImage(Global.homeUrl['huodong']['img'],[60,60],),
    //     ),
    //     [null, MediaQuery.of(context).padding.bottom+100, null , 2]
    // )
    return !showHuodong ? SizedBox() : PWidget.positioned(
      ShakeAnimationWidget(
        ///抖动控制器
        shakeAnimationController: _shakeAnimationController,
        ///微旋转的抖动
        shakeAnimationType: ShakeAnimationType.RoateShake,
        ///设置不开启抖动
        isForward: false,
        ///默认为 0 无限执行
        shakeCount: 0,
        ///抖动的幅度 取值范围为[0,1]
        shakeRange: 0.2,
        ///执行抖动动画的子Widget
        child: PWidget.container(PWidget.wrapperImage(Global.homeUrl['huodong']['img'],[60,60],{'br':4}),
            {'fun':() {
              setState(() {
                showHuodong = false;
              });
              Global.showHuodongDialog(Global.homeUrl['huodong'], delaySeconds: 0, fun: (){
                setState(() {
                  showHuodong = true;
                });
              });
            }}),
      ),
        [null, MediaQuery.of(context).padding.bottom+80, null , huodongNotify.isShowHuodong ? -30: 2]
    );

  }

  Widget createListItem(i, v) {
    String sales = BService.formatNum(v['monthSales']);
    int max = 1;
    if(i%3==0) {
      max = 2;
    }
    num actualPrice = v['actualPrice'];
    num fee = v['commissionRate'] * actualPrice / 100;
    String shopType = v['shopType']==1?'天猫':'淘宝';
    List labels = v['specialText'];
    bool showLabel = labels!= null && labels.isNotEmpty;
    String label = '';
    if(labels!= null && labels.isNotEmpty) {
      label = labels[0];
    }
    return PWidget.container(
      PWidget.column([
        PWidget.wrapperImage(getTbMainPic(v), {'ar': 1 / 1}),
        PWidget.container(
          PWidget.column([
            PWidget.row([
              // PWidget.image('assets/images/mall/tm.png', [14, 14]),
              // PWidget.boxw(4),
              getTitleWidget(v['dtitle'], max: max)
            ]),
            // PWidget.text('${v['dtitle']}'),
            PWidget.boxh(8),
            PWidget.row([
              getPriceWidget(v['actualPrice'], v['originalPrice']),
              PWidget.spacer(),
              getSalesWidget(sales)
            ]),
            if(showLabel)
              PWidget.boxh(8),
            if(showLabel)
              getLabelWidget(label),
            PWidget.boxh(8),
            getMoneyWidget(context, fee, TB),
            PWidget.boxh(8),
            PWidget.text('$shopType | ${v['shopName']}', [Colors.black45, 12]),
          ]),
          {'pd':8}
        ),
      ]),
      [null, null, Colors.white],
    );
  }

  List<Widget> get headers {
    List? cardGoodsList = cardDm.object?['goodsList'];
    List cardHot = cardDm.value;
    List brandList = brandListDm.list;
    return [
      (bannerDm.list != null && bannerDm.list.isNotEmpty)
          ? BannerWidget(bannerDm, (v){
          Global.kuParse(context, v);
      }):
          //没网络时显示默认图片
      AspectRatio(
          aspectRatio: (750+8) / (280 + 24),
          child: PWidget.image('assets/images/mall/bannerholder.png',
          {'br': 8, 'pd': [8,8,8,8]})),
      ///菜单
      const MenuWidget(),
      //圆形轮播图
      (tilesDm.list != null && tilesDm.list.isNotEmpty)
          ? TilesWidget(tilesDm):
      AspectRatio(
        aspectRatio: 710 / (170 + 30),
        child: PWidget.image('assets/images/mall/tileholder.png', {'br': 8, 'pd': [16,8,8,8]})
      ),

      // ///大家都在领
      // (searchDm.list != null && searchDm.list.isNotEmpty)
      //     ? EveryoneWidget(searchDm):SizedBox(height: 250,),
      //
      ///卡片
      if(!(cardGoodsList == null || cardGoodsList.isEmpty || cardHot == null || cardHot.isEmpty))
        CardWidget(cardDm),

      //品牌特卖
      if(brandList != null && brandList.isNotEmpty)
        BrandWidget(brandListDm),

      if (listDm.list.isNotEmpty)
        PWidget.text(
            '店铺好货', [Colors.black.withOpacity(0.75), 16, true], {'ct': true}),
    ];
  }


}
