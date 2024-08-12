/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';

import '../../util/colors.dart';
import '../../util/paixs_fun.dart';

class HelpPage2 extends StatefulWidget {
  @override
  _HelpPage2State createState() => _HelpPage2State();
}

class _HelpPage2State extends State<HelpPage2> {
  double size = 28;
  int radius = 8;
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      bgColor: Colors.white,
      appBar: buildTitle(context,
          title: '新手帮助',
          widgetColor: Colors.black,
          leftIcon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          )),
      body: Container(
        child: ListView(
          children: [
            createCard(
              'hot',
                icon: Icon(
                  Icons.hotel_class,
                  color: Colors.white,
                  size: size,
                ),
                title: '热门问题'),
            createCard(
              'gongneng',
                icon: Icon(
                  Icons.functions,
                  color: Colors.white,
                  size: size,
                ),
                title: '产品功能'),
            createCard(
                'invite',
                icon: Icon(
                  Icons.calculate_outlined,
                  color: Colors.white,
                  size: size,
                ),
                title: '邀请好友'),
            createCard(
              'order',
                icon: Icon(
                  Icons.collections,
                  color: Colors.white,
                  size: size,
                ),
                title: '关于订单'),
            createCard(
                'income',
                icon: Icon(
                  Icons.collections_bookmark,
                  color: Colors.white,
                  size: size,
                ),
                title: '关于收益'),
            createCard(
                'tixian',
                icon: Icon(
                  Icons.outbox,
                  color: Colors.white,
                  size: size,
                ),
                title: '关于提现'),
            createCard(
              'youhui',
                icon: Icon(
                  Icons.countertops,
                  color: Colors.white,
                  size: size,
                ),
                title: '关于优惠'),
            createCard(
                'jifen',
                icon: Icon(
                  Icons.calculate_outlined,
                  color: Colors.white,
                  size: size,
                ),
                title: '关于积分'),
          ],
          // squeeze: 1.0,
          // itemExtent: 180,
          // diameterRatio: 1.9,
          // offAxisFraction: -0.5,
          // onSelectedItemChanged: (int){
          //   // Navigator.pushNamed(context, '/helpContentPage');
          // },
        ),
      ),
    );
  }

  Widget createCard(key, {
    title,
    icon,
  }) {
    return PWidget.container(
        Center(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 25),
            leading: icon,
            trailing: Text(
              title!,
              style: TextStyle(
                fontSize: 21,
                color: Colors.white,
              ),
            ),
          ),
        ),
        [
          null,
          null,
          Colours.app_main
        ],
        {
          'fun': () {
            Navigator.pushNamed(context, '/helpContentPage', arguments: {'key': key,'title': title});
          },
          'anima': [1000],
          'mg': PFun.lg(20, 20, 50, 50),
          'br': 20,
          'sd': [Color(0XFF585858).withOpacity(.3), 8, 5, 5]
          // curve: Curves.elasticInOut,
        });
  }
}
