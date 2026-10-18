/**
 *  Copyright (C) 2018-2026
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/foundation.dart';
import 'package:flutter_alibc/alibc_model.dart';
import 'package:flutter_alibc/flutter_alibc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'global.dart';
import 'single_flight.dart';

///合规：百川(支付宝系)SDK 内含读取 IMEI 等设备信息的 deviceid 模块，
///禁止在 APP 启动期初始化，只在用户真正触发淘宝授权/跳转时按需初始化一次。
class AlibcInit {
  AlibcInit._();

  static final SingleFlight _flight = SingleFlight();
  static bool _inited = false;

  static bool get inited => _inited;

  ///确保百川已初始化，未初始化则当场初始化；并发调用只初始化一次。
  static Future<bool> ensure() {
    if (_inited || Global.isWeb()) {
      return Future.value(_inited);
    }
    return _flight.run<bool>('alibcInit', () async {
      if (_inited) {
        return true;
      }
      try {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        InitModel model = await FlutterAlibc.initAlibc(
            version: packageInfo.version, appName: APP_NAME);
        _inited = model.errorCode == '0';
      } catch (error) {
        //初始化失败不能把调用方(授权/跳转)带崩，降级返回 false 由调用方兜底
        debugPrint('百川初始化失败：$error');
        _inited = false;
      }
      return _inited;
    });
  }
}
