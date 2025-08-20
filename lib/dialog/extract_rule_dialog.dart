/*
 * @discripe: 0元购规则弹窗
 */
import 'package:flutter/material.dart';


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
    return Stack(
      children: [
        // 透明背景容器
        Container(
          width: 400,
          height: 500,
          margin: EdgeInsets.fromLTRB(
            16,
            MediaQuery.of(context).padding.top + 200,
            16,
            0,
          ),
          padding: EdgeInsets.fromLTRB(30, 24, 30, 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // 主要内容容器
        Container(
          width: 400,
          height: 400,
          margin: EdgeInsets.fromLTRB(
            32,
            MediaQuery.of(context).padding.top + 200,
            32,
            0,
          ),
          padding: EdgeInsets.fromLTRB(30, 24, 30, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '提现规则',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                '1.提现后T+1天到账(T为工作日)；',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Text(
                '2.最低提现金额1元；',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Text(
                '3.仅支持提现到【支付宝】；',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Text(
                '4.每天可提现一次；',
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
          top: 100,
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
