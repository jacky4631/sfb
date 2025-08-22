/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

import '../service.dart';
import '../widget/CustomWidgetPage.dart';

///其它分类页面
class PddIndexOtherPage extends StatefulWidget {
  final Map data;

  const PddIndexOtherPage(this.data, {Key? key}) : super(key: key);
  @override
  _PddIndexOtherPageState createState() => _PddIndexOtherPageState();
}

class _PddIndexOtherPageState extends State<PddIndexOtherPage> {
  List<dynamic> _dataList = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _hasNext = true;
  int _currentPage = 1;
  var listId = '';
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasNext) {
        _loadMore();
      }
    }
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  Future<int> getListData({int? sort, int page = 1, bool isRef = false}) async {
    if (_isLoading) return 0;

    setState(() {
      _isLoading = true;
      _hasError = false;
      if (isRef) {
        _currentPage = 1;
        _dataList.clear();
      }
    });

    try {
      var res = await BService.pddSearch(page, listId: listId, catId: widget.data['id']);

      if (res != null) {
        listId = res['listId'];
        List<dynamic> newData = res['goodsList'] ?? [];
        int totalCount = res['totalCount'] ?? 0;

        setState(() {
          if (isRef) {
            _dataList = newData;
          } else {
            _dataList.addAll(newData);
          }
          _hasNext = _dataList.length < totalCount;
          _currentPage = page;
        });
      }

      setState(() {
        _isLoading = false;
      });
      return 1;
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = '网络异常';
      });
      return -1;
    }
  }

  Future<void> _onRefresh() async {
    await getListData(isRef: true);
  }

  Future<void> _loadMore() async {
    if (_hasNext && !_isLoading) {
      await getListData(page: _currentPage + 1);
    }
  }

  Widget _buildBody() {
    if (_hasError && _dataList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => getListData(isRef: true),
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    if (_dataList.isEmpty && _isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_dataList.isEmpty) {
      return Center(
        child: Text('暂无数据', style: TextStyle(color: Colors.grey[600])),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.55,
        ),
        itemCount: _dataList.length + (_hasNext ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _dataList.length) {
            return Center(
              child: _isLoading ? CircularProgressIndicator() : (_hasNext ? Text('加载更多...') : Text('没有更多了')),
            );
          }

          return createPddFadeContainer(context, index, _dataList[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F5F6),
      body: _buildBody(),
    );
  }
}
