/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('消息通知'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: createMessageItem());
  }

  createMessageItem() {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        children: [
          SelectTextItem(
              title: '用户消息',
              leading: Icon(BaoIcons.fans),
              onTap: () {
                onTapLogin(context, '/fans');
              }),
          SelectTextItem(
              title: '收益消息',
              leading: Icon(BaoIcons.shop),
              onTap: () {
                onTapLogin(context, '/moneyList');
              }),
          SelectTextItem(
              title: '订单消息',
              leading: Icon(BaoIcons.order),
              onTap: () {
                onTapLogin(context, '/orderList');
              }),
          SelectTextItem(
              title: '热度消息',
              leading: Icon(BaoIcons.kefu),
              onTap: () {
                onTapLogin(context, '/energyList');
              }),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {}
}
