/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../service.dart';

//提现记录
class CashRecordListPage extends StatefulWidget {
  const CashRecordListPage({super.key});

  @override
  _CashRecordListPageState createState() =>
      _CashRecordListPageState();
}

class _CashRecordListPageState extends State<CashRecordListPage> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  Future initData() async {
    await getListData(isRef: true);
    setState(() {});
  }

  ///列表数据
  List<Map> listData = [];
  bool isLoading = true;
  bool hasError = false;
  bool hasMore = true;
  int totalElements = 0;
  
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    if (isRef) {
      setState(() {
        isLoading = true;
        hasError = false;
      });
    }
    
    try {
      var res = await BService.extractList(page-1);
      if (res != null && res['content'] != null) {
        if (isRef) {
          listData = List<Map>.from(res['content']);
        } else {
          listData.addAll(List<Map>.from(res['content']));
        }
        totalElements = res['totalElements'];
        hasMore = listData.length < totalElements;
        isLoading = false;
        hasError = false;
      } else {
        hasError = true;
        isLoading = false;
      }
    } catch (e) {
      hasError = true;
      isLoading = false;
    }
    
    setState(() {});
    return hasError ? -1 : (hasMore ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('提现记录', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody()
    );
  }

  Widget _buildBody() {
    if (isLoading && listData.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (hasError && listData.isEmpty) {
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
      onRefresh: () => getListData(isRef: true),
      child: ListView.builder(
        itemCount: listData.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == listData.length) {
            // 加载更多指示器
            if (hasMore) {
              // 自动加载更多
              WidgetsBinding.instance.addPostFrameCallback((_) {
                getListData(page: (listData.length ~/ 10) + 1);
              });
              return Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
            return SizedBox.shrink();
          }
          
          Map record = listData[index];
          String createTime = record['createTime'];
          return Semantics(
            /// 将item默认合并的语义拆开，自行组合， 另一种方式见 account_record_list_page.dart
            explicitChildNodes: true,
            child: StickyHeader(
              header: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF242526)
                    : Color(0xFFFAFAFA),
                padding: const EdgeInsets.only(left: 16.0),
                height: 34.0,
                child: Text(createTime.split(' ').first),
              ),
              content: _buildItem(index, record),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(int index, Map record) {
    String createTime = record['createTime'];
    final Widget content = Stack(
      children: <Widget>[
        Text(record['extractType'] == 'weixin' ? '微信到账' : '支付宝到账'),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: Text(record['extractPrice'].toString(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          child: Text(createTime.split(' ').last,
              style: Theme.of(context).textTheme.titleSmall),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: Text(
            record['status'] == 1 ? '审核成功' : '审核中',
            style: record['status'] == 1
                ? TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.error,
                  )
                : const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF8547),
                  ),
          ),
        ),
      ],
    );

    Widget container = Container(
      height: 72.0,
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context, width: 0.8),
        ),
      ),
      child: MergeSemantics(
        child: content,
      ),
    );
    return Column(children: [container]);
  }
}
