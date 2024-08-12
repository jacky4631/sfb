/*
 * @discripe: 0元购规则弹窗
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';


class ExtractRuleDialog extends Dialog {
  final Map data;
  final Function closeCallback;
  ExtractRuleDialog(
    this.data,
      this.closeCallback,{
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PWidget.stack([
      PWidget.container(null,[400,500, Colors.transparent],
          {'pd':[24,8,30,30],
      'mg':[MediaQuery.of(context).padding.top + 200,0,16,16],
      'br': 16}),
      PWidget.container(
          PWidget.column([
            PWidget.textNormal('提现规则',[Colors.black, 16,true],{'ct':true}),
            PWidget.boxh(24),
            PWidget.textNormal('1.提现后T+1天到账(T为工作日)；',[Colors.black, 14],{'max':2}),
            PWidget.boxh(16),
            PWidget.textNormal('2.最低提现金额1元；',[Colors.black, 14],{'max':2}),
            PWidget.boxh(16),
            PWidget.textNormal('3.仅支持提现到【支付宝】；',[Colors.black, 14],{'max':2}),
            PWidget.boxh(16),
            PWidget.textNormal('4.每天可提现一次；',[Colors.black, 14],{'max':2}),
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
