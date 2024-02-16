/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/me/cash/widgets/my_button.dart';

import '../../widget/load_image.dart';

//提现结果
class CashResultPage extends StatefulWidget {

  const CashResultPage({super.key});

  @override
  _CashResultPageState createState() => _CashResultPageState();
}

class _CashResultPageState extends State<CashResultPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '提现结果', widgetColor: Colors.black, leftIcon: Icon(Icons.arrow_back_ios)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            PWidget.boxh(50),
            const LoadAssetImage('cash/sqsb',
              width: 80.0,
              height: 80.0,
            ),
            PWidget.boxh(12),
            const Text(
              '提现申请提交失败，请重新提交',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
    PWidget.boxh(8),
            Text(
              '2021-02-21 15:20:10',
              style: Theme.of(context).textTheme.subtitle2,
            ),
    PWidget.boxh(8),
            Text(
              '5秒后返回提现页面',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            PWidget.boxh(24),
            MyButton(
              onPressed: () => {
                // NavigatorUtils.goBack(context)
    },
              text: '返回',
            )
          ],
        ),
      ),
    );
  }
}
