class GpsEntity {
  final String code;
  final String message;
  final double latitude;
  final double longitude;

  bool get hasSuccess => code == '00000';

  const GpsEntity({
    required this.code,
    required this.message,
    required this.latitude,
    required this.longitude,
  });

  factory GpsEntity.fromMap(Map<dynamic, dynamic> map) {
    return GpsEntity(
      code: map['code'].toString(),
      message: map['message'].toString(),
      latitude: _Helper.getDoubleValue(map, 'latitude') ?? 0,
      longitude: _Helper.getDoubleValue(map, 'longitude') ?? 0,
    );
  }

  @override
  String toString() {
    return 'GpsEntity{code: $code, massage: $message, latitude: $latitude, longitude: $longitude}';
  }
}

class _Helper {
  _Helper._();

  /// 获取double值
  static double? getDoubleValue(Map<dynamic, dynamic> map, String key) {
    double? value;
    if (map[key] is double) {
      value = map[key] as double;
    } else if (map[key] is int) {
      value = (map[key] as int).toDouble();
    } else if (map[key] is String) {
      value = double.tryParse(map[key] as String);
    }
    return value;
  }
}
