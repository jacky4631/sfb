/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
//APP启动页
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';

import '../dialog/privacyDialog.dart';
import '../index/Index.dart';
import '../util/global.dart';
import 'countdown.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool agree = false;
  @override
  void initState() {
    super.initState();
    // initAds().then((value) {
    //   if (value) {
    //       showSplashAd();
    //   }
    // }); //初始化广告SDK
    // setAdEvent(); // 设置广告监听
    _initAsync();
  }

  void _initAsync() async {
    // App启动时读取Sp数据，需要异步等待Sp初始化完成。
    agree = await Global.getAgree();
    if (!agree) {
      showPrivacyDialog(func: () {
        setState(() {
          agree = true;
          Navigator.of(context).pushReplacementNamed('/index');
        });
      });
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!agree) {
      return ScaffoldWidget(
        body: Container(
          child: Stack(
            children: <Widget>[
              createContent(),
            ],
          ),
        ),
      );
    }
    return ScaffoldWidget(
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 25,
              top: 25,
              child: CountdownInit(),
            ),
            createContent(),
          ],
        ),
      ),
    );
  }

  Widget createContent() {
    return PWidget.container(
        PWidget.image(
          'assets/images/splash.png',
          [1080, 1920, null, BoxFit.contain],
        ),
        [
          null,
          null,
          Colors.white
        ],
        {
          'pd': [16, 16, 16, 16]
        });
  }

  Future showPrivacyDialog({func}) async {
    if ((agree == null || !agree) && !Global.showPrivacy) {
      Global.showPrivacy = true;
      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.noHeader,
        body: PrivacyDialog(func: func),
      )..show();
    }
  }

  // Future<void> setAdEvent() async {
  //   FlutterQqAds.onEventListener((event) {
  //    var _adEvent = 'adId:${event.adId} action:${event.action}';
  //     if (event is AdErrorEvent) {
  //       // 错误事件
  //       _adEvent += ' errCode:${event.errCode} errMsg:${event.errMsg}';
  //     }
  //     print('onEventListener:$_adEvent');
  //     setState(() {});
  //   });
  // }
  // Future<bool> initAds() async {
  // try {
  //   bool result = await FlutterQqAds.initAd("1202787514");
  //   return result;
  // } on PlatformException catch (e) {
  //   var _result =
  //       "广告SDK 初始化失败 code:${e.code} msg:${e.message} details:${e.details}";
  //   print(_result);
  // }
  // return false;
  // }
  // Future<void> showSplashAd([String? logo]) async {
  // try {
  //   await FlutterQqAds.showSplashAd("1045965865265237", logo: logo,fetchDelay: 3);
  //  } on PlatformException catch (e) {
  //   var _result =
  //       "展示开屏广告失败 code:${e.code} msg:${e.message} details:${e.details}";
  //   print(_result);
  //  }
  // }
}
