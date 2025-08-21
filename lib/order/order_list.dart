/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sufenbao/order/order_list_second.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../widget/order_tab_widget.dart';
import 'order_list_integral.dart';

//订单明细
class OrderList extends StatefulWidget {
  final Map data;
  const OrderList(this.data, {Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<Map> _tabList = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  ///初始化函数
  Future<void> _initData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      var res = await BService.orderTabFirst();
      if (mounted) {
        if (hidePonitsMall && res.isNotEmpty) {
          res.removeAt(res.length - 1);
        }
        setState(() {
          _tabList = List<Map>.from(res);
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int page = 0;
    if (widget.data['page'] != null) {
      page = widget.data['page'];
    }

    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(
        title: Text(
          '订单中心',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: _buildBody(page),
      ),
    );
  }

  Widget _buildBody(int page) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
              onPressed: _initData,
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    var length = _tabList.length;
    return OrderTabWidget(
      color: Colors.black,
      fontSize: 16,
      page: page,
      tabList: _tabList,
      padding: EdgeInsets.only(bottom: 10),
      indicatorColor: Colours.app_main,
      indicatorWeight: 2,
      tabPage: List.generate(length, (i) {
        Map data = Map.from(_tabList[i]);
        data['index'] = i;
        //最后一个跳转积分订单
        if (i == (length - 1)) {
          return OrderListIntegral(data);
        }
        if (widget.data.isNotEmpty) {
          data['page'] = widget.data['pageTwo'];
        }
        return OrderListSecond(data);
      }),
    );
  }
}