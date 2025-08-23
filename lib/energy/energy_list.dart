/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/service.dart';

class EnergyDataModel {
  List<dynamic> list = [];
  dynamic error;
  int flag = 0;
  int total = 0;
  bool get hasMore => list.length < total;

  void addList(List<dynamic>? newList, bool isRefresh, int totalCount) {
    if (newList != null) {
      if (isRefresh) {
        list = newList;
      } else {
        list.addAll(newList);
      }
      total = totalCount;
      flag = 1;
      error = null;
    } else {
      flag = -1;
      error = '加载失败';
    }
  }
}

///热度明细
class EnergyList extends StatelessWidget {
  final Map data;
  const EnergyList(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景容器
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white],
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                (data['title'] == null) ? '热度明细' : data['title'],
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: TopChild(data),
          ),
        ],
      ),
    );
  }
}

class TopChild extends StatefulWidget {
  final Map data;
  const TopChild(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  var listDm = EnergyDataModel();
  int currentPage = 1;

  Future<int> getListData({int page = 1, bool isRef = false}) async {
    if (isRef) {
      currentPage = 1;
    } else {
      currentPage = page;
    }

    var res = await BService.energyList(currentPage);
    if (res != null) {
      listDm.addList(res['list'], isRef, res['total']);
    }
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    if (listDm.error != null) {
      return GestureDetector(
        onTap: () => getListData(isRef: true),
        child: Center(
          child: Text(
            '点击重试',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    if (listDm.list.isEmpty && listDm.flag == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await getListData(isRef: true);
      },
      child: ListView.separated(
        itemCount: listDm.list.length + (listDm.hasMore ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox.shrink(),
        itemBuilder: (context, i) {
          if (i >= listDm.list.length) {
            // 加载更多指示器
            if (listDm.hasMore) {
              getListData(page: currentPage + 1);
              return Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
            return SizedBox.shrink();
          }

          var data = listDm.list[i] as Map;
          num type = data['type'];
          String isPlus = (type == 2) ? '-' : '+';
          num totalEnergy = data['totalEnergy'];
          num changeEnergy = data['energy'];
          String platformName = getPlatformName(data['platform']);
          String desc;
          if (type == 2) {
            desc = '日常扣除$platformName热度$changeEnergy';
          } else {
            desc =
                '${data['oid'] == 0 || data['oid'] == data['uid'] ? '自己' : '用户'}加盟星选/拆红包增加$platformName热度$changeEnergy';
          }

          return Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 12, 12, 12),
            child: InkWell(
              onTap: () {
                // jumpPage(ProductDetails(data))
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${data['type'] == 2 ? '减少' : '增加'}$platformName热度',
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.75),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '$isPlus$changeEnergy',
                        style: TextStyle(
                          color: Colors.red.withValues(alpha: 0.75),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['createTime'],
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '$platformName热度：$totalEnergy',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    desc,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.75),
                      fontSize: 13,
                      height: 1.0,
                    ),
                    strutStyle: StrutStyle(
                      forceStrutHeight: true,
                      height: 1,
                      leading: 0.9,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  getPlatformName(platform) {
    switch (platform) {
      case 'tb':
        return '淘';
      case 'jd':
        return '京';
      case 'pdd':
        return '多';
      case 'dy':
        return '抖';
      case 'vip':
        return '唯';
      case 'mt':
        return '美团';
    }
  }
}
