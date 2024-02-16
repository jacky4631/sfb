/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
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
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getTabData();
  }

  ///tab数据
  var tabDm = DataModel();
  Future<int> getTabData() async {

    var res = await BService.userGrade().catchError((v) {
      tabDm.toError('网络异常');
    });
    if (res != null) {
      List multiList = res['multiList'];
      showMulti = 2;
      List products = [];
      multiList.forEach((element) {products.addAll(element['list']);});
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
    if(showMulti == 0) {
      return ScaffoldWidget(
          bgColor: Colours.vip_white,
          body: SizedBox());
    }
    return ScaffoldWidget(
      brightness: Brightness.dark,
      appBar: buildTitle(context,
          title: widget.data!['user'] == null ? '加盟星选会员' : '${widget.data!['user']['showName']}加盟星选会员',
          widgetColor: Colours.vip_black,
          color: Colours.vip_white,
          leftIcon: Icon(
            Icons.arrow_back_ios,
            color: Colours.vip_black,
          )),
      bgColor: Colours.vip_white,
      body: AnimatedSwitchBuilder(
        value: tabDm,
        errorOnTap: () => this.getTabData(),
        initialState: PWidget.container(null, [double.infinity]),
        listBuilder: (list, _, __) {
          var tabList = list.map<String>((m) => (m! as Map)['vipData']['name']).toList();
          return TabWidget(
            tabList: tabList,
            indicatorWeight: 2,
            color: Colours.app_main,
            unselectedColor: Colors.black,
            indicatorColor: Colors.transparent,
            fontWeight: FontWeight.normal,
            tabPage: List.generate(tabList.length, (i) {
              return VipPage(list.elementAt(i));
            }),
          );
        },
      ),
    );
  }
}
