// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shanYanResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShanYanResult _$ShanYanResultFromJson(Map<String, dynamic> json) {
  return ShanYanResult(
    code: json['code'] as int?,
    message: json['message'] as String?,
    innerCode: json['innerCode'] as int?,
    innerDesc: json['innerDesc'] as String?,
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$ShanYanResultToJson(ShanYanResult instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'innerCode': instance.innerCode,
      'innerDesc': instance.innerDesc,
      'token': instance.token,
    };
