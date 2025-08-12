// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_param.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SearchParamCWProxy {
  SearchParam sort(int sort);

  SearchParam sortIndex(int sortIndex);

  SearchParam text(String text);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SearchParam(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SearchParam(...).copyWith(id: 12, name: "My name")
  /// ````
  SearchParam call({
    int sort,
    int sortIndex,
    String text,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSearchParam.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSearchParam.copyWith.fieldName(...)`
class _$SearchParamCWProxyImpl implements _$SearchParamCWProxy {
  const _$SearchParamCWProxyImpl(this._value);

  final SearchParam _value;

  @override
  SearchParam sort(int sort) => this(sort: sort);

  @override
  SearchParam sortIndex(int sortIndex) => this(sortIndex: sortIndex);

  @override
  SearchParam text(String text) => this(text: text);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SearchParam(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SearchParam(...).copyWith(id: 12, name: "My name")
  /// ````
  SearchParam call({
    Object? sort = const $CopyWithPlaceholder(),
    Object? sortIndex = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
  }) {
    return SearchParam(
      sort: sort == const $CopyWithPlaceholder()
          ? _value.sort
          // ignore: cast_nullable_to_non_nullable
          : sort as int,
      sortIndex: sortIndex == const $CopyWithPlaceholder()
          ? _value.sortIndex
          // ignore: cast_nullable_to_non_nullable
          : sortIndex as int,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
    );
  }
}

extension $SearchParamCopyWith on SearchParam {
  /// Returns a callable class that can be used as follows: `instanceOfSearchParam.copyWith(...)` or like so:`instanceOfSearchParam.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SearchParamCWProxy get copyWith => _$SearchParamCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchParam _$SearchParamFromJson(Map<String, dynamic> json) => SearchParam(
      sort: (json['sort'] as num?)?.toInt() ?? 0,
      sortIndex: (json['sortIndex'] as num?)?.toInt() ?? 0,
      text: json['text'] as String? ?? '',
    );

Map<String, dynamic> _$SearchParamToJson(SearchParam instance) =>
    <String, dynamic>{
      'sortIndex': instance.sortIndex,
      'sort': instance.sort,
      'text': instance.text,
    };
