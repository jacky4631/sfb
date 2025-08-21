/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/service.dart';

///积分明细
class IntegralList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('积分明细'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: TopChild(),
    );
  }
}

class TopChild extends StatefulWidget {
  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  List<Map> _dataList = [];
  bool _isLoading = true;
  bool _hasError = false;
  int _currentPage = 1;
  bool _hasMore = true;
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
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        _loadMore();
      }
    }
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  Future<void> getListData({int page = 1, bool isRef = false}) async {
    if (isRef) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _currentPage = 1;
      });
    }

    try {
      var res = await BService.moneyList(page);
      if (res != null && res['data'] != null) {
        setState(() {
          if (isRef) {
            _dataList = List<Map>.from(res['data']);
          } else {
            _dataList.addAll(List<Map>.from(res['data']));
          }
          _hasMore = _dataList.length < (res['total'] ?? 0);
          _isLoading = false;
          _hasError = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _loadMore() async {
    _currentPage++;
    await getListData(page: _currentPage);
  }

  Future<void> _onRefresh() async {
    await getListData(isRef: true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _dataList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasError && _dataList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('加载失败，请重试', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => getListData(isRef: true),
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: _dataList.length + (_hasMore ? 1 : 0),
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          if (index == _dataList.length) {
            return _buildLoadMoreIndicator();
          }

          var data = _dataList[index];
          String type = data['type'] ?? '';
          String isPlus = (type == 'order') ? '+' : '-';
          num price = data['balance'] ?? 0;
          num changeIntegral = data['number'] ?? 0;

          return Container(
            color: Colors.white,
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data['title'] ?? '',
                        style: TextStyle(
                           color: Colors.black.withValues(alpha: 0.75),
                           fontSize: 16,
                         ),
                      ),
                    ),
                    Text(
                      '$isPlus${changeIntegral.toInt()}',
                      style: TextStyle(
                         color: Colors.red.withValues(alpha: 0.75),
                         fontSize: 16,
                       ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data['createTime'] ?? '',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '余额：${price.toInt()}',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                if (data['mark'] != null && data['mark'].toString().isNotEmpty)
                  Text(
                    data['mark'].toString(),
                    style: TextStyle(
                       color: Colors.black.withValues(alpha: 0.75),
                       fontSize: 12,
                     ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              '没有更多数据了',
              style: TextStyle(color: Colors.grey),
            ),
    );
  }
}
