import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ali_face_verify_result.dart';
import 'flutter_ali_face_verify_method_channel.dart';

abstract class FlutterAliFaceVerifyPlatform extends PlatformInterface {
  /// Constructs a FlutterPluginTestPlatform.
  FlutterAliFaceVerifyPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAliFaceVerifyPlatform _instance = MethodChannelFlutterAliFaceVerify();

  /// The default instance of [FlutterAliFaceVerifyPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPluginTest].
  static FlutterAliFaceVerifyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAliFaceVerifyPlatform] when
  /// they register themselves.
  static set instance(FlutterAliFaceVerifyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 建议开发者在 App 运行初期尽早调用初始化代码，如隐私政策同意后的最早期。
  Future<bool> initService() {
    throw UnimplementedError('initService() has not been implemented.');
  }

  Future<AliFaceVerifyResult> startService(
      {required String certifyId, Map<String, String> extParams = const {}}){
    throw UnimplementedError('startService() has not been implemented.');
  }
}
