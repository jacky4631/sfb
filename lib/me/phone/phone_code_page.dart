/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
// Removed maixs_utils imports - replaced with standard Flutter components
import 'package:pinput/pinput.dart';
import 'package:sufenbao/service.dart';

import '../../util/toast_utils.dart';

class PhoneCodePage extends StatefulWidget {
  final Map data;
  const PhoneCodePage(this.data, {Key? key,}) : super(key: key);

  @override
  _LoginThirdState createState() => _LoginThirdState();
}

class _LoginThirdState extends State<PhoneCodePage> {
  var agree = false;
  Map phone = {"value": null, "verify": false};
  int inputLength = 0;
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 30)),
              Text('请输入验证码',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30,
                  )),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Text('已发送验证码至',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      )),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text(widget.data['mobile'],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      )),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              _createCodeRow(context),
              Padding(padding: EdgeInsets.only(top: 30)),

            ],
          )),
    );
  }

  _createCodeRow(BuildContext context) {
    return Center(
      child: Pinput(
        autofocus: true,
        onChanged: (pin) => {},
        onCompleted: (pin) => {
          //如果选中就不弹出直接登录
            _login(pin)

        },
      ),
    );
  }

  _login(code) async {
    String mobile = widget.data['mobile'];
    Map res = await BService.bindMobile(mobile.replaceAll(' ', ''), code);
    if (res['success']) {
      ToastUtils.showToast('修改成功');
      Navigator.of(context).popUntil((route) {
        return route.settings.name!.startsWith('/authPage');
      });
    } else {
      ToastUtils.showToast(res['msg']);
    }
  }
}
