/*
 * @discripe: 0元购规则弹窗
 */
import 'package:flutter/material.dart';


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
                '收益规则',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                '1.解锁时间：在平台下单后，根据订单领取红包，等待7天解锁可提现；',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Text(
                '2.拆红包入口：【我的】->【订单明细】；',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Text(
                '3.提现入口：【我的】->【立即提现】->【提现】；',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Text(
                '4.平台下的任一订单都可以拆红包；',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Text(
                '5.拆开红包提现后又申请退款，平台会扣除收益，如果多次退款，平台会采取惩罚措施，包括但不限于降低拆红包收益，延长解锁天数；',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 5,
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
