library flutter_z_location;

export 'flutter_z_location.dart';
export 'gps_entity.dart';
export 'common_util.dart';
export 'geocode_entity.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'flutter_z_location_platform_interface.dart';
import 'geocode_entity.dart';
import 'geocode_util.dart';
import 'gps_entity.dart';
import 'ip_util.dart';
import 'permission_entity.dart';

class FlutterZLocation {
  FlutterZLocation._();

  ///
  static Future<String?> getPlatformVersion() {
    return FlutterZLocationPlatform.instance.getPlatformVersion();
  }

  /// gps获取经纬度
  ///
  /// [accuracy] 定位精度,默认为2(粗略位置):
  /// 1-准确位置(android对应-ACCURACY_FINE, iOS对应-kCLLocationAccuracyBest)
  /// 2-粗略位置(android对应-ACCURACY_COARSE, iOS对应-kCLLocationAccuracyKilometer)
  ///
  static Future<GpsEntity> getCoordinate({int accuracy = 2}) async {
    final json = await FlutterZLocationPlatform.instance.getCoordinate(accuracy);
    final data = GpsEntity.fromMap(json);
    return data;
  }

  /// 获取ip地址
  static Future<String> getIp() async {
    try {
      HttpClient client = HttpClient();
      final uri = Uri.tryParse('https://api.ipify.org?format=json');
      if (uri == null) {
        return '';
      }
      final request = await client.getUrl(uri);
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final js = jsonDecode(responseBody);
        if (js is Map && js['ip'] is String) {
          return js['ip'] as String;
        }
      }
      return '';
    } catch (e) {
      debugPrint("FlutterGps-getIp: $e");
      return '';
    }
  }

  /// 经纬度地理反编码
  static Future<GeocodeEntity> geocodeCoordinate(double lat, double lon, {String pathHead = 'assets/'}) async {
    final res = await GeocodeUtil.geocodeGPS(lat, lon, pathHead: pathHead);
    return res;
  }

  /// 获取ip所在地理信息
  ///
  /// [ip] ip地址
  /// [pathHead] 资源头目录
  /// [hasGetCoordinate] 是否获取经纬度
  static Future<GeocodeEntity> geocodeIp(
    String ip, {
    String pathHead = 'assets/',
    bool hasGetCoordinate = false,
  }) async {
    final res = await IpUtil.geocodeIp(ip, pathHead: pathHead, hasGetCoordinate: hasGetCoordinate);
    return res;
  }

  @Deprecated('推荐使用`permission_handler`插件来获取权限')
  static Future<PermissionEntity> requestPermission() async {
    final json = await FlutterZLocationPlatform.instance.requestPermission();
    final data = PermissionEntity.fromMap(json);
    return data;
  }
}
