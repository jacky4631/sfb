import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sufenbao/util/global.dart';

/// 模拟 device_info_plus 在非 Android 平台（iOS）返回的设备信息。
/// iOS 原生端只实现了 getDeviceInfo，返回的 map 里不含 board / manufacturer /
/// model 等 Android 字段，见 FPPDeviceInfoPlusPlugin.m。
Map<String, dynamic> iosDeviceInfoData() => <String, dynamic>{
      'name': 'iPhone',
      'systemName': 'iOS',
      'systemVersion': '27.0.1',
      'model': 'iPhone',
      'localizedModel': 'iPhone',
      'modelName': 'iPhone 15 Pro Max',
      'identifierForVendor': 'xxxx-xxxx',
      'freeDiskSize': 1024,
      'totalDiskSize': 2048,
      'isPhysicalDevice': true,
      'isiOSAppOnMac': false,
      'isiOSAppOnVision': false,
      'physicalRamSize': 8192,
      'availableRamSize': 4096,
      'utsname': <String, dynamic>{
        'sysname': 'Darwin',
        'nodename': 'iPhone',
        'release': '24.0.0',
        'version': 'Darwin Kernel Version 24.0.0',
        'machine': 'iPhone15,3',
      },
    };

class _FakeDeviceInfoPlatform extends DeviceInfoPlatform {
  _FakeDeviceInfoPlatform(this._data);

  final Map<String, dynamic> _data;

  @override
  Future<BaseDeviceInfo> deviceInfo() async => BaseDeviceInfo(_data);
}

void main() {
  final DeviceInfoPlatform originalPlatform = DeviceInfoPlatform.instance;

  setUp(() {
    DeviceInfoPlatform.instance = _FakeDeviceInfoPlatform(iosDeviceInfoData());
  });

  tearDown(() {
    DeviceInfoPlatform.instance = originalPlatform;
  });

  test('isHuawei 在非 Android 平台返回 false 且不抛异常', () async {
    expect(await Global.isHuawei(), isFalse);
  });

  test('getAndroidVersion 在非 Android 平台不抛异常', () async {
    expect(await Global.getAndroidVersion(), isA<int>());
  });

  test('实名认证选择拍照时回调不应被设备信息解析异常打断', () async {
    // 复现 shop_auth_sec_page._showPicSheet 里 clickCallback 的第一行：
    // if(await Global.isHuawei()) { ... }
    // 一旦抛异常，整个 async 回调静默中断，表现为 iOS 点击无响应。
    Object? caught;
    try {
      await Global.isHuawei();
    } catch (error) {
      caught = error;
    }
    expect(caught, isNull, reason: '点击拍照的回调被异常中断：$caught');
  });
}
