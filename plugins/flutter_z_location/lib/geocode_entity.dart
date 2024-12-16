/// 地理编码模型
class GeocodeEntity {
  /// 省
  final String province;

  ///
  final String provinceId;

  /// 市
  final String city;

  ///
  final String cityId;

  /// 区
  final String district;

  ///
  final String districtId;

  /// 纬度
  final double latitude;

  /// 经度
  final double longitude;

  factory GeocodeEntity.empty() {
    return const GeocodeEntity(
      province: '',
      provinceId: '',
      city: '',
      cityId: '',
      district: '',
      districtId: '',
      latitude: 0,
      longitude: 0,
    );
  }

//<editor-fold desc="Data Methods">
  const GeocodeEntity({
    required this.province,
    required this.provinceId,
    required this.city,
    required this.cityId,
    required this.district,
    required this.districtId,
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeocodeEntity &&
          runtimeType == other.runtimeType &&
          province == other.province &&
          provinceId == other.provinceId &&
          city == other.city &&
          cityId == other.cityId &&
          district == other.district &&
          districtId == other.districtId &&
          latitude == other.latitude &&
          longitude == other.longitude);

  @override
  int get hashCode =>
      province.hashCode ^
      provinceId.hashCode ^
      city.hashCode ^
      cityId.hashCode ^
      district.hashCode ^
      districtId.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;

  @override
  String toString() {
    return 'GeocodeEntity{ province: $province, provinceId: $provinceId, city: $city, cityId: $cityId, district: $district, districtId: $districtId, latitude: $latitude, longitude: $longitude,}';
  }

  GeocodeEntity copyWith({
    String? province,
    String? provinceId,
    String? city,
    String? cityId,
    String? district,
    String? districtId,
    double? latitude,
    double? longitude,
  }) {
    return GeocodeEntity(
      province: province ?? this.province,
      provinceId: provinceId ?? this.provinceId,
      city: city ?? this.city,
      cityId: cityId ?? this.cityId,
      district: district ?? this.district,
      districtId: districtId ?? this.districtId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

//</editor-fold>
}

extension ExGeocodeEntity on GeocodeEntity {
  /// 地址
  String get address {
    final res = [province, city, district].where((element) => element.isNotEmpty).join('-');
    return res;
  }
}
