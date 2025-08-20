/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * 弹窗
 */
import 'package:flutter/material.dart';

import '../util/colors.dart';

class SimpleTextDialog extends Dialog {
  final String title;
  final String content;
  final String? okText;
  final String? cancelText;
  SimpleTextDialog(this.title, this.content, {this.okText, this.cancelText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
      child: Column(
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                  text: TextSpan(
                text: content,
                style: TextStyle(color: Colors.black),
              ))),
          Padding(padding: EdgeInsets.only(top: 10)),
          Center(
              child: Row(
            children: [
              Expanded(child: _createButton(context, false)),
              SizedBox(height: 5),
              Expanded(child: _createButton(context, true)),
            ],
          ))
        ],
      ),
    );
  }

  _createButton(BuildContext context, bool agree) {
    return TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          backgroundColor: agree ? Colours.app_main : Colors.white,
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
                      okText??'确定',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ]
                : [
                    Text(
                      cancelText??'取消',
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
