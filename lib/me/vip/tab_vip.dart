/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

import 'package:sufenbao/me/vip/vip.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../../util/colors.dart';

class TabVip extends StatefulWidget {
  final Map? data;

  const TabVip(this.data, {Key? key}) : super(key: key);

  @override
  _TabVipState createState() => _TabVipState();
}

class _TabVipState extends State<TabVip> {
  int showMulti = 0;
  Map map = {};

  // Simple data model replacement
  _DataModel tabDm = _DataModel();
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getTabData();
  }

  Future<int> getTabData() async {
    var res = await BService.userGrade().catchError((v) {
      tabDm.toError('网络异常');
      return <String, dynamic>{};
    });
    if (res.isNotEmpty) {
      List multiList = res['multiList'];
      showMulti = 2;
      List products = [];
      multiList.forEach((element) {
        products.addAll(element['list']);
      });
      List newList = multiList.map((m) {
        Map sepMap = {};
        sepMap['data'] = widget.data;
        sepMap['vipData'] = m;
        sepMap['multi'] = true;
        sepMap['products'] = products;
        return sepMap;
      }).toList();

      tabDm.addList(newList, true, 0);
    }
    setState(() {});
    return tabDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    if (showMulti == 0) {
      return Scaffold(backgroundColor: Colours.vip_white, body: SizedBox());
    }
    return Scaffold(
      backgroundColor: Colours.vip_white,
      appBar: AppBar(
        title: Text(
          widget.data!['user'] == null ? '加盟星选会员' : '${widget.data!['user']['showName']}加盟星选会员',
          style: TextStyle(color: Colours.vip_black),
        ),
        backgroundColor: Colours.vip_white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colours.vip_black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (tabDm.flag == 0) {
      return Container(
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (tabDm.flag == -1) {
      return Container(
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('加载失败'),
              ElevatedButton(
                onPressed: () => getTabData(),
                child: Text('重试'),
              ),
            ],
          ),
        ),
      );
    } else {
      var tabList = tabDm.list.map<String>((m) => (m! as Map)['vipData']['name']).toList();
      return TabWidget(
        tabList: tabList,
        indicatorWeight: 2,
        color: Colours.app_main,
        unselectedColor: Colors.black,
        indicatorColor: Colors.transparent,
        fontWeight: FontWeight.normal,
        tabPage: List.generate(tabList.length, (i) {
          return VipPage(tabDm.list.elementAt(i));
        }),
      );
    }
  }
}

class _DataModel {
  int flag = 0; // 0: loading, 1: success, -1: error
  List list = [];
  String errorMsg = '';

  void addList(List newList, bool clear, int newFlag) {
    if (clear) {
      list.clear();
    }
    list.addAll(newList);
    flag = newFlag == 0 ? 1 : newFlag;
  }

  void toError(String msg) {
    flag = -1;
    errorMsg = msg;
  }
}
