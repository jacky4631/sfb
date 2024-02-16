/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/shop/shop_auth_sec_page.dart';

import '../util/paixs_fun.dart';

class ShopAuthPage extends StatefulWidget {
  @override
  _ShopAuthPageState createState() => _ShopAuthPageState();
}

class _ShopAuthPageState extends State<ShopAuthPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {


  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        body: Stack(children: [
          ScaffoldWidget(
            brightness: Brightness.dark,
            appBar: buildTitle(context, title: '实名认证', widgetColor: Colors.black,
              leftIcon: Icon(Icons.arrow_back_ios, color: Colors.black,),),
            bgColor: Colors.transparent,
            body: PWidget.container(ShopAuthSecPage(),
              [null, null, Color(0xffF6F6F6)],
              {'crr': PFun.lg(16, 16),
                // 'exp': true
              },
              //   )
              // ],
            ),
          )
        ]));
  }

}
