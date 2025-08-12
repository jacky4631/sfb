/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_alibc/alibc_model.dart';
import 'package:flutter_alibc/flutter_alibc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluwx/fluwx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:sufenbao/index/provider/provider.dart';
import 'package:sufenbao/index/widget/banner_widget.dart';
import 'package:sufenbao/index/widget/tiles_widget.dart';
import 'package:sufenbao/me/model/activity_info.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';

import '../login/login_shanyan.dart';
import '../me/listener/WxPayNotifier.dart';
import '../models/data_model.dart';
import '../page/product_details.dart';
import '../shop/ali_face.dart';
import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../util/tao_util.dart';
import 'widget/brand_widget.dart';
import 'widget/card_widget.dart';
import 'widget/menu_widget.dart';

///首页
class FirstPage extends ConsumerStatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends ConsumerState<FirstPage> {
  bool init = false;
  bool agree = false;
  ScrollController _scrollController = ScrollController();
  var _showBackTop = false;

  var cancelable = null;
  @override
  void initState() {
    super.initState();
    initData();
    _scrollController.addListener(() {
      setState(() => _showBackTop = _scrollController.position.pixels >= 800);
    });
  }

  ///初始化函数
  Future<int> initData() async {
    agree = await Global.getAgree();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Global.init();
    showHuodongDialog();
    await Global.update(packageInfo);
    initThird(packageInfo);
    return 0;
  }

  Future initThird(PackageInfo packageInfo) async {
    if (!agree) {
      return;
    }
    if (!Global.isWeb()) {
      bool init = await fluwx.registerApi(appId: Global.wxAppId, universalLink: Global.wxUniversalLink);
      //监听微信授权返回结果 微信回调
      cancelable = fluwx.addSubscriber((response) {
        if (response is WeChatAuthResponse) {
          wxPayNotifier.value = response;
        }
      });
      initFaceService();
      await LoginShanyan.getInstance().init();
      if (!this.init) {
        InitModel initModel = await FlutterAlibc.initAlibc(version: packageInfo.version, appName: APP_NAME);
      }
    }
    init = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (cancelable != null) {
      cancelable.cancel();
    }
    super.dispose();
  }

  Future showHuodongDialog() async {
    ActivityInfo? huodong = Global.appInfo.huodong;
    String? todayString = await Global.getTodayString();
    if (agree && huodong != null && todayString == null && !Global.isEmpty(huodong.img)) {
      //如果今天没有显示过，
      Global.showHuodongDialog(huodong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listDm = ref
        .watch(getGoodsListProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());

    return ScaffoldWidget(
        bgColor: Color(0xfffafafa),
        body: Stack(
          children: [
            ScaffoldWidget(
                floatingActionButton: _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
                    ? FloatingActionButton(
                        backgroundColor: Colours.app_main,
                        mini: true,
                        onPressed: () {
                          // scrollController 通过 animateTo 方法滚动到某个具体高度
                          // duration 表示动画的时长，curve 表示动画的运行方式，flutter 在 Curves 提供了许多方式
                          _scrollController.animateTo(0.0,
                              duration: Duration(milliseconds: 1000), curve: Curves.decelerate);
                        },
                        child: Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      )
                    : null,
                body: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverList.list(children: headers),
                    SliverPadding(
                        padding: EdgeInsets.all(8),
                        sliver: SliverMasonryGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childCount: listDm.list.length,
                          itemBuilder: (context, index) {
                            final v = listDm.list[index];
                            return PWidget.container(
                              Global.openFadeContainer(createListItem(index, v), ProductDetails(v)),
                              [null, null, Colors.white],
                              {
                                'sd': PFun.sdLg(Colors.black12),
                                'br': 8,
                                'mg': PFun.lg(0, 6),
                                'crr': [5, 5, 5, 5]
                              },
                            );
                          },
                        ))
                  ],
                ))
          ],
        ));
  }

  Widget createListItem(i, v) {
    String sales = BService.formatNum(v['monthSales']);
    int max = 1;
    if (i % 3 == 0) {
      max = 2;
    }
    num actualPrice = v['actualPrice'];
    num fee = v['commissionRate'] * actualPrice / 100;
    String shopType = v['shopType'] == 1 ? '天猫' : '淘宝';
    List labels = v['specialText'];
    bool showLabel = labels != null && labels.isNotEmpty;
    String label = '';
    if (labels != null && labels.isNotEmpty) {
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
              PWidget.row(
                  [getPriceWidget(v['actualPrice'], v['originalPrice']), PWidget.spacer(), getSalesWidget(sales)]),
              if (showLabel) PWidget.boxh(8),
              if (showLabel) getLabelWidget(label),
              PWidget.boxh(8),
              getMoneyWidget(context, fee, TB),
              PWidget.boxh(8),
              PWidget.text('$shopType | ${v['shopName']}', [Colors.black45, 12]),
            ]),
            {'pd': 8}),
      ]),
      [null, null, Colors.white],
    );
  }

  List<Widget> get headers {
    final cardDm = ref
        .watch(homeCardHotProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());

    final brandListDm = ref
        .watch(getBrandListProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());

    ///顶部banner
    final bannerDm =
        ref.watch(bannersProvider).when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());
    final tilesDm =
        ref.watch(tilesProvider).when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());
    final listDm = ref
        .watch(getGoodsListProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());
    // final searchDm = ref
    //     .watch(getEveryBuyUrlProvider)
    //     .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());

    return [
      if (bannerDm.value.isNotEmpty)
        BannerWidget(bannerDm, (v) {
          Global.kuParse(context, v);
        }),

      ///菜单
      const MenuWidget(),
      //圆形轮播图

      if (tilesDm.list.isNotEmpty) TilesWidget(tilesDm),

      ///大家都在领
      // if (searchDm.list.isNotEmpty) EveryoneWidget(searchDm),

      ///卡片
      if (cardDm.list.isNotEmpty) CardWidget(cardDm),

      //品牌特卖
      if (brandListDm.list.isNotEmpty) BrandWidget(brandListDm),

      if (listDm.list.isNotEmpty) PWidget.text('店铺好货', [Colors.black.withOpacity(0.75), 16, true], {'ct': true}),
    ];
  }
}
