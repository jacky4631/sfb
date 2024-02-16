/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/custom_scroll_physics.dart';
import 'package:maixs_utils/widget/my_bouncing_scroll_physics.dart';

class TabWidget extends StatefulWidget {
  final List<String> tabList;
  final List<Widget> tabPage;
  final bool? isScrollable;
  final ScrollPhysics? pagePhysics;
  final int? page;
  final Color? color;
  final Color? unselectedColor;
  final FontWeight? fontWeight;
  final Color? indicatorColor;
  final double? fontSize;
  final double? indicatorWeight;
  final TabController? tabCon;

  const TabWidget({Key? key, required this.tabList, required this.tabPage,
    this.isScrollable, this.pagePhysics, this.page = 0, this.color,
    this.unselectedColor, this.fontWeight,
    this.fontSize, this.indicatorWeight, this.indicatorColor, this.tabCon}) : super(key: key);
  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> with TickerProviderStateMixin {
  late TabController tabCon;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabCon = widget.tabCon ?? TabController(vsync: this, length: widget.tabList.length, initialIndex: widget.page??1);
  }

  @override
  void dispose() {
    tabCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: TabBarView(
            physics: widget.pagePhysics ?? const PagePhysics(parent: MyBouncingScrollPhysics()),
            controller: tabCon,
            children: widget.tabPage,
          ),
        ),
        Container(
          height: 40,
          width: double.infinity,
          alignment: Alignment.center,
          // decoration: BoxDecoration(
          //   color: widget.color ?? Colors.white,
          //   boxShadow: const [
          //     BoxShadow(
          //       blurRadius: 2,
          //       spreadRadius: -2,
          //       color: Colors.black12,
          //       offset: Offset(0, 2),
          //     ),
          //   ],
          // border: Border(
          //   bottom: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.15)),
          // ),
          // ),
          child: TabBar(
            controller: tabCon,
            physics: MyBouncingScrollPhysics(),
            indicatorSize: TabBarIndicatorSize.label,
            // indicatorPadding: EdgeInsets.symmetric(horizontal: 8),
            isScrollable: widget.isScrollable ?? true,
            indicatorWeight: widget.indicatorWeight ?? 4,
            indicatorColor: (widget.indicatorColor ?? Colors.white),
            unselectedLabelColor: widget.unselectedColor ?? (widget.color ?? Colors.white).withOpacity(0.5),
            unselectedLabelStyle: TextStyle(fontSize: widget.fontSize ?? 16, fontWeight: widget.fontWeight??FontWeight.bold),
            labelStyle: TextStyle(fontSize: widget.fontSize ?? 16, fontWeight: widget.fontWeight??FontWeight.bold),
            labelColor: (widget.color ?? Colors.white),
            tabs: widget.tabList.map((m) {
              return Tab(text: m);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
