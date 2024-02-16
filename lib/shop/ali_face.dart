/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter_ali_face_verify/flutter_ali_face_verify.dart';

final _aliFaceVerify = FlutterAliFaceVerify();


Future<bool> initFaceService() async {
  var result = await _aliFaceVerify.initService();
  return result;
}

Future startFaceService(certifyId, url) async {
  var result = await _aliFaceVerify.startService(
      certifyId: certifyId,
      bizCode: BizCode.faceSdk,
      extParams: {'url':url});
  return result;
}