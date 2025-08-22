/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/service.dart';

import '../widget/CustomWidgetPage.dart';

///首页
class PddIndexFirstPage extends StatefulWidget {
  @override
  _PddIndexFirstPageState createState() => _PddIndexFirstPageState();
}

class _PddIndexFirstPageState extends State<PddIndexFirstPage> {
  // 替换 DataModel 为标准状态管理
  List<Map<String, dynamic>> goodsList = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  bool hasNext = true;
  int currentPage = 1;
  String listId = '';

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    initData();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (hasNext && !isLoading) {
        getListData(page: currentPage + 1);
      }
    }
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  Future<void> getListData({int page = 1, bool isRef = false}) async {
    if (isRef) {
      setState(() {
        isLoading = true;
        hasError = false;
        currentPage = 1;
      });
    }

    try {
      var res = await BService.pddSearch(page, listId: listId);
      if (res != null) {
        List<Map<String, dynamic>> newGoodsList = List<Map<String, dynamic>>.from(res['goodsList']);

        if (page == 1) {
          // 移除前两个元素
          if (newGoodsList.length > 1) {
            newGoodsList.removeAt(1);
          }
          if (newGoodsList.length > 0) {
            newGoodsList.removeAt(0);
          }
        }

        listId = res['listId'] ?? '';

        setState(() {
          if (isRef || page == 1) {
            goodsList = newGoodsList;
          } else {
            goodsList.addAll(newGoodsList);
          }
          currentPage = page;
          hasNext = newGoodsList.isNotEmpty && (res['totalCount'] ?? 0) > goodsList.length;
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
    return Scaffold(
      backgroundColor: Color(0xffF4F5F6),
      body: RefreshIndicator(
        onRefresh: () => getListData(isRef: true),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading && goodsList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (hasError && goodsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => getListData(isRef: true),
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    if (goodsList.isEmpty) {
      return Center(
        child: Text(
          '暂无数据',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        ...headers.map((widget) => SliverToBoxAdapter(child: widget)),
        SliverPadding(
          padding: EdgeInsets.all(8),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.55,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < goodsList.length) {
                  return createPddFadeContainer(context, index, goodsList[index]);
                }
                return null;
              },
              childCount: goodsList.length,
            ),
          ),
        ),
        if (isLoading && goodsList.isNotEmpty)
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        if (!hasNext && goodsList.isNotEmpty)
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  '没有更多数据了',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> get headers {
    return [];
  }
}
