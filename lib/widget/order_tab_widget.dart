/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/custom_scroll_physics.dart';
import 'package:maixs_utils/widget/my_bouncing_scroll_physics.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';

import '../util/paixs_fun.dart';
import 'CustomWidgetPage.dart';

class OrderTabWidget extends StatefulWidget {
  final List<Map> tabList;
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
  final Color? labelBgColor;
  final EdgeInsetsGeometry? padding;

  const OrderTabWidget({Key? key, required this.tabList, required this.tabPage,
    this.isScrollable, this.pagePhysics, this.page = 0, this.color,
    this.unselectedColor, this.fontWeight,
    this.fontSize, this.indicatorWeight, this.indicatorColor, this.tabCon,
    this.labelBgColor, this.padding}) : super(key: key);
  @override
  _OrderTabWidgetState createState() => _OrderTabWidgetState();
}

class _OrderTabWidgetState extends State<OrderTabWidget> with TickerProviderStateMixin {
  late TabController tabCon;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabCon = widget.tabCon ??
        TabController(vsync: this, length: widget.tabList.length, initialIndex: widget.page??1);
  }

  @override
  void dispose() {
    if(tabCon != null) {
      tabCon.dispose();
    }
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
          child: TabBar(
            dividerHeight: 0,
            tabAlignment: TabAlignment.start,
            controller: tabCon,
            physics: MyBouncingScrollPhysics(),
            indicatorSize: TabBarIndicatorSize.label,
            padding: widget.padding,
            // indicatorPadding: EdgeInsets.symmetric(horizontal: 8),
            isScrollable: widget.isScrollable ?? true,
            indicatorWeight: widget.indicatorWeight ?? 4,
            indicatorColor: (widget.indicatorColor ?? Colors.white),
            unselectedLabelColor: widget.unselectedColor ?? (widget.color ?? Colors.white).withOpacity(0.5),
            unselectedLabelStyle: TextStyle(fontSize: widget.fontSize ?? 16, fontWeight: widget.fontWeight??FontWeight.bold),
            labelStyle: TextStyle(fontSize: widget.fontSize ?? 16, fontWeight: widget.fontWeight??FontWeight.bold),
            labelColor: (widget.color ?? Colors.white),
            tabs: widget.tabList.map((m) {
              var txtShimmerWidget = shimmerWidget(Text(m['title'],
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.red, fontSize: 14)));
              if(m['hasHb'] != null && m['hasHb']) {
                Widget titleWidget;
                if(isSimOrder(m['title'])) {
                  titleWidget = txtShimmerWidget;
                } else {
                  titleWidget = Tab(text: m['title']);
                }
                return Stack(children: [
                  titleWidget,
                  PWidget.positioned(
                      PWidget.container(
                        // PWidget.text('红包', [Colors.white, 8]),
                        shimmerWidget(PWidget.text('红包',[Colors.white, 7],{'pd':[0,0,4,4]}),
                            color: Colors.white),
                        [null, null, Colors.red],
                        {'bd': PFun.bdAllLg(Colors.red, 0.5),'pd':PFun.lg(1, 1, 2, 1), 'br': PFun.lg(8, 8, 1, 8)},
                      ),
                      [2, null, null, 0])
                ],);
              }
              if(isSimOrder(m['title'])) {
                return txtShimmerWidget;
              } else {
                return Tab(text: m['title']);
              }

            }).toList(),
          ),
        ),
      ],
    );
  }

  bool isSimOrder(title) {
    return title=='热度订单';
  }
}
