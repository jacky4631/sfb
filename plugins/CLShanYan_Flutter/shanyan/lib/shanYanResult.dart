/**
 * 闪验SDK 统一回调
 * */

import 'package:json_annotation/json_annotation.dart';
part 'shanYanResult.g.dart';

@JsonSerializable()

class ShanYanResult {

  ShanYanResult({this.code ,this.message ,this.innerCode ,this.innerDesc,this.token});

  int? code; //返回码
  String? message; //描述
  int? innerCode; //内层返回码
  String? innerDesc; //内层事件描述
  String? token; //token

  //反序列化
  factory ShanYanResult.fromJson(Map<String, dynamic> json) => _$ShanYanResultFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ShanYanResultToJson(this);
}