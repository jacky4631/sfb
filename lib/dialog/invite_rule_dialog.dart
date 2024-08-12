/*
 * @discripe: 0元购规则弹窗
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';

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
    return PWidget.stack([
      PWidget.container(null,[400,500, Colors.transparent],
          {'pd':[24,8,30,30],
      'mg':[MediaQuery.of(context).padding.top + 200,0,16,16],
      'br': 16}),
      PWidget.container(
          PWidget.column([
            PWidget.textNormal('邀请规则',[Colors.black, 16,true],{'ct':true}),
            PWidget.boxh(24),
            PWidget.textNormal('1.邀请的好友在【我的】>【我的用户】查看；',[Colors.black, 14],{'max':2}),
            PWidget.boxh(16),
            PWidget.textNormal(ts ? '2.金客是你自己邀请的好友，银客是你好友邀请的好友；' :
                '2.用户是你自己邀请的好友',[Colors.black, 14],{'max':2}),
            PWidget.boxh(16),
            PWidget.textNormal('3.邀请的好友在平台下单时，推荐人可以获得推荐奖励；',[Colors.black, 14],{'max':2}),
            PWidget.boxh(16),
            PWidget.textNormal(ts ? '4.金客拆红包奖励您20%，银客拆红包奖励您10%；':
                '4.用户拆红包奖励您20%',[Colors.black, 14],{'max':2}),
             ]),
          [400,400, Colors.white],
          {'pd':[24,8,30,30],
            'mg':[MediaQuery.of(context).padding.top + 200,0,32,32],
            'br': 16}
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
        [null, 0, 100, 100],
      ),
    ]);
  }
}
