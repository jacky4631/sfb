/*
 * @discripe: 0元购规则弹窗
 */
import 'package:flutter/material.dart';

import '../util/global.dart';


class InviteRuleDialog extends Dialog {
  final Map data;
  final Function closeCallback;
  InviteRuleDialog(
    this.data,
      this.closeCallback,{
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool ts = Global.appInfo.spreadLevel == 3;
    return Stack(
      children: [
        // 透明背景容器
        Container(
          width: 400,
          height: 500,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 200,
            left: 16,
            right: 16,
          ),
          padding: EdgeInsets.fromLTRB(24, 8, 30, 30),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // 主要内容容器
        Container(
          width: 400,
          height: 400,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 200,
            left: 32,
            right: 32,
          ),
          padding: EdgeInsets.fromLTRB(24, 8, 30, 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '邀请规则',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                '1.邀请的好友在【我的】>【我的用户】查看；',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Text(
                ts ? '2.金客是你自己邀请的好友，银客是你好友邀请的好友；' : '2.用户是你自己邀请的好友',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Text(
                '3.邀请的好友在平台下单时，推荐人可以获得推荐奖励；',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Text(
                ts ? '4.金客拆红包奖励您20%，银客拆红包奖励您10%；' : '4.用户拆红包奖励您20%',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // 关闭按钮
        Positioned(
          top: MediaQuery.of(context).padding.top + 200,
          right: 100,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              closeCallback();
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(56),
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
