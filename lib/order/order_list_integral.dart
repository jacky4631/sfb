/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';

//积分订单明细
class OrderListIntegral extends StatefulWidget {
  final Map data;
  const OrderListIntegral(this.data, {Key? key}) : super(key: key);

  @override
  _OrderListIntegralState createState() => _OrderListIntegralState();
}

class _OrderListIntegralState extends State<OrderListIntegral> {
  List<Map> _orderList = [];
  bool _isLoading = true;
  bool _hasError = false;
  bool _hasMore = true;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  ///初始化函数
  Future<void> _initData() async {
    await _getListData(isRefresh: true);
  }

  ///列表数据
  Future<void> _getListData({int page = 1, bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _currentPage = 1;
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      var res = await BService.integralOrders(page);
      if (res != null && mounted) {
        setState(() {
          if (isRefresh) {
            _orderList = List<Map>.from(res['data'] ?? []);
          } else {
            _orderList.addAll(List<Map>.from(res['data'] ?? []));
          }
          _hasMore = _orderList.length < (res['total'] ?? 0);
          _currentPage = page;
          _isLoading = false;
          _isLoadingMore = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _getListData(isRefresh: true);
  }

  Future<void> _onLoadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    await _getListData(page: _currentPage + 1);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('加载失败，请重试', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _getListData(isRefresh: true),
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              _hasMore &&
              !_isLoadingMore) {
            _onLoadMore();
          }
          return false;
        },
        child: ListView.separated(
          itemCount: _orderList.length + (_hasMore ? 1 : 0),
          separatorBuilder: (context, index) => SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index == _orderList.length) {
              return Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: _isLoadingMore
                    ? CircularProgressIndicator()
                    : Text('没有更多数据了', style: TextStyle(color: Colors.grey)),
              );
            }
            return _buildOrderItem(_orderList[index]);
          },
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商品图片
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              data['goodsImg'] ?? '',
              width: 124,
              height: 124,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 124,
                  height: 124,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          SizedBox(width: 8),
          // 商品信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 商品名称
                Text(
                  data['goodsName'] ?? '',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                // 订单号
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '订单号  ',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                      TextSpan(
                        text: '${data['orderId'] ?? ''}',
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                // 实付积分
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '实付',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '${data['payIntegral'] ?? 0}积分',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // 底部状态栏
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 32,
                      margin: EdgeInsets.only(right: 45),
                      padding: EdgeInsets.only(left: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Color(0xffFAEDE6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${data['createTime'] ?? ''}',
                        style: TextStyle(
                          color: Color(0xffDF5C12),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    // 状态标签
                    Container(
                      width: 90,
                      height: 39,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/mall/ljq.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '待发货',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
