/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_alibc/flutter_alibc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluwx/fluwx.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
      await fluwx.registerApi(appId: Global.wxAppId, universalLink: Global.wxUniversalLink);
      //监听微信授权返回结果 微信回调
      cancelable = fluwx.addSubscriber((response) {
        if (response is WeChatAuthResponse) {
          wxPayNotifier.value = response;
        }
      });
      initFaceService();
      await LoginShanyan.getInstance().init();
      if (!this.init) {
        await FlutterAlibc.initAlibc(version: packageInfo.version, appName: APP_NAME);
      }
    }
    init = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    cancelable?.cancel();
    super.dispose();
  }

  Future showHuodongDialog() async {
    ActivityInfo? huodong = Global.appInfo.huodong;
    String? todayString = await Global.getTodayString();
    if (agree && huodong != null && (todayString?.isEmpty != false) && !Global.isEmpty(huodong.img)) {
      //如果今天没有显示过，
      Global.showHuodongDialog(huodong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listDm = ref
        .watch(getGoodsListProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());

    return Scaffold(
        backgroundColor: Color(0xfffafafa),
        floatingActionButton: _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
            ? FloatingActionButton(
                backgroundColor: Colours.app_main,
                mini: true,
                onPressed: () {
                  // scrollController 通过 animateTo 方法滚动到某个具体高度
                  // duration 表示动画的时长，curve 表示动画的运行方式，flutter 在 Curves 提供了许多方式
                  _scrollController.animateTo(0.0, duration: Duration(milliseconds: 1000), curve: Curves.decelerate);
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
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: Global.openFadeContainer(createListItem(index, v), ProductDetails(v)),
                    );
                  },
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
    bool showLabel = labels.isNotEmpty;
    String label = '';
    if (labels.isNotEmpty) {
      label = labels[0];
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
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
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     // Image.asset('assets/images/mall/tm.png', width: 14, height: 14),
                //     // SizedBox(width: 4),
                //     Expanded(child: getTitleWidget(v['dtitle'], max: max))
                //   ],
                // ),
                // Text('${v['dtitle']}'),
                getTitleWidget(v['dtitle'], max: max),
                SizedBox(height: 8),
                Row(
                  children: [getPriceWidget(v['actualPrice'], v['originalPrice']), Spacer(), getSalesWidget(sales)],
                ),
                if (showLabel) SizedBox(height: 8),
                if (showLabel) getLabelWidget(label),
                SizedBox(height: 8),
                getMoneyWidget(context, fee, TB),
                SizedBox(height: 8),
                Text(
                  '$shopType | ${v['shopName']}',
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
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

      if (listDm.list.isNotEmpty)
        Center(
          child: Text(
            '店铺好货',
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.75),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    ];
  }
}
