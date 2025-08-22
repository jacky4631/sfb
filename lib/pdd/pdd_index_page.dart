/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/widget/tab_widget.dart';
import 'package:sufenbao/pdd/pdd_index_first_page.dart';
import 'package:sufenbao/pdd/pdd_index_other_page.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';

class PddIndexPage extends StatefulWidget {
  @override
  _PddIndexPageState createState() => _PddIndexPageState();
}

class _PddIndexPageState extends State<PddIndexPage> {
  FocusNode _searchFocus = FocusNode();
  
  // 替换 DataModel 为标准状态管理
  List<Map<String, dynamic>> tabList = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getTabData();
  }

  Future<void> getTabData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    
    try {
      var res = await BService.pddCate();
      if (res != null) {
        setState(() {
          tabList = List<Map<String, dynamic>>.from(res);
          tabList.insert(0, {"id": 0, "name": "精选"});
          isLoading = false;
          hasError = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = '网络异常';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _page();
  }

  _page() {
    return Scaffold(
      body: Stack(
        children: [
          // 背景渐变
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colours.pdd_main, Colors.white],
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              title: Row(
                children: [
                  Expanded(
                    child: buildTextField2(
                      keyboardType: TextInputType.none,
                      focusNode: _searchFocus,
                      hint: '搜索商品或粘贴宝贝标题',
                      bgColor: Colors.white,
                      height: 36,
                      onTap: () => navigatorToSearchPage(),
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Color(0xffF6F6F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Container(
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (hasError) {
      return Container(
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => getTabData(),
                child: Text('重试'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (tabList.isEmpty) {
      return Container(
        width: double.infinity,
        child: Center(
          child: Text(
            '暂无数据',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    
    var tabNames = tabList.map<String>((m) => m['name'] as String).toList();
    return TabWidget(
      tabList: tabNames,
      color: Colors.black,
      indicatorColor: Colours.pdd_main,
      fontSize: 14,
      indicatorWeight: 2,
      tabPage: List.generate(tabNames.length, (i) {
        return i == 0 ? PddIndexFirstPage() : PddIndexOtherPage(tabList[i]);
      }),
    );
  }

  Widget buildTextField2({
    TextInputType? keyboardType,
    FocusNode? focusNode,
    String? hint,
    Color? bgColor,
    double? height,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 40,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Icon(
              Icons.search,
              color: Colors.grey,
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                hint ?? '',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  navigatorToSearchPage() {
    _searchFocus.unfocus();
    Navigator.pushNamed(context, '/search', arguments: {'showArrowBack': true});
  }
}
