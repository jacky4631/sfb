/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/me/select_text_item.dart';
import 'package:sufenbao/util/bao_icons.dart';

import '../util/login_util.dart';

class MessageCenter extends StatefulWidget {
  @override
  _messageCenter createState() => _messageCenter();
}

class _messageCenter extends State<MessageCenter> {

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        bgColor: Colors.white,
        brightness: Brightness.dark,
        appBar: buildTitle(context,
            title: '消息通知',
            widgetColor: Colors.black,
            leftIcon: Icon(Icons.arrow_back_ios)),
        body: createMessageItem());
  }

  createMessageItem() {
    return PWidget.container(
        PWidget.column([
          SelectTextItem(
              title: '用户消息', leading: Icon(BaoIcons.fans), onTap: () {
            onTapLogin(context, '/fans');
          }),
          SelectTextItem(
              title: '收益消息', leading: Icon(BaoIcons.shop), onTap: () {
            onTapLogin(context, '/moneyList');
          }),
          SelectTextItem(
              title: '订单消息', leading: Icon(BaoIcons.order), onTap: () {
            onTapLogin(context, '/orderList');
          }),
          SelectTextItem(
              title: '热度消息', leading: Icon(BaoIcons.kefu), onTap: () {
            onTapLogin(context, '/energyList');
          }),
        ]),
        {
          'pd': [0, 0, 8, 8]
        });
  }

  @override
  void initState() {
    initData();
  }

  Future<void> initData() async {

  }
}
