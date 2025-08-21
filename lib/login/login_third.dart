/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';
import 'package:sufenbao/util/login_util.dart';

import '../httpUrl.dart';

class LoginThird extends StatefulWidget {
  final Map data;
  const LoginThird(this.data, {Key? key,}) : super(key: key);

  @override
  _LoginThirdState createState() => _LoginThirdState();
}

class _LoginThirdState extends State<LoginThird> {
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

  _login(code) {
    String mobile = widget.data['mobile'];
    suClient.post(
        API.login,
        data: {
          'account': mobile.replaceAll(' ', ''),
          'openId': widget.data['openId'],
          'captcha': code
        }, options: new Options(receiveTimeout: Duration(milliseconds: 8000))
    ).then((res) {
      //校验是否登录成功
      //登录成功 保存token
      afterLogin(res.data, context);
    }).catchError((err) {
      print(err);
    });
  }
}
