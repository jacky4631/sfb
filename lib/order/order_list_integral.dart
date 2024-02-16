/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/mylistview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/paixs_fun.dart';
//积分订单明细
class OrderListIntegral extends StatefulWidget {
  final Map data;
  const OrderListIntegral(this.data, {Key? key,}) : super(key: key);

  @override
  _OrderListIntegralState createState() => _OrderListIntegralState();
}

class _OrderListIntegralState extends State<OrderListIntegral> {

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
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
      var res = await BService.integralOrders(page);
      if (res != null) listDm.addList(res['data'], isRef, res['total']);

    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: listDm,
      initialState: buildLoad(color: Colours.app_main),
      errorOnTap: () => this.getListData(isRef: true),
      listBuilder: (list, p, h) {
        return MyListView(
          isShuaxin: true,
          isGengduo: h,
          header: buildClassicHeader(color: Colors.grey),
          onRefresh: () => this.getListData(isRef: true),
          onLoading: () => this.getListData(page: p),
          itemCount: list.length,
          listViewType: ListViewType.Separated,
          item: (i) {
            Map data = list[i] as Map;
            return getIntegralOrderWidget(data);

          },
        );
      },
    );
  }

  Widget getIntegralOrderWidget(data) {
    return PWidget.container(
      PWidget.row(
        [
          Stack(children: [
            PWidget.wrapperImage(data['goodsImg'], [124, 124], {'br': 8}),

          ]),
          PWidget.boxw(8),
          PWidget.column([
            PWidget.row([
              PWidget.text(data['goodsName'], [Colors.black.withOpacity(0.75), 16], {'exp': true,'max':2}),
            ]),
            PWidget.boxh(8),
            PWidget.text('', [], {}, [
              PWidget.textIs('订单号  ', [Colors.red, 12]),
              PWidget.textIs('${data['orderId']}', [Colors.black45, 12], {}),
            ]),
            PWidget.spacer(),
            PWidget.text('', [], {}, [
              PWidget.textIs('实付', [Colors.red, 12, true]),
              PWidget.textIs('${data['payIntegral']}积分', [Colors.red, 20, true]),
            ]),
            Stack(alignment: Alignment.centerRight, children: [
              PWidget.container(
                PWidget.text('', [], {}, [
                  PWidget.textIs('', [Color(0xff793E1B), 12]),
                  PWidget.textIs('${data['createTime']}', [Color(0xffDF5C12), 12]),
                ]),
                [double.infinity, 32, Color(0xffFAEDE6)],
                {'pd': PFun.lg(0, 0, 8, 8), 'mg': PFun.lg(0, 0, 0, 45), 'ali': PFun.lg(-1, 0)},
              ),
              Stack(alignment: Alignment.center, children: [
                PWidget.image('assets/images/mall/ljq.jpg', [90, 39]),
                PWidget.text('待发货', [Colors.white, 14, true], {'pd': PFun.lg(0, 4)}),
              ]),
            ]),
          ], {
            'exp': 1,
          }),
        ],
        '001',
        {'fill': true},
      ),
      [null, null, Colors.white],
      {'pd': [12,12,4,4], 'fun': () => {
        // jumpPage(ProductDetails(data))
      }},
    );
  }

}
