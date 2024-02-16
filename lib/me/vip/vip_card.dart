/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/me/vip/vip_data.dart';

import '../../widget/CustomWidgetPage.dart';

class VipCardPage extends StatelessWidget {
  final Map grade;

  const VipCardPage(this.grade, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -size.width / 2,
            right: -size.width / 3,
            width: size.width * 1.4,
            height: size.width * 1.4,
            child: Hero(
              tag: 'hero_background_${grade['name']}',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                    gradient: LinearGradient(
                      //渐变位置
                        begin:
                        Alignment.topRight, //右上
                        end:
                        Alignment.bottomLeft, //左下
                        stops: [
                          0.0,
                          1.0
                        ], //[渐变起始点, 渐变结束点]
                        //渐变颜色[始点颜色, 结束颜色]
                        colors: vipMap['${grade['grade']}']?.colors ??
                            [
                              Colors.red,
                              Color.fromRGBO(
                                  36, 41, 46, 1)
                            ])
                ),

              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: kToolbarHeight + 20,
                child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      grade['name'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    ),
              )),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.1),
              child: Hero(
                tag: 'hero_image_${grade['name']}',
                child: Image.asset(
                  getVipBgImage(grade['grade']),
                  height: MediaQuery.of(context).size.width / 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}