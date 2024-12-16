import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alibc/alibc_const_key.dart';
import 'package:flutter_alibc/alibc_model.dart';
import 'package:flutter_alibc/flutter_alibc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _platformVersion = 'Unknown';
  String _info = '';

  List<String> test() {
    return List.generate(2, (i) => '$i');
  }

  @override
  void initState() {
    super.initState();
    // FlutterAlibc.responseFromShare.listen((data) {
    //   debugPrint(data);
    // });
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterAlibc.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    /* try {
      var initRes = await FlutterAlibc.initAlibc();
    } on Exception {}*/

    try {
      // var waite3s = await FlutterAlibc.openItemDetail(itemID: "12345");
      //var result = await FlutterAlibc.initAlibc();
      //print(result);
    } on Exception {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Container(
              child: Text('info: $_info'),
            ),
            TextButton(
              child: Text("初始化阿里百川"),
              onPressed: () async {
                try {
                  // 如果什么都不给
                  var result =
                      await FlutterAlibc.initAlibc(version: '1', appName: "2");
                  print(json.encode(result));
                  setState(() {
                    _info = json.encode(result);
                  });
                } on Exception {}
              },
            ),
            TextButton(
              child: Text("登录淘宝"),
              onPressed: () async {
                FlutterAlibc.loginTaoBao(loginCallback: (result) {
                  print(
                      "登录淘宝  ${result.data?.nick} ${result.data?.topAccessToken}");
                  setState(() {
                    _info = json.encode(result);
                  });
                });
              },
            ),
            TextButton(
              child: Text("登出淘宝"),
              onPressed: () {
                FlutterAlibc.loginOut();
              },
            ),
            TextButton(
              child: Text("淘客登录，二次授权"),
              onPressed: () async {
                FlutterAlibc.taoKeLogin(
                    url:
                        "https://oauth.taobao.com/authorize?response_type=token&client_id=27875713&state=1212&view=wap",
                    openType: AlibcOpenType.AlibcOpenTypeNative,
                    isNeedCustomNativeFailMode: true,
                    nativeFailMode:
                        AlibcNativeFailMode.AlibcNativeFailModeJumpH5,
                    taokeCallback: (map) {
                      print('淘客登录 ' + json.encode(map));
                      setState(() {
                        _info = json.encode(map);
                      });
                    });
                // print("access token ${result["accessToken"]}");
              },
            ),
            TextButton(
              child: Text("淘客登录，二次授权获取code"),
              onPressed: () async {
                ///redirect_uri 这里对应 开发者管理端 应用回调url  demo设置的是 http://www.163.com
                var result = FlutterAlibc.taoKeLoginForCode(
                    url:
                        "https://oauth.taobao.com/authorize?response_type=code&client_id=27824900&redirect_uri=http://www.163.com&state=1212&view=web",
                    openType: AlibcOpenType.AlibcOpenTypeNative,
                    isNeedCustomNativeFailMode: true,
                    taokeCallback: (map) {
                      print('淘客登录 ' + json.encode(map));
                    },
                    nativeFailMode:
                        AlibcNativeFailMode.AlibcNativeFailModeJumpH5);
              },
            ),
            TextButton(
              child: Text("唤起淘宝，openByUrl方式"),
              onPressed: () async {
                FlutterAlibc.openByUrl(
                    url:
                        "https://uland.taobao.com/coupon/edetail?e=0I2EBL%2BTWswGQASttHIRqRXxIesJCFV0jSsDEwaP11URqogtr65NL3IIxArmwXZQtYdj3OrQBBwJkllDQLUC%2B79fwBwwUiqlvyfAqbG%2BQWkG6QT52O7rmXYefz8NXcoYTJnbK5InWzlFfSAQOJJoy8NEaV3mm%2FQSzjZt5gElMznom9kMiklcP0KJ92VgfYGd&traceId=0b0d82cf15669814548736276e3d95&union_lens=lensId:0b0b6466_0c0d_16cd75f7c39_528f&xId=6MboRwsAi2s8Glbqt3lJLAwSlyrPyBLCZ01KOk6QzKCNhw8C6RjXgA1bNbZdKzp30gOqd1J5j1k7ei7HYId1QZ&ut_sk=1.utdid_null_1566981455011.TaoPassword-Outside.taoketop&sp_tk=77+lTU5nMllrdHRqSVLvv6U=",
                    //backUrl: "tbopen27822502:https://h5.m.taobao.com",
                    isNeedCustomNativeFailMode: true,
                    nativeFailMode:
                        AlibcNativeFailMode.AlibcNativeFailModeJumpH5,
                    taokeParams: TaokeParams()
                      ..pid = "mm_112883640_11584347_72287650277",
                    callback: (result) {
                      print(result);
                    });
              },
            ),
            TextButton(
              child: Text("唤起淘宝，openItemDetail方式"),
              onPressed: () async {
                FlutterAlibc.openItemDetail(
                    itemID: "575688730394",
                    schemeType: AlibcSchemeType.AlibcSchemeTaoBao,
                    isNeedCustomNativeFailMode: true,
                    nativeFailMode:
                        AlibcNativeFailMode.AlibcNativeFailModeJumpH5,
                    callback: (result) {
                      print(result);
                    });
              },
            ),
            TextButton(
              child: Text("打开店铺，openShop方式"),
              onPressed: () async {
                FlutterAlibc.openShop(
                    shopId: "71955116",
                    callback: (result) {
                      print(result);
                    });
              },
            ),
            TextButton(
              child: Text("打开购物车，openCart方式"),
              onPressed: () async {
                FlutterAlibc.openCart(callback: (result) {
                  print(result);
                });
              },
            ),
            TextButton(
              child: Text("允许打点"),
              onPressed: () {
                FlutterAlibc.syncForTaoke(true);
              },
            ),
            TextButton(
              child: Text("使用native Alipay"),
              onPressed: () {
                FlutterAlibc.useAlipayNative(true);
              },
            ),
          ],
        )),
      ),
    );
  }
}
