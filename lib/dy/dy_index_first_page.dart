/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/global.dart';

import '../widget/CustomWidgetPage.dart';
import '../widget/lunbo_widget.dart';

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

///首页
class DyIndexFirstPage extends StatefulWidget {
  @override
  _DyIndexFirstPageState createState() => _DyIndexFirstPageState();
}

class _DyIndexFirstPageState extends State<DyIndexFirstPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getBannerData();
    await getListData(isRef: true);
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    var res = await BService.dyList(0, page).catchError((v) {
      listDm.toError('网络异常');
      return null;
    });
    if (res != null) {
      listDm.addList(res['products'], isRef, ValueUtil.toInt(res['total']));
    }
    setState(() {});
    return listDm.flag;
  }

  ///banner
  var bannerDm = DataModel(value: [[], []]);
  Future<int> getBannerData() async {
    var res = await BService.dyNav().catchError((v) {
      bannerDm.toError('网络异常');
      return null;
    });
    if (res != null) {
      List banners = res['banners'];
      //移除抖音盛夏洗护530
      banners.removeWhere((element) {
        return element['id'] == 530;
      });
      bannerDm.addList(banners, true, 0);
    }
    setState(() {});
    return bannerDm.flag;
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
            // Headers
            SliverList(
              delegate: SliverChildListDelegate(headers),
            ),
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

  List<Widget> get headers {
    return [
      //轮播
      Builder(
        builder: (context) {
          if (bannerDm.error != null) {
            return GestureDetector(
              onTap: () => getBannerData(),
              child: Container(
                height: 0,
                width: double.infinity,
              ),
            );
          }

          if (bannerDm.list.isEmpty) {
            return Container(
              height: 0,
              width: double.infinity,
            );
          }

          return LunboWidget(
            bannerDm.list,
            value: 'img',
            radius: 8,
            margin: 16,
            aspectRatio: 391 / (154 + 16),
            fun: (v) {
              ///点击事件
              Global.kuParse(context, v);
            },
          );
        },
      ),
      SizedBox(height: 4),
    ];
  }
}
