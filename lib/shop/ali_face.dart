/**
 *  Copyright (C) 2018-2026
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter_ali_face_verify/flutter_ali_face_verify.dart';

final _aliFaceVerify = FlutterAliFaceVerify();

bool _faceInited = false;

///合规：人脸(支付宝系 mPaaS)SDK 内含读取 IMEI 等设备信息的 deviceid 模块，
///禁止在 APP 启动期初始化，只在用户触发人脸核验时按需初始化一次。
Future<bool> initFaceService() async {
  if (_faceInited) {
    return true;
  }
  var result = await _aliFaceVerify.initService();
  _faceInited = result;
  return result;
}

Future startFaceService(certifyId, url) async {
  await initFaceService();
  var result = await _aliFaceVerify.startService(
      certifyId: certifyId,
      bizCode: BizCode.faceSdk,
      extParams: {'url':url});
  return result;
}