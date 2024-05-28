/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/service.dart';

import '../me/listener/PersonalNotifier.dart';
import '../util/colors.dart';
import '../me/styles.dart';
import '../widget/loading.dart';

//订单找回
class OrderRetrieval extends StatefulWidget {
  final Map data;
  const OrderRetrieval(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _OrderRetrievalState createState() => _OrderRetrievalState();
}

class _OrderRetrievalState extends State<OrderRetrieval> {
  TextEditingController _orderController = new TextEditingController();
  Map phone = {"value": null, "verify": false};
  int inputLength = 0;
  bool running = false;
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {}
  Future _submitOrder() async {
    if (running) {
      return;
    }
    Loading.show(context);
    running = true;
    //提交成功running=false
    var res = await BService.orderSubmit(_orderController.text);
    if (res['success']) {
      personalNotifier.value = true;
      setState(() {
        _orderController.clear();
        phone['value'] = null;
        phone['verify'] = false;
      });
      FocusScope.of(context).requestFocus(FocusNode());
      ToastUtils.showToast('提交成功');
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      ToastUtils.showToast(res['msg']);
    }
    await Future.delayed(Duration(seconds: 1));
    Loading.hide(context);
    running = false;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        body: Stack(children: [
      ScaffoldWidget(

          brightness: Brightness.dark,
          bgColor: Colors.white,
          appBar: buildTitle(context,
              title: '订单找回',
              widgetColor: Colors.black,
              leftIcon: Icon(Icons.arrow_back)),
          body: PWidget.container(
              SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Center(
                      child:
                          Image.asset('assets/images/me/order_retrieval.jpg'),
                    ),
                    createTextField(),
                    PWidget.boxh(30),
                    PWidget.container(PWidget.column([
                      PWidget.text(
                        '找回规则',
                        [Colors.black54, 16, true],
                      ),
                      PWidget.textNormal('\t1.支持',
                          [Colors.black54, 14], {'max': 2},
                          [
                            PWidget.textIs('淘宝', [Colours.app_main, 14]),
                            PWidget.textIs('、', [Colors.black54, 14]),
                            PWidget.textIs('京东', [Colours.app_main, 14]),
                            PWidget.textIs('、', [Colors.black54, 14]),
                            PWidget.textIs('拼多多', [Colours.app_main, 14]),
                            PWidget.textIs('、', [Colors.black54, 14]),
                            PWidget.textIs('抖音', [Colours.app_main, 14]),
                            PWidget.textIs('、', [Colors.black54, 14]),
                            PWidget.textIs('唯品会', [Colours.app_main, 14]),
                            PWidget.textIs('、', [Colors.black54, 14]),
                            PWidget.textIs('美团外卖', [Colours.app_main, 14]),
                            PWidget.textIsNormal('订单；', [Colors.black54, 14]),
                          ]
                      ),
                      PWidget.textNormal('\t2.没有自动同步的订单可以通过这里找回；',
                          [Colors.black54, 14], {'max': 2}),
                      PWidget.textNormal('\t3.当查找人查找到订单，并且该订单确实找不到归属时，该订单归属查找人；',
                          [Colors.black54, 14], {'max': 2}),
                      PWidget.textNormal('\t4.已归属的订单不支持继续找回；', [Colors.black54, 14],
                          {'max': 2}),
                    ])),
                  ])),
              [],
              {
                'pd': [5, 5, 20, 20]
              })),
      btmBarView(context),
    ]));
  }

  createTextField() {
    return TextField(
        controller: _orderController,
        maxLines: 1,
        //是否自动更正
        autocorrect: true,
        //是否是密码
        style: TextStyles.orderTitle,
        onChanged: (e) {
          //长度变化
          setState(() {
            print(e);
            phone['value'] = e;
            bool verify = e.trim() != '';
            phone['verify'] = verify;
          });
        },
        onSubmitted: (text) {
          print("内容提交时回调");
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: "",
          hintText: "请输入或粘贴订单号",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          suffixIcon: (phone['value'] == null || phone['value'] == '')
              ? new SizedBox()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _orderController.clear();
                      phone['value'] = null;
                      phone['verify'] = false;
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey,
                  )),
          suffixIconColor: Colors.grey,
        ));
  }

  ///底部操作栏
  Widget btmBarView(BuildContext context) {
    return PWidget.positioned(
      SafeArea(child: Column(
        children: [
          RawMaterialButton(
              constraints: BoxConstraints(minHeight: 44),
              fillColor:
              phone['verify'] ? Colours.app_main : Color(0xFFD6D6D6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              onPressed: phone['verify']
                  ? () {
                _submitOrder();
              }
                  : null,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '提交订单',
                      style: TextStyle(
                        color: phone['verify'] ? Colors.white : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      )),
      [null, 10, 20, 20],
    );
  }
}
