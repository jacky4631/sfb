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
import 'package:sufenbao/order/order_list_second.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../widget/order_tab_widget.dart';
import 'order_list_integral.dart';
//订单明细
class OrderList extends StatefulWidget {
  final Map data;
  const OrderList(this.data, {Key? key,}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///tab数据
  var tabDm = DataModel();
  ///初始化函数
  Future<int> initData() async {

    var res = await BService.orderTabFirst();
    if (res != null) {
      if(hidePonitsMall) {
        res.removeAt(res.length - 1);
      }
      tabDm.addList(res, true, 0);
    };
    setState(() {});
    return tabDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    int page = 0;
    if(widget.data != null && widget.data['page'] != null) {
      page = widget.data['page'];
    }
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity], {'gd': PFun.cl2crGd(Colors.white, Colors.white)}),
          ScaffoldWidget(
            bgColor: Color(0xfffafafa),
            brightness: Brightness.dark,
            appBar: buildTitle(context, title: '订单中心', widgetColor: Colors.black, leftIcon: Icon(Icons.arrow_back_ios)),
            body: AnimatedSwitchBuilder(
              value: tabDm,
              errorOnTap: () => this.initData(),
              initialState: buildLoad(color: Colors.white),
              listBuilder: (list, _, __) {
                var length = list.length;
                var tabList = list.map<Map>((m) => m).toList();
                return OrderTabWidget(
                  color: Colors.black,
                  fontSize: 16,
                  page: page,
                  tabList: tabList,
                  padding: EdgeInsets.only(bottom: 10),
                  indicatorColor: Colours.app_main,
                  indicatorWeight: 2,
                  tabPage: List.generate(length, (i) {

                    Map data = tabDm.list[i];
                    data['index'] = i;
                    //最后一个跳转积分订单
                    if(i == (length - 1)) {
                      return OrderListIntegral(data);
                    }
                    if(widget.data != null) {
                      data['page'] = widget.data['pageTwo'];
                    }
                    return OrderListSecond(data);
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}