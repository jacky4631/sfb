/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:sufenbao/me/points_mall_details.dart';
import 'package:sufenbao/me/styles.dart';

import '../service.dart';
import '../util/colors.dart';

import '../widget/rise_number_text.dart';

// 简单的数据模型类替代 DataModel
class SimpleDataModel<T> {
  T? object;
  List<T> list = [];
  bool isLoading = false;
  String? error;
  int flag = 0;

  SimpleDataModel({this.object});

  void addList(List<T> newItems, bool isRefresh, int maxItems) {
    if (isRefresh) {
      list.clear();
    }
    list.addAll(newItems.cast<T>());
    if (list.length > maxItems) {
      list = list.take(maxItems).toList();
    }
    flag = newItems.length;
    isLoading = false;
    error = null;
  }

  void toError(String errorMessage) {
    error = errorMessage;
    isLoading = false;
    flag = -1;
  }
}

///积分商城
class PointsMallPage extends StatefulWidget {
  final Map data;
  const PointsMallPage(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _PointsMallPageState createState() => _PointsMallPageState();
}

class _PointsMallPageState extends State<PointsMallPage> with TickerProviderStateMixin {
  late TabController tabCon;
  int index = 0;
  List tabList = [];

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  var listDm = SimpleDataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    listDm.isLoading = true;
    try {
      var res = await http.get(Uri.parse(BService.getMePointsMallUrl(page)));
      listDm.addList(jsonDecode(res.body)['data'], isRef, 100);
    } catch (e) {
      listDm.toError('网络异常');
    }
    setState(() {});
    return listDm.flag;
  }

  EdgeInsets get pmPadd => MediaQuery.of(context).padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('积分商城'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getListData(isRef: true);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: headers,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= listDm.list.length) return null;
                    var item = listDm.list[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PointsMallDetail(item),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: createItem(index, item),
                      ),
                    );
                  },
                  childCount: listDm.list.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get headers {
    num integral = widget.data['integral'];
    return [
      Container(
        height: 140,
        color: Colours.app_main,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(8, 30, 8, 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('当前积分', style: TextStyle(color: Colors.white)),
                            SizedBox(height: 5),
                            RiseNumberText(integral, fixed: 0, style: TextStyles.ts(fontSize: 18)),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/integralList', arguments: widget.data);
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                            margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text('积分明细', style: TextStyle(color: Colours.app_main)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    ];
  }

  Widget createItem(i, v) {
    var img = v['image'];
    var xiaoliangStr = BService.formatNum(v['sales'] as int);
    var price = double.parse(v['price']).toInt();
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: Image.network(
                '$img',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          if (v['storeName'] != '')
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                '${v['storeName']}',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.75),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          SizedBox(height: 8),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '积分',
                      style: TextStyle(color: Colours.app_main, fontSize: 12),
                    ),
                    TextSpan(
                      text: '$price',
                      style: TextStyle(
                        color: Colours.app_main,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(
                '已兑$xiaoliangStr',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
