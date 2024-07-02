import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ali_face_verify_result.dart';
import 'flutter_ali_face_verify_platform_interface.dart';

/// An implementation of [FlutterAliFaceVerifyPlatform] that uses method channels.
class MethodChannelFlutterAliFaceVerify extends FlutterAliFaceVerifyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('club.openflutter/flutter_ali_face_verify');

  @override
  Future<bool> initService() async {
    final result = await methodChannel.invokeMethod<bool>("initService");
    return result ?? false;
  }

  @override
  Future<AliFaceVerifyResult> startService(
      {required String certifyId,
      Map<String, String> extParams = const {}}) async {
    final result = await methodChannel.invokeMethod<Map>(
        "startService", {"certifyId": certifyId, "extParams": extParams});
    return AliFaceVerifyResult.fromJson(result ?? {});
  }
}
