/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/widget/tab_widget.dart';
import 'package:sufenbao/dy/dy_index_first_page.dart' ;
import 'package:sufenbao/dy/dy_index_other_page.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';

// 替代 DataModel 的简单数据模型类
class TabDataModel {
  List<dynamic> list = [];
  bool hasNext = false;
  int flag = 0;
  String? error;
  dynamic value;
  
  TabDataModel({this.value});
  
  void addList(List<dynamic>? newList, bool isRefresh, int total) {
    if (newList != null) {
      if (isRefresh) {
        list = newList;
      } else {
        list.addAll(newList);
      }
      hasNext = list.length < total;
      flag = 1;
      error = null;
    }
  }
  
  void toError(String errorMsg) {
    error = errorMsg;
    flag = -1;
  }
}

class DyIndexPage extends StatefulWidget {
  @override
  _DyIndexPageState createState() => _DyIndexPageState();
}

class _DyIndexPageState extends State<DyIndexPage> {

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getTabData();
  }

  ///tab数据
  var tabDm = TabDataModel();

  Future<int> getTabData() async {
    var res = await BService.dyCate().catchError((v) {
      tabDm.toError('网络异常');
      return null;
    });
    if (res != null) {
      tabDm.addList(res['category'], true, 0);
      tabDm.list.insert(0, {"id": 0, "name": "精选"});
    }
    setState(() {});
    return tabDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return _page();
  }

  _page() {
    return Scaffold(
      body: Stack(
        children: [
          // 渐变背景
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colours.dy_main, Colors.white],
              ),
            ),
          ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              title: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => navigatorToSearchPage(),
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 12),
                            Icon(Icons.search, color: Colors.grey, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '搜索商品或粘贴宝贝标题',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: BoxDecoration(
                color: Color(0xffF6F6F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Builder(
                builder: (context) {
                  if (tabDm.error != null) {
                    return GestureDetector(
                      onTap: () => getTabData(),
                      child: Center(
                        child: Text(
                          '点击重试',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  
                  if (tabDm.list.isEmpty) {
                    return Container(
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  var tabList = tabDm.list.map<String>((m) => (m! as Map)['name']).toList();
                  return TabWidget(
                    tabList: tabList,
                    color: Colors.black,
                    indicatorColor: Colours.dy_main,
                    fontSize: 14,
                    indicatorWeight: 2,
                    tabPage: List.generate(tabList.length, (i) {
                      return i == 0 ? DyIndexFirstPage() : DyIndexOtherPage(tabDm.list[i] as Map);
                    }),
                  );
                },
              ),
            ),
          ),
        ],
       ),
     );
  }

  navigatorToSearchPage() {
    Navigator.pushNamed(context, '/search', arguments: {'showArrowBack': true});
  }
}
