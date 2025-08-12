// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getLunboDataHash() => r'770c682cb1cf70e551a535d7b1bf2010c251312c';

///轮播图
///
/// Copied from [getLunboData].
@ProviderFor(getLunboData)
final getLunboDataProvider = AutoDisposeFutureProvider<DataModel>.internal(
  getLunboData,
  name: r'getLunboDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getLunboDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetLunboDataRef = AutoDisposeFutureProviderRef<DataModel>;
String _$hotWordsCenterHash() => r'fb10d5590b698acb0576e3cf9ee807186b633c49';

///热门关键字
///
/// Copied from [hotWordsCenter].
@ProviderFor(hotWordsCenter)
final hotWordsCenterProvider = AutoDisposeFutureProvider<DataModel>.internal(
  hotWordsCenter,
  name: r'hotWordsCenterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hotWordsCenterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HotWordsCenterRef = AutoDisposeFutureProviderRef<DataModel>;
String _$associationalWordHash() => r'9449fe23872804bf73130bf9ea06308a698b3248';

///联想词
///
/// Copied from [associationalWord].
@ProviderFor(associationalWord)
final associationalWordProvider = AutoDisposeFutureProvider<DataModel>.internal(
  associationalWord,
  name: r'associationalWordProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$associationalWordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssociationalWordRef = AutoDisposeFutureProviderRef<DataModel>;
String _$historiesHash() => r'4fd92b7c174a57c4a45d0ebe403e46fa3f155a9d';

///搜索历史
///
/// Copied from [histories].
@ProviderFor(histories)
final historiesProvider = AutoDisposeFutureProvider<DataModel>.internal(
  histories,
  name: r'historiesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$historiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HistoriesRef = AutoDisposeFutureProviderRef<DataModel>;
String _$clearHistoryHash() => r'61ffc2c59461f13c2e758b75e3a967f2f0d86979';

/// See also [clearHistory].
@ProviderFor(clearHistory)
final clearHistoryProvider = AutoDisposeFutureProvider<DataModel>.internal(
  clearHistory,
  name: r'clearHistoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$clearHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClearHistoryRef = AutoDisposeFutureProviderRef<DataModel>;
String _$searchHash() => r'83e40030e8e3a28d7511f71e1f7878d4a1abfb6c';

/// See also [Search].
@ProviderFor(Search)
final searchProvider =
    AutoDisposeNotifierProvider<Search, SearchParam>.internal(
  Search.new,
  name: r'searchProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Search = AutoDisposeNotifier<SearchParam>;
String _$sortHash() => r'2329aac40624b15fd52276e3acfabb1a7f4e80a8';

/// See also [Sort].
@ProviderFor(Sort)
final sortProvider = AutoDisposeNotifierProvider<Sort, int>.internal(
  Sort.new,
  name: r'sortProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sortHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Sort = AutoDisposeNotifier<int>;
String _$goodsSearchHash() => r'1100aabb4fde6de42287b2e8559ef474db7f8efa';

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

abstract class _$GoodsSearch extends BuildlessAutoDisposeAsyncNotifier<List> {
  late final int tabIndex;

  FutureOr<List> build({
    int tabIndex = 0,
  });
}

/// See also [GoodsSearch].
@ProviderFor(GoodsSearch)
const goodsSearchProvider = GoodsSearchFamily();

/// See also [GoodsSearch].
class GoodsSearchFamily extends Family<AsyncValue<List>> {
  /// See also [GoodsSearch].
  const GoodsSearchFamily();

  /// See also [GoodsSearch].
  GoodsSearchProvider call({
    int tabIndex = 0,
  }) {
    return GoodsSearchProvider(
      tabIndex: tabIndex,
    );
  }

  @override
  GoodsSearchProvider getProviderOverride(
    covariant GoodsSearchProvider provider,
  ) {
    return call(
      tabIndex: provider.tabIndex,
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

/// See also [GoodsSearch].
class GoodsSearchProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GoodsSearch, List> {
  /// See also [GoodsSearch].
  GoodsSearchProvider({
    int tabIndex = 0,
  }) : this._internal(
          () => GoodsSearch()..tabIndex = tabIndex,
          from: goodsSearchProvider,
          name: r'goodsSearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$goodsSearchHash,
          dependencies: GoodsSearchFamily._dependencies,
          allTransitiveDependencies:
              GoodsSearchFamily._allTransitiveDependencies,
          tabIndex: tabIndex,
        );

  GoodsSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tabIndex,
  }) : super.internal();

  final int tabIndex;

  @override
  FutureOr<List> runNotifierBuild(
    covariant GoodsSearch notifier,
  ) {
    return notifier.build(
      tabIndex: tabIndex,
    );
  }

  @override
  Override overrideWith(GoodsSearch Function() create) {
    return ProviderOverride(
      origin: this,
      override: GoodsSearchProvider._internal(
        () => create()..tabIndex = tabIndex,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tabIndex: tabIndex,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GoodsSearch, List> createElement() {
    return _GoodsSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GoodsSearchProvider && other.tabIndex == tabIndex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tabIndex.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GoodsSearchRef on AutoDisposeAsyncNotifierProviderRef<List> {
  /// The parameter `tabIndex` of this provider.
  int get tabIndex;
}

class _GoodsSearchProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GoodsSearch, List>
    with GoodsSearchRef {
  _GoodsSearchProviderElement(super.provider);

  @override
  int get tabIndex => (origin as GoodsSearchProvider).tabIndex;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
