/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sufenbao/me/myself.dart';

import '../page/top_page.dart';
import '../widget/double_tap_back_exit_app.dart';
import 'home_page.dart';

///首页
class Index extends StatefulWidget {
  const Index({Key? key, this.index}) : super(key: key);
  final int? index;
  @override
  State<StatefulWidget> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  late PageController _pageController;
  int activeIndex = 0;

  bool agree = false;
  //实现监听flutter中App的一些状态， 比如 进入前后台
  @override
  void initState() {
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

  late List<Widget> _widgetOptions;

  @override
  Widget build(BuildContext context) {
    return DoubleTapBackExitApp(
        child: Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            // border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 24)],
          ),
          child: BottomNavigationBar(
            currentIndex: activeIndex,
            onTap: (index) => _pageController.jumpToPage(index),
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: Icon(HugeIcons.strokeRoundedHome06), label: '首页'),
              // BottomNavigationBarItem(icon: Icon(HugeIcons.strokeRoundedBitcoinBag), label: '榜单'),
              BottomNavigationBarItem(icon: Icon(HugeIcons.strokeRoundedGoogleHome), label: '我的')
            ],
          )),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(), // 禁止滑动
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            activeIndex = index;
          });
        },
        children: [
          HomePage(),
          // TopPage(data: {'showArrowBack': false}),
          MySelfPage()
        ],
      ),
    ));
  }
}
