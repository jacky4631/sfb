// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DataModelCWProxy {
  DataModel isRef(bool? isRef);

  DataModel flag(int flag);

  DataModel value(List<dynamic> value);

  DataModel msg(String? msg);

  DataModel page(int page);

  DataModel size(int size);

  DataModel hasNext(bool hasNext);

  DataModel object(dynamic object);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DataModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DataModel(...).copyWith(id: 12, name: "My name")
  /// ````
  DataModel call({
    bool? isRef,
    int flag,
    List<dynamic> value,
    String? msg,
    int page,
    int size,
    bool hasNext,
    dynamic object,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDataModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDataModel.copyWith.fieldName(...)`
class _$DataModelCWProxyImpl implements _$DataModelCWProxy {
  const _$DataModelCWProxyImpl(this._value);

  final DataModel _value;

  @override
  DataModel isRef(bool? isRef) => this(isRef: isRef);

  @override
  DataModel flag(int flag) => this(flag: flag);

  @override
  DataModel value(List<dynamic> value) => this(value: value);

  @override
  DataModel msg(String? msg) => this(msg: msg);

  @override
  DataModel page(int page) => this(page: page);

  @override
  DataModel size(int size) => this(size: size);

  @override
  DataModel hasNext(bool hasNext) => this(hasNext: hasNext);

  @override
  DataModel object(dynamic object) => this(object: object);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DataModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DataModel(...).copyWith(id: 12, name: "My name")
  /// ````
  DataModel call({
    Object? isRef = const $CopyWithPlaceholder(),
    Object? flag = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
    Object? msg = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? size = const $CopyWithPlaceholder(),
    Object? hasNext = const $CopyWithPlaceholder(),
    Object? object = const $CopyWithPlaceholder(),
  }) {
    return DataModel(
      isRef: isRef == const $CopyWithPlaceholder()
          ? _value.isRef
          // ignore: cast_nullable_to_non_nullable
          : isRef as bool?,
      flag: flag == const $CopyWithPlaceholder()
          ? _value.flag
          // ignore: cast_nullable_to_non_nullable
          : flag as int,
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as List<dynamic>,
      msg: msg == const $CopyWithPlaceholder()
          ? _value.msg
          // ignore: cast_nullable_to_non_nullable
          : msg as String?,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as int,
      size: size == const $CopyWithPlaceholder()
          ? _value.size
          // ignore: cast_nullable_to_non_nullable
          : size as int,
      hasNext: hasNext == const $CopyWithPlaceholder()
          ? _value.hasNext
          // ignore: cast_nullable_to_non_nullable
          : hasNext as bool,
      object: object == const $CopyWithPlaceholder()
          ? _value.object
          // ignore: cast_nullable_to_non_nullable
          : object as dynamic,
    );
  }
}

extension $DataModelCopyWith on DataModel {
  /// Returns a callable class that can be used as follows: `instanceOfDataModel.copyWith(...)` or like so:`instanceOfDataModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DataModelCWProxy get copyWith => _$DataModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataModel _$DataModelFromJson(Map<String, dynamic> json) => DataModel(
      isRef: json['isRef'] as bool?,
      flag: (json['flag'] as num?)?.toInt() ?? 0,
      value: json['value'] as List<dynamic>? ?? const <dynamic>[0],
      msg: json['msg'] as String?,
      page: (json['page'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toInt() ?? 20,
      hasNext: json['hasNext'] as bool? ?? true,
      object: json['object'],
    )..list = json['list'] as List<dynamic>;

Map<String, dynamic> _$DataModelToJson(DataModel instance) => <String, dynamic>{
      'flag': instance.flag,
      'msg': instance.msg,
      'page': instance.page,
      'size': instance.size,
      'hasNext': instance.hasNext,
      'value': instance.value,
      'list': instance.list,
      'object': instance.object,
      'isRef': instance.isRef,
    };
