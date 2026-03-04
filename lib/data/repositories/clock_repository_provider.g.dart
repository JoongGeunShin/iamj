// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clockRepository)
const clockRepositoryProvider = ClockRepositoryProvider._();

final class ClockRepositoryProvider
    extends
        $FunctionalProvider<ClockRepository, ClockRepository, ClockRepository>
    with $Provider<ClockRepository> {
  const ClockRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClockRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClockRepository create(Ref ref) {
    return clockRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClockRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClockRepository>(value),
    );
  }
}

String _$clockRepositoryHash() => r'4020bbbf0f4c8f871b5f0ca0710821cba1144483';

@ProviderFor(watchTime)
const watchTimeProvider = WatchTimeProvider._();

final class WatchTimeProvider
    extends
        $FunctionalProvider<AsyncValue<DateTime>, DateTime, Stream<DateTime>>
    with $FutureModifier<DateTime>, $StreamProvider<DateTime> {
  const WatchTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchTimeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchTimeHash();

  @$internal
  @override
  $StreamProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DateTime> create(Ref ref) {
    return watchTime(ref);
  }
}

String _$watchTimeHash() => r'e044260a0a2293dcce3428e13a165aaf21797aee';
