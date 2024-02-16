/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * @discripe: 登录弹窗弹窗
 */
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maixs_utils/util/utils.dart';

import '../util/global.dart';

class SimplePrivacyDialog extends Dialog {
  SimplePrivacyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
      child: Column(
        children: [
          Center(
            child: Text(
              '用户服务协议和隐私政策',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                  text: TextSpan(
                text: '请阅读并同意',
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
                ],
              ))),
          Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            children: [
              Expanded(child: _createButton(false)),
              SizedBox(height: 5),
              Expanded(child: _createButton(true)),
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
          backgroundColor: agree ? Color(0xFFFB040F) : Colors.white,
        ),
        onPressed: () {
          if (agree) {
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context, false);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
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
}
