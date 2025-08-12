import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dio/dio.dart';
import 'dart:developer' as f;

import 'package:json_annotation/json_annotation.dart';
part 'data_model.g.dart';

@CopyWith()
@JsonSerializable()
class DataModel {
  ///数据与页面交互的标记
  ///
  ///0：初始化
  ///
  ///1：出现异常
  ///
  ///2：数据集是空
  ///
  ///其他：成功拿到数据
  int flag;

  ///异常的错误信息
  String? msg;

  ///数据分页
  int page;

  ///分页条数
  int size;

  ///是否有下一页
  bool hasNext;

  ///页面上的各类值的集合
  List<dynamic> value = <dynamic>[];

  ///列表的数据集
  List list = [];

  ///对象
  dynamic object;

  // 是否刷新
  bool? isRef;

  DataModel({
    this.isRef,
    this.flag = 0,
    this.value = const <dynamic>[0],
    this.msg,
    this.page = 1,
    this.size = 20,
    this.hasNext = true,
    this.object,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => _$DataModelFromJson(json);
  Map<String, dynamic> toJson() => _$DataModelToJson(this);

  ///错误状态处理
  void toError(dynamic v, [bool isLine = true]) {
    this.flag = this.list.isEmpty ? 1 : -1;
    if (isLine) {
      this.msg = v;
    } else {
      this.msg = v + '\n';
    }
  }

  ///刷新
  void setTime() => this.flag = getTime();

  ///初始化数据模型
  void init([v]) {
    this.page = 1;
    this.list.clear();
    // this.object = v ?? {};
    this.hasNext = false;
    this.flag = 0;
  }

  ///添加list集合数据
  void addListModel(dynamic data, bool isRef) {
    if (isRef) this.page = 1;
    if (isRef) this.list.clear();
    list.addAll(data['result']['data']);
    this.msg = '请求成功';
    this.addPage(data['result']['totalRows']);
  }

  ///添加list集合数据
  void addList(dynamic data, bool isRef, total) {
    if (isRef) this.page = 1;
    if (isRef) this.list.clear();
    list.addAll(data);
    this.msg = '请求成功';
    this.addPage(total);
  }

  ///分页状态处理
  void addPage([dynamic data]) {
    try {
      this.hasNext = this.page * 10 < data;
      this.flag = this.list.isEmpty ? (this.page == 1 ? 2 : -2) : getTime();
      if (this.hasNext) this.page++;
    } catch (e) {}
  }

  ///List成功状态处理
  void toList(Response<dynamic> res, bool isRef, dynamic Function(dynamic) fun) {
    if (res != null) {
      addList(res.data, isRef, fun);
      addPage(res.data);
      List list;
      try {
        list = res.data['data'] as List;
      } catch (e) {
        list = res.data as List;
      }
      this.flag = list.isEmpty
          ? this.page == 1
              ? 2
              : -2
          : getTime();
      if (list.isEmpty) this.msg = '暂无更多数据';
    }
  }

  ///value成功状态处理
  void toValue(Response<dynamic> res, List<dynamic> Function(dynamic) fun) {
    if (res != null) {
      this.value = fun.call(res.data);
      this.flag = getTime();
    }
  }

  ///Objiect成功状态处理
  void toObject(Response<dynamic> res, [dynamic Function(dynamic)? fun]) {
    if (res != null) {
      this.object = fun == null ? res.data : fun.call(res.data);
      this.flag = getTime();
    }
  }

  ///添加Objiect数据
  void addObject(data) {
    this.object = data;
    this.setTime();
  }

  int getTime() => DateTime.now().millisecondsSinceEpoch;

  ///打印数据
  void flog(v, [String? name]) => f.log(v.toString(), name: name ?? 'flog');
  void toLog() => flog(json.encode(this.toJson()));
}
