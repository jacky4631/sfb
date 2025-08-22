// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vipListHash() => r'2012ae0f37e632621c31f523a8cf705e8f00b96c';

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

abstract class _$VipList extends BuildlessAutoDisposeAsyncNotifier<List> {
  late final String keyword;

  FutureOr<List> build({
    String keyword = '',
  });
}

/// See also [VipList].
@ProviderFor(VipList)
const vipListProvider = VipListFamily();

/// See also [VipList].
class VipListFamily extends Family<AsyncValue<List>> {
  /// See also [VipList].
  const VipListFamily();

  /// See also [VipList].
  VipListProvider call({
    String keyword = '',
  }) {
    return VipListProvider(
      keyword: keyword,
    );
  }

  @override
  VipListProvider getProviderOverride(
    covariant VipListProvider provider,
  ) {
    return call(
      keyword: provider.keyword,
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
  String? get name => r'vipListProvider';
}

/// See also [VipList].
class VipListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VipList, List> {
  /// See also [VipList].
  VipListProvider({
    String keyword = '',
  }) : this._internal(
          () => VipList()..keyword = keyword,
          from: vipListProvider,
          name: r'vipListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vipListHash,
          dependencies: VipListFamily._dependencies,
          allTransitiveDependencies: VipListFamily._allTransitiveDependencies,
          keyword: keyword,
        );

  VipListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.keyword,
  }) : super.internal();

  final String keyword;

  @override
  FutureOr<List> runNotifierBuild(
    covariant VipList notifier,
  ) {
    return notifier.build(
      keyword: keyword,
    );
  }

  @override
  Override overrideWith(VipList Function() create) {
    return ProviderOverride(
      origin: this,
      override: VipListProvider._internal(
        () => create()..keyword = keyword,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        keyword: keyword,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VipList, List> createElement() {
    return _VipListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VipListProvider && other.keyword == keyword;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, keyword.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VipListRef on AutoDisposeAsyncNotifierProviderRef<List> {
  /// The parameter `keyword` of this provider.
  String get keyword;
}

class _VipListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VipList, List>
    with VipListRef {
  _VipListProviderElement(super.provider);

  @override
  String get keyword => (origin as VipListProvider).keyword;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
