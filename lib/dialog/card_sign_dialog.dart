/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * @discripe: 登录弹窗弹窗
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maixs_utils/util/utils.dart';


class CardSignDialog extends Dialog {
  String title;
  String desc;
  String? okTxt;
  String? cancelTxt;
  bool forceUpdate = false;
  Function? fun;
  CardSignDialog(this.title, this.desc, {Key? key, this.okTxt, this.cancelTxt,this.forceUpdate=false, this.fun}) : super(key: key);

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
                text: desc,
                style: TextStyle(color: Colors.black),
              ))),
          Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            children: [
              if(!forceUpdate)
                Expanded(child: _createButton(false)),
              if(!forceUpdate)
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
          if(!forceUpdate) {
            if (agree) {
              Navigator.pop(context, true);
            } else {
              Navigator.pop(context, false);
            }
          } else {
            if(fun!= null) {
              fun!();
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: agree
                ? [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                    ),
                    Text(
                      okTxt??'去认证',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ]
                : [
                    Text(
                      cancelTxt??'取消',
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
