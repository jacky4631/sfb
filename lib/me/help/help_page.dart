/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import '../../util/colors.dart';

class HelpPage2 extends StatefulWidget {
  @override
  _HelpPage2State createState() => _HelpPage2State();
}

class _HelpPage2State extends State<HelpPage2> {
  double size = 28;
  int radius = 8;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '新手帮助',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            createCard('hot',
                icon: Icon(
                  Icons.hotel_class,
                  color: Colors.white,
                  size: size,
                ),
                title: '热门问题'),
            createCard('gongneng',
                icon: Icon(
                  Icons.functions,
                  color: Colors.white,
                  size: size,
                ),
                title: '产品功能'),
            createCard('invite',
                icon: Icon(
                  Icons.calculate_outlined,
                  color: Colors.white,
                  size: size,
                ),
                title: '邀请好友'),
            createCard('order',
                icon: Icon(
                  Icons.collections,
                  color: Colors.white,
                  size: size,
                ),
                title: '关于订单'),
            createCard('income',
                icon: Icon(
                  Icons.collections_bookmark,
                  color: Colors.white,
                  size: size,
                ),
                title: '关于收益'),
            createCard('tixian',
                icon: Icon(
                  Icons.outbox,
                  color: Colors.white,
                  size: size,
                ),
                title: '关于提现'),
            createCard('youhui',
                icon: Icon(
                  Icons.countertops,
                  color: Colors.white,
                  size: size,
                ),
                title: '关于优惠'),
            createCard('jifen',
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

  Widget createCard(
    key, {
    title,
    icon,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Colours.app_main,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0XFF585858).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.pushNamed(context, '/helpContentPage', arguments: {'key': key, 'title': title});
          },
          child: Center(
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
        ),
      ),
    );
  }
}
