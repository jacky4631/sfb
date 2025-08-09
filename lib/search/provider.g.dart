// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goodsSearchHash() => r'8e5c8a785012fc286c1c3fc876f4294b592d6973';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [goodsSearch].
@ProviderFor(goodsSearch)
const goodsSearchProvider = GoodsSearchFamily();

/// See also [goodsSearch].
class GoodsSearchFamily extends Family<AsyncValue<DataModel>> {
  /// See also [goodsSearch].
  const GoodsSearchFamily();

  /// See also [goodsSearch].
  GoodsSearchProvider call({
    required String keyword,
    int sort = 0,
  }) {
    return GoodsSearchProvider(
      keyword: keyword,
      sort: sort,
    );
  }

  @override
  GoodsSearchProvider getProviderOverride(
    covariant GoodsSearchProvider provider,
  ) {
    return call(
      keyword: provider.keyword,
      sort: provider.sort,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'goodsSearchProvider';
}

/// See also [goodsSearch].
class GoodsSearchProvider extends AutoDisposeFutureProvider<DataModel> {
  /// See also [goodsSearch].
  GoodsSearchProvider({
    required String keyword,
    int sort = 0,
  }) : this._internal(
          (ref) => goodsSearch(
            ref as GoodsSearchRef,
            keyword: keyword,
            sort: sort,
          ),
          from: goodsSearchProvider,
          name: r'goodsSearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$goodsSearchHash,
          dependencies: GoodsSearchFamily._dependencies,
          allTransitiveDependencies:
              GoodsSearchFamily._allTransitiveDependencies,
          keyword: keyword,
          sort: sort,
        );

  GoodsSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.keyword,
    required this.sort,
  }) : super.internal();

  final String keyword;
  final int sort;

  @override
  Override overrideWith(
    FutureOr<DataModel> Function(GoodsSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GoodsSearchProvider._internal(
        (ref) => create(ref as GoodsSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        keyword: keyword,
        sort: sort,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DataModel> createElement() {
    return _GoodsSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GoodsSearchProvider &&
        other.keyword == keyword &&
        other.sort == sort;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, keyword.hashCode);
    hash = _SystemHash.combine(hash, sort.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GoodsSearchRef on AutoDisposeFutureProviderRef<DataModel> {
  /// The parameter `keyword` of this provider.
  String get keyword;

  /// The parameter `sort` of this provider.
  int get sort;
}

class _GoodsSearchProviderElement
    extends AutoDisposeFutureProviderElement<DataModel> with GoodsSearchRef {
  _GoodsSearchProviderElement(super.provider);

  @override
  String get keyword => (origin as GoodsSearchProvider).keyword;
  @override
  int get sort => (origin as GoodsSearchProvider).sort;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
