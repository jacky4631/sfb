/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * @discripe: 登录弹窗弹窗
 */
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maixs_utils/util/utils.dart';

import '../util/global.dart';

String _data =
    "亲爱的用户，感谢您对[$APP_NAME]的信任！我们依据最新的监管政策更新了《$APP_NAME隐私政策》和《用户服务协议及权益保障告知书》，点击“同意”即代表您已阅读并同意上述内容！";

class PrivacyDialog extends Dialog {
  Function? func;
  PrivacyDialog({this.func, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 5),
      child: Column(
        children: [
          Center(
            child: Text(
              '温馨提示',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                  text: TextSpan(
                text: '亲爱的用户，感谢您对[$APP_NAME]的信任！我们依据最新的监管政策更新了',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: '《用户服务协议》',
                    style: TextStyle(color: Colors.red),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Global.showProtocolPage(Global.userUrl, '用户服务协议');
                      },
                  ),
                  TextSpan(
                    text: '和',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: '《$APP_NAME隐私政策》',
                    style: TextStyle(color: Colors.red),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Global.showProtocolPage(Global.privacyUrl, '$APP_NAME隐私政策');
                      },
                  ),
                  TextSpan(
                    text: '\n点击“同意”即代表您已阅读并同意上述内容！',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ))),
          Padding(padding: EdgeInsets.only(top: 10)),
          Column(
            children: [
              _createButton(true),
              SizedBox(height: 5),
              _createButton(false),
            ],
          )
        ],
      ),
    );
  }

  _createButton(bool agree) {
    return TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            backgroundColor: agree ? Color(0xFFFB040F) : Colors.white),
        onPressed: () {
          Navigator.pop(context);
          if (agree) {
            agreeFunc();
          } else {
            if (Global.isIOS()) {
              exit(0);
            } else {
              SystemNavigator.pop();
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: agree
                ? [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                    ),
                    Text(
                      '同意',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ]
                : [
                    Text(
                      '不同意',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
          ),
        ));
  }
  Future agreeFunc() async{
    await Global.saveAgree();
    func!();
  }
}
