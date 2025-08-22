/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/tao/tb_index_first_page.dart';
import 'package:sufenbao/tao/tb_index_other_page.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../util/colors.dart';

class TbIndexPage extends StatefulWidget {
  @override
  _TbIndexPageState createState() => _TbIndexPageState();
}

class _TbIndexPageState extends State<TbIndexPage> {
  FocusNode _searchFocus = FocusNode();
  
  // 状态管理
  List<Map<String, dynamic>> _tabList = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

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
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      
      var res = await BService.goodsCategory();
      _tabList = List<Map<String, dynamic>>.from(res);
      _tabList.insert(
          0, {"cid": 0, "cname": "精选", "cpic": "", "subcategories": []});
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = '网络异常';
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
                    child: _buildSearchField(),
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
          )
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return GestureDetector(
      onTap: () => navigatorToSearchPage(),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
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
                '搜索商品或粘贴宝贝标题',
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

  Widget _buildBody() {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_hasError) {
      return Container(
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage,
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
    
    if (_tabList.isEmpty) {
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

    var tabNames = _tabList.map<String>((m) => m['cname']).toList();
    return TabWidget(
      tabList: tabNames,
      color: Colors.black,
      indicatorColor: Colours.pdd_main,
      fontSize: 14,
      indicatorWeight: 2,
      tabPage: List.generate(tabNames.length, (i) {
        return i == 0 ? TbIndexFirstPage() : TbIndexOtherPage(_tabList[i]);
      }),
    );
  }

  navigatorToSearchPage() {
    _searchFocus.unfocus();
    Navigator.pushNamed(context, '/search', arguments: {'showArrowBack': true});
  }
}
