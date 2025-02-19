/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sufenbao/index/provider/home_provider.dart';
import 'package:sufenbao/me/myself.dart';
import 'package:sufenbao/search/search_page.dart';
import 'package:sufenbao/util/bao_icons.dart';

import '../page/top_page.dart';
import '../widget/double_tap_back_exit_app.dart';
import 'home_page.dart';
import 'local_page.dart';

///首页
class Index extends StatefulWidget {
  const Index({Key? key, this.index}) : super(key: key);
  final int? index;
  @override
  State<StatefulWidget> createState() => _IndexState();
}

class _IndexState extends State<Index> with RestorationMixin {
  HomeProvider provider = HomeProvider();
  late PageController _pageController;

  bool agree = false;
  //实现监听flutter中App的一些状态， 比如 进入前后台
  @override
  void initState() {
    initData();
    super.initState();
    _pageController = PageController(
      initialPage: widget.index ?? 0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void initData() {
    _widgetOptions = [
      HomePage(),
      LocalPage(),
      TopPage(
        data: {'showArrowBack': false},
      ),
      MySelfPage()
    ];
  }

  late List<Widget> _widgetOptions;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
        create: (_) => provider,
        child: DoubleTapBackExitApp(
            child: Scaffold(
          backgroundColor: Colors.white,
          body: PageView(
            physics: const NeverScrollableScrollPhysics(), // 禁止滑动
            controller: _pageController,
            onPageChanged: (int index) => provider.value = index,
            children: _widgetOptions,
          ),
          bottomNavigationBar: Consumer<HomeProvider>(builder: (_, provider, __) {
            return createBottomBar(provider);
          }),
        )));
  }

  createBottomBar(HomeProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey.shade300,
            hoverColor: Colors.grey.shade100,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey.shade100,
            color: Colors.black,
            tabs: getTabs(),
            selectedIndex: widget.index ?? provider.value,
            onTabChange: (index) {
              _pageController.jumpToPage(index);
            },
          ),
        ),
      ),
    );
  }

  getTabs() {
    return [
      GButton(
        icon: BaoIcons.home,
        text: '首页',
      ),
      GButton(
        icon: BaoIcons.love,
        text: '团购',
      ),
      GButton(
        icon: BaoIcons.love,
        text: '榜单',
      ),
      GButton(
        icon: BaoIcons.user,
        text: '我的',
      ),
    ];
  }

  @override
  String? get restorationId => 'home';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(provider, 'BottomNavigationBarCurrentIndex');
  }
}
