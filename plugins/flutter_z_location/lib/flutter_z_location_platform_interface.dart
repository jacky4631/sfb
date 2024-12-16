import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_z_location_method_channel.dart';

abstract class FlutterZLocationPlatform extends PlatformInterface {
  /// Constructs a FlutterZLocationPlatform.
  FlutterZLocationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterZLocationPlatform _instance = MethodChannelFlutterZLocation();

  /// The default instance of [FlutterZLocationPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterZLocation].
  static FlutterZLocationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterZLocationPlatform] when
  /// they register themselves.
  static set instance(FlutterZLocationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>> getCoordinate(int accuracy) {
    throw UnimplementedError('getCoordinate() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>> requestPermission() async {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }
}
