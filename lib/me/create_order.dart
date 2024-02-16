/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';

import '../util/paixs_fun.dart';
import '../util/toast_utils.dart';
import '../widget/loading.dart';

class CreateOrder extends StatefulWidget {
  final Map data;

  const CreateOrder(this.data, {Key? key}) : super(key: key);

  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  Map address = {};

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    address = await BService.addressDefault();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.tbGd(Colors.white, Colors.white)}),
          ScaffoldWidget(
            bgColor: Colors.transparent,
            brightness: Brightness.dark,
            appBar: buildTitle(context,
                title: '填写订单',
                widgetColor: Colors.black,
                leftIcon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            body: createChild(),
          ),
          btmBarView(widget.data['price']),
        ],
      ),
    );
  }

  createChild() {
    String image = widget.data['image'];
    String storeName = widget.data['storeName'];
    return PWidget.container(
      PWidget.ccolumn([
        PWidget.row([
          PWidget.ccolumn([
            PWidget.text(
                address == null
                    ? ''
                    : '${address['province']}  ${address['city']} ${address['district']}',
                [Colors.black87, 14]),
            PWidget.text(address == null ? '' : address['detail'],
                [Colors.black, 18, true]),
            PWidget.text(
                address == null
                    ? ''
                    : '${address['realName']} ${address['phone']}',
                [Colors.black87, 14]),
          ]),
          PWidget.spacer(),
          Icon(
            Icons.arrow_forward_ios,
          )
        ], {
          'fun': () => {selectAddress()}
        }),
        PWidget.boxh(8),
        PWidget.container(
          PWidget.column([
            PWidget.text(storeName, [Colors.black.withOpacity(0.75), 16, true],
                {'max': 2}),
            PWidget.boxh(8),
            PWidget.container(
              Stack(children: [
                Positioned.fill(child: PWidget.wrapperImage(image)),
              ]),
              [double.infinity, 312],
              {'crr': 12},
            ),
          ]),
          [null, null, Colors.white],
          {'ar': 1, 'br': 12, 'pd': 12},
        )
      ]),
      [null, null, Colors.white],
      {'mg': PFun.lg(10, 10), 'br': 12, 'pd': 16},
    );
  }

  ///底部操作栏
  Widget btmBarView(String price) {
    var priceStr = double.parse(price).toInt();
    return PWidget.positioned(
      PWidget.container(
        PWidget.row([
          PWidget.boxw(16),
          PWidget.text('', [], {}, [
            PWidget.textIs('积分', [Colors.black, 16, true]),
            PWidget.textIs('$priceStr', [Colors.red, 24, true]),
          ]),
          PWidget.boxw(54),
          PWidget.container(
            PWidget.row([
              PWidget.container(
                PWidget.ccolumn([
                  PWidget.text('', [], {}, [
                    PWidget.textIs('提交订单', [Colors.white, 16, true]),
                  ]),
                ], '221'),
                [null, null, Colors.red],
                {'exp': true},
              ),
            ]),
            [null, 45],
            {'crr': 56, 'exp': true},
          ),
        ]),
        [null, null, Colors.white],
        {'pd': [8, MediaQuery.of(context).padding.bottom+8, 8 ,8], 'fun': () => submitOrder(),},
      ),
      [null, 0, 0, 0],
    );
  }

  Future selectAddress() async {
    var data =
        await Navigator.pushNamed(context, '/addressList', arguments: {}) as Map;
    setState(() {
      address = data;
    });
  }

  submitOrder() {
    Loading.show(context);
    BService.createOrder({
      'addressId': address['id'],
      'goodsId': widget.data['id'],
      'payType': 'integral',
      'useIntegral': 1
    }).then((value) => {
          afterCreateOrder(value)
        });
  }
  
  afterCreateOrder(value) {
    if (value['success']) {
      ToastUtils.showToast('下单成功');
    }
    Loading.hide(context);
    Navigator.pushNamed(context, '/integralOrderList');
  }

  Widget btmBtnView(name, icon, fun) {
    return PWidget.column(
      [
        PWidget.icon(icon ?? Icons.star_rate_rounded, PFun.lg1(Colors.black45)),
        PWidget.boxh(4),
        PWidget.text(name ?? '收藏', PFun.lg1(Colors.black45))
      ],
      '000',
      {'fun': fun},
    );
  }
}
