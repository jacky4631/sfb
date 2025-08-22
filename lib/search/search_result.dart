/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */

import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sufenbao/search/model/search_param.dart';
import 'package:sufenbao/search/provider.dart';

import '../widget/tabIndicator.dart';
import 'list.dart';

var tabList = [
  {'name': '淘宝', 'img': 'assets/images/mall/tb.png'},
  {'name': '拼多多', 'img': 'assets/images/mall/pdd.png'},
  {'name': '京东', 'img': 'assets/images/mall/jd.png'},
  {'name': '抖音', 'img': 'assets/images/mall/dy.png'},
  {'name': '唯品会', 'img': 'assets/images/mall/vip.png'},
];

///搜索结果页
class SearchResultPage extends ConsumerStatefulWidget {
  const SearchResultPage({Key? key}) : super(key: key);
  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends ConsumerState<SearchResultPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: tabList.length, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: <Widget>[
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            indicator: RoundedBackgroundTabIndicator(color: Colors.red.withValues(alpha: 0.1)),
            labelColor: Colors.black,
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.transparent;
              }
              return null;
            }),
            tabs: tabList
                .asMap()
                .entries
                .map(
                  (e) => Container(
                    padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(56),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              e.value['img']!,
                              width: 14,
                              height: 14,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 14,
                                  height: 14,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.image, size: 8, color: Colors.grey[600]),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          e.value['name']!,
                          style: TextStyle(
                            color: tabController.index == e.key ? Colors.red : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            controller: tabController,
          ),
          SearchSortWidget(),
          Expanded(
            child: ExtendedTabBarView(
                shouldIgnorePointerWhenScrolling: false,
                controller: tabController,
                children: tabList.asMap().entries.map((e) => ListWidgetPage(e.key)).toList()),
          ),
        ],
      ),
    ));
  }
}

///排序组件
class SearchSortWidget extends ConsumerStatefulWidget {
  final Function(int)? fun;
  const SearchSortWidget({Key? key, this.fun}) : super(key: key);
  @override
  _SearchSortWidgetState createState() => _SearchSortWidgetState();
}

class _SearchSortWidgetState extends ConsumerState<SearchSortWidget> with TickerProviderStateMixin {
  var sortList = ['综合', '销量', '价格'];
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: sortList.length, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchParam = ref.watch(searchProvider);

    return TabBar(
      controller: tabController,
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      labelColor: Colors.red.withValues(alpha: 0.75),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.transparent;
        }
        return null;
      }),
      tabs: sortList
          .asMap()
          .entries
          .map((e) => e.value == '价格'
              ? Row(
                  children: [
                    Tab(text: e.value),
                    Container(
                        height: 20,
                        width: 25,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 2,
                              left: 0,
                              child: Icon(
                                Icons.arrow_drop_up_rounded,
                                color: Colors.red.withValues(alpha: searchParam.sort == 4 ? 0.75 : 0.25),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              left: 0,
                              child: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.red.withValues(alpha: searchParam.sort == 5 ? 0.75 : 0.25),
                              ),
                            ),
                          ],
                        ))
                  ],
                )
              : Tab(text: e.value))
          .toList(),
      onTap: (index) {
        var param = searchParam.copyWith(
            sortIndex: index, sort: index == 2 ? (searchParam.sort == 4 ? 5 : 4) : [0, 2, searchParam.sort][index]);
        ref.watch(searchProvider.notifier).searchParam = param;
      },
    );
  }
}
