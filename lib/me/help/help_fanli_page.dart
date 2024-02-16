/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';

import '../../util/colors.dart';
import '../../util/global.dart';

class HelpFanliPage extends StatefulWidget {
  @override
  _HelpFanliState createState() => _HelpFanliState();
}

class _HelpFanliState extends State<HelpFanliPage> {
  late String version = '';
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version; //读取属性
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.light,
      bgColor: Colours.app_main,
      appBar: buildTitle(context,
          title: '拆红包教程',
          widgetColor: Colors.white,
          leftIcon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          )),
      body: PWidget.container(ListView.builder(
          itemCount: getWidgets().length,
          itemBuilder: (context, i) {
        return getWidgets()[i];
      }), {
        'wali': [0.0, 0.0],
        'pd': [0,    20, 20, 20]
      }),
    );
  }

  List<Widget> getWidgets() {
    List blackStyle = [Colors.black, 16, true];
    List redStyle = [Colors.red, 16, true];
    return [
      PWidget.container(
          ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                'assets/images/logo.png',
                height: 100,
              )),
          [
            null,
            null,
            Colors.white
          ],
          {
            'mg': [10, 0, 0, 0],
            'pd': 2,
            'crr': 28,
            'wali': [0.0, 0.0],
          }),
      PWidget.boxh(30),
      PWidget.text('', [], {
        'ct': true
      }, [
        PWidget.textIs('“简单', [Colors.white, 24, true], {}),
        PWidget.textIs('三步', [Colors.yellow[800], 24, true], {}),
        PWidget.textIs('，轻松领红包”', [Colors.white, 24, true], {}),
      ]),
      PWidget.boxh(30),
      PWidget.container(
          PWidget.column([
            PWidget.boxh(30),
            PWidget.text('提  示 ', [
              Colors.yellow[900],
              16,
              true
            ], {
              'ct': true,
              'max': 2
            }, [
              PWidget.textIs(' 通过平台购买任意商品都可拆红包 ', redStyle, {}),
            ]),
            PWidget.boxh(30),
            PWidget.text('或  者 ', [
              Colors.yellow[900],
              16,
              true
            ], {
              'ct': true,
              'max': 2
            },),

            PWidget.boxh(30),
            PWidget.text('第一步 ', [
              Colors.yellow[900],
              16,
              true
            ], {
              'ct': true,
              'max': 2
            }, [
              PWidget.textIs(' 打开 ', blackStyle, {}),
              PWidget.textIs('淘宝/京东/拼多多/唯品会/抖音', redStyle, {}),
              PWidget.textIs(' 任意一款你想要的商品', blackStyle, {}),
            ]),
            PWidget.boxh(10),
            PWidget.row([
              PWidget.image('assets/images/mall/tb.png', [32, 32]),
              PWidget.boxw(10),
              PWidget.image('assets/images/mall/jd.png', [32, 32]),
              PWidget.boxw(10),
              PWidget.image('assets/images/mall/pdd.png', [32, 32]),
              PWidget.boxw(10),
              PWidget.image('assets/images/mall/vip.png', [32, 32], {'fun':
                  ()=>Navigator.pushNamed(context, '/helpVideo',
                      arguments: {'title': '唯品会领券帮助', 'url':'viphelp.mp4'})}),
              PWidget.boxw(10),
              PWidget.image('assets/images/mall/dy.png', [32, 32]),
            ], '221'),
            PWidget.boxh(30),
            PWidget.text('第二步 ', [
              Colors.yellow[900],
              16,
              true
            ], {
              'ct': true,
              'max': 2
            }, [
              PWidget.textIs('点击右上角 ', blackStyle, {}),
              PWidget.textIs('分享', redStyle, {}),
              PWidget.textIs('，然后点击 ', blackStyle, {}),
              PWidget.textIs('复制链接 ', redStyle, {}),
            ]),
            PWidget.container(
              PWidget.image('assets/images/help/copylink.png', [336, 150]),
            ),
            PWidget.boxh(20),
            PWidget.text('第三步 ', [
              Colors.yellow[900],
              16,
              true
            ], {
              'max': 2
            }, [
              PWidget.textIs('打开 ', blackStyle, {}),
              PWidget.textIs(APP_NAME, redStyle, {}),
              PWidget.textIs('，领取优惠', blackStyle, {}),
            ]),
            PWidget.container(
              PWidget.image('assets/images/help/pickcou.png', [600, 250]),
            ),
            PWidget.boxh(30),
          ]),
          [
            null,
            null,
            Colors.white
          ],
          {
            'pd': [8,8,15,16],
            'crr': 10,
            'mg': [10, 10, 10, 10],
            'wali': [0.0, 0.0],
          })
    ];
  }
}
