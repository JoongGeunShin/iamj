// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lock_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lockRepository)
const lockRepositoryProvider = LockRepositoryProvider._();

final class LockRepositoryProvider
    extends $FunctionalProvider<LockRepository, LockRepository, LockRepository>
    with $Provider<LockRepository> {
  const LockRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lockRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lockRepositoryHash();

  @$internal
  @override
  $ProviderElement<LockRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LockRepository create(Ref ref) {
    return lockRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LockRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LockRepository>(value),
    );
  }
}

String _$lockRepositoryHash() => r'6908d2faddf401e12b4ebaee8d5f19b2cee4fc9f';

@ProviderFor(lockUseCase)
const lockUseCaseProvider = LockUseCaseProvider._();

final class LockUseCaseProvider
    extends $FunctionalProvider<LockUseCase, LockUseCase, LockUseCase>
    with $Provider<LockUseCase> {
  const LockUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lockUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lockUseCaseHash();

  @$internal
  @override
  $ProviderElement<LockUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LockUseCase create(Ref ref) {
    return lockUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LockUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LockUseCase>(value),
    );
  }
}

String _$lockUseCaseHash() => r'f7546e810bc36b558fcf53c9a4cd1701ca670e5e';

@ProviderFor(LockStateNotifier)
const lockStateProvider = LockStateNotifierProvider._();

final class LockStateNotifierProvider
    extends $NotifierProvider<LockStateNotifier, LockState> {
  const LockStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lockStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lockStateNotifierHash();

  @$internal
  @override
  LockStateNotifier create() => LockStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LockState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LockState>(value),
    );
  }
}

String _$lockStateNotifierHash() => r'1e5646396d66455ec576fe009fb9a552fc8c9148';

abstract class _$LockStateNotifier extends $Notifier<LockState> {
  LockState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LockState, LockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LockState, LockState>,
              LockState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
