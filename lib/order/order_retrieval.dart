/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController _orderController = TextEditingController();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '订单找回',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('assets/images/me/order_retrieval.jpg'),
              ),
              createTextField(),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.fromLTRB(5, 5, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '找回规则',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      maxLines: 2,
                      text: TextSpan(
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                        children: [
                          TextSpan(text: '\t1.支持'),
                          TextSpan(
                            text: '淘宝',
                            style: TextStyle(color: Colours.app_main),
                          ),
                          TextSpan(text: '、'),
                          TextSpan(
                            text: '京东',
                            style: TextStyle(color: Colours.app_main),
                          ),
                          TextSpan(text: '、'),
                          TextSpan(
                            text: '拼多多',
                            style: TextStyle(color: Colours.app_main),
                          ),
                          TextSpan(text: '、'),
                          TextSpan(
                            text: '抖音',
                            style: TextStyle(color: Colours.app_main),
                          ),
                          TextSpan(text: '、'),
                          TextSpan(
                            text: '唯品会',
                            style: TextStyle(color: Colours.app_main),
                          ),
                          TextSpan(text: '、'),
                          TextSpan(
                            text: '美团外卖',
                            style: TextStyle(color: Colours.app_main),
                          ),
                          TextSpan(text: '订单；'),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\t2.没有自动同步的订单可以通过这里找回；',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                      maxLines: 2,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\t3.当查找人查找到订单，并且该订单确实找不到归属时，该订单归属查找人；',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                      maxLines: 2,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\t4.已归属的订单不支持继续找回；',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              btmBarView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget createTextField() {
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
            ? SizedBox()
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
                ),
              ),
        suffixIconColor: Colors.grey,
      ),
    );
  }

  ///底部操作栏
  Widget btmBarView(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          RawMaterialButton(
            constraints: BoxConstraints(minHeight: 44),
            fillColor: phone['verify'] ? Colours.app_main : Color(0xFFD6D6D6),
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
            ),
          ),
        ],
      ),
    );
  }
}
