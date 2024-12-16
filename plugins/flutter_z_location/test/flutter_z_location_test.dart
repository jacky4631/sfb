import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_z_location/flutter_z_location_method_channel.dart';
import 'package:flutter_z_location/flutter_z_location_platform_interface.dart';

// class MockFlutterZLocationPlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterZLocationPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

void main() {
  final FlutterZLocationPlatform initialPlatform = FlutterZLocationPlatform.instance;

  test('$MethodChannelFlutterZLocation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterZLocation>());
  });

  test('getPlatformVersion', () async {
    // FlutterZLocation flutterZLocationPlugin = FlutterZLocation();
    // MockFlutterZLocationPlatform fakePlatform = MockFlutterZLocationPlatform();
    // FlutterZLocationPlatform.instance = fakePlatform;
    //
    // expect(await flutterZLocationPlugin.getPlatformVersion(), '42');
  });
}
