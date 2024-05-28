/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 *
 */
/*
 * @discripe: 活动弹窗
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:sufenbao/util/launchApp.dart';

import '../util/paixs_fun.dart';

class HuodongDialog extends Dialog {
  final Map data;
  final Function closeCallback;
  HuodongDialog(
    this.data,
      this.closeCallback,{
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      PWidget.container(
        PWidget.wrapperImage(data['img'], [
          350,
          350
        ], {
          'br': 16,
          'fun': () {
            Navigator.pop(context);
            click(context);
            this.closeCallback();
          }
        }),
        {
          'ali': PFun.lg(0, 0),
        },
      ),
      PWidget.positioned(
        PWidget.container(
          PWidget.icon(Icons.close, [Colors.white]),
          [48, 48, Colors.black26],
          {'br': 56, 'fun': () {
            Navigator.pop(context);
            this.closeCallback();
          }},
        ),
        [null, 150, 100, 100],
      ),
    ]);
  }

  Future click(BuildContext context) async {
    String package = data['package']??'';
    String url = data['url'];
    if (package.isEmpty) {
      var data = LaunchApp.getPackageName(url);
      package = data['package'];
    }
    await LaunchApp.launch(context, url, package,
        webUrl: data['webUrl'],
        title: data['title'],
        color: Color(int.parse('0xFF' + data['color']??'FFFFFF')));
  }
}
