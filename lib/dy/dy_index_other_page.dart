/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';

import '../service.dart';
import '../widget/CustomWidgetPage.dart';

// 替代 DataModel 的简单数据模型类
class DataModel {
  List<dynamic> list = [];
  bool hasNext = false;
  int flag = 0;
  String? error;
  dynamic value;

  DataModel({this.value});

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

///其它分类页面
class DyIndexOtherPage extends StatefulWidget {
  final Map data;

  const DyIndexOtherPage(this.data, {Key? key}) : super(key: key);
  @override
  _DyIndexOtherPageState createState() => _DyIndexOtherPageState();
}

class _DyIndexOtherPageState extends State<DyIndexOtherPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  var listDm = DataModel();
  Future<int> getListData({int? sort, int page = 1, bool isRef = false}) async {
    var res = await BService.dyList(widget.data['id'], page).catchError((v) {
      listDm.toError('网络异常');
      return null;
    });
    if (res != null) {
      listDm.addList(res['products'], isRef, ValueUtil.toInt(res['total']));
    }
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F5F6),
      body: RefreshIndicator(
        onRefresh: () async {
          await getListData(isRef: true);
        },
        child: CustomScrollView(
          slivers: [
            // Grid items
            SliverPadding(
              padding: EdgeInsets.all(8),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < listDm.list.length) {
                      return createDyFadeContainer(context, index, listDm.list[index]);
                    }
                    return null;
                  },
                  childCount: listDm.list.length,
                ),
              ),
            ),
            // Load more indicator
            if (listDm.hasNext)
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        int nextPage = (listDm.list.length ~/ 20) + 1;
                        getListData(page: nextPage);
                      },
                      child: Text(
                        '加载更多',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
