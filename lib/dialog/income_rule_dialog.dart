/*
 * @discripe: 0元购规则弹窗
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';


class IncomeRuleDialog extends Dialog {
  final Map data;
  final Function closeCallback;
  IncomeRuleDialog(
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
            PWidget.textNormal('收益规则',[Colors.black, 16,true],{'ct':true}),
            PWidget.boxh(24),
            PWidget.textNormal('1.解锁时间：在平台下单后，根据订单领取红包，等待7天解锁可提现；',[Colors.black, 14],{'max':2}),
            PWidget.boxh(16),
            PWidget.textNormal('2.拆红包入口：【我的】->【订单明细】；',[Colors.black, 14],{'max':2}),
            PWidget.boxh(16),
            PWidget.textNormal('3.提现入口：【我的】->【立即提现】->【提现】；',[Colors.black, 14],{'max':2}),
            PWidget.boxh(16),
            PWidget.textNormal('4.平台下的任一订单都可以拆红包；',[Colors.black, 14],{'max':2}),
            PWidget.boxh(16),
            PWidget.textNormal('5.拆开红包提现后又申请退款，平台会扣除收益，如果多次退款，平台会采取惩罚措施，包括但不限于降低拆红包收益，延长解锁天数；',[Colors.black, 14],{'max':5}),
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
