import 'package:maps_toolkit/maps_toolkit.dart';

import 'common_util.dart';
import 'geocode_entity.dart';
import 'parse_result.dart';

String _pathHead = 'assets/';

class GeocodeUtil {
  ///
  GeocodeUtil._();

  /// 经纬度地理编码
  static Future<GeocodeEntity> geocodeGPS(double lat, double lon, {String pathHead = 'assets/'}) async {
    _pathHead = pathHead;
    var data = GeocodeEntity(
      province: '',
      city: '',
      district: '',
      provinceId: '',
      cityId: '',
      districtId: '',
      latitude: lat,
      longitude: lon,
    );
    // 省
    final province = await _getProvince(lat, lon);
    data = data.copyWith(province: province.name, provinceId: province.id);

    // 市
    final city = await _getCity(lat, lon, data.provinceId);
    data = data.copyWith(city: city.name, cityId: city.id);

    // 区/县
    final district = await _getDistrict(lat, lon, data.cityId);
    data = data.copyWith(district: district.name, districtId: district.id);

    return data;
  }

  /// 获取区/县
  static Future<ParseResult> _getDistrict(double lat, double lon, String id) async {
    if (id.isEmpty) {
      return const ParseResult(name: '', id: '');
    }
    final jsList = await CommonUtil.getAssetJsonList('${_pathHead}district/$id.json');
    if (jsList.isEmpty) {
      return const ParseResult(name: '', id: '');
    }
    for (final js in jsList) {
      if (js is Map) {
        final status = GeocodeUtil.containsLocation(LatLng(lat, lon), js['polygon']);
        if (status) {
          final name = js['name'] != null ? js['name'].toString() : '';
          final id = js['id'] != null ? js['id'].toString() : '';
          return ParseResult(name: name, id: id);
        }
      }
    }
    return const ParseResult(name: '', id: '');
  }

  /// 获取城市
  static Future<ParseResult> _getCity(double lat, double lon, String id) async {
    if (id.isEmpty) {
      return const ParseResult(name: '', id: '');
    }
    final jsList = await CommonUtil.getAssetJsonList('${_pathHead}city/$id.json');
    if (jsList.isEmpty) {
      return const ParseResult(name: '', id: '');
    }
    for (final js in jsList) {
      if (js is Map) {
        final status = GeocodeUtil.containsLocation(LatLng(lat, lon), js['polygon']);
        if (status) {
          final name = js['name'] != null ? js['name'].toString() : '';
          final id = js['id'] != null ? js['id'].toString() : '';
          return ParseResult(name: name, id: id);
        }
      }
    }
    return const ParseResult(name: '', id: '');
  }

  /// 获取省
  static Future<ParseResult> _getProvince(double lat, double lon) async {
    final jsList = await CommonUtil.getAssetJsonList('${_pathHead}province/short.json');
    List<String> ids = [];
    for (final item in jsList) {
      if (item is Map) {
        final status = GeocodeUtil.containsLocation(LatLng(lat, lon), item['polygon']);
        if (status) {
          ids.add(item['id'].toString());
        }
      }
    }

    if (ids.isEmpty) {
      return const ParseResult(name: '', id: '');
    }
    if (ids.length == 1) {
      final pMap = await CommonUtil.getAssetJsonMap('${_pathHead}province/${ids[0]}.json');
      final name = pMap['name'] != null ? pMap['name'].toString() : '';
      return ParseResult(name: name, id: ids[0]);
    }

    for (final id in ids) {
      final iMap = await CommonUtil.getAssetJsonMap('${_pathHead}province/$id.json');
      final status = containsLocation(LatLng(lat, lon), iMap['polygon']);
      if (status) {
        final name = iMap['name'] != null ? iMap['name'].toString() : '';
        return ParseResult(name: name, id: id);
      }
    }
    return const ParseResult(name: '', id: '');
  }

  /// 判断点是否在多边形内
  static bool containsLocation(LatLng point, dynamic polygon) {
    if (polygon is List) {
      for (final poly in polygon) {
        if (poly is List) {
          List<double> p = [];
          for (final e in poly) {
            final v = num.tryParse(e.toString())?.toDouble();
            if (v != null) {
              p.add(v);
            }
          }
          final len = (p.length / 2).floor();
          final ply = List.generate(len, (index) => index).map((e) => LatLng(p[2 * e + 1], p[2 * e])).toList();
          final status = PolygonUtil.containsLocation(point, ply, true);
          if (status) return true;
        }
      }
    }
    return false;
  }
}
