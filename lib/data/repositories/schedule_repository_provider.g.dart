// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localDatabase)
const localDatabaseProvider = LocalDatabaseProvider._();

final class LocalDatabaseProvider
    extends $FunctionalProvider<LocalDatabase, LocalDatabase, LocalDatabase>
    with $Provider<LocalDatabase> {
  const LocalDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDatabaseHash();

  @$internal
  @override
  $ProviderElement<LocalDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalDatabase create(Ref ref) {
    return localDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDatabase>(value),
    );
  }
}

String _$localDatabaseHash() => r'4f73414b6802d17bd391f7e7b6ab16fcc28fa50e';

@ProviderFor(geminiDataSource)
const geminiDataSourceProvider = GeminiDataSourceProvider._();

final class GeminiDataSourceProvider
    extends
        $FunctionalProvider<
          GeminiDataSource,
          GeminiDataSource,
          GeminiDataSource
        >
    with $Provider<GeminiDataSource> {
  const GeminiDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiDataSourceHash();

  @$internal
  @override
  $ProviderElement<GeminiDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GeminiDataSource create(Ref ref) {
    return geminiDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeminiDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeminiDataSource>(value),
    );
  }
}

String _$geminiDataSourceHash() => r'bf71413ee728b91b7f5fd702489b27f1348a60c6';

@ProviderFor(scheduleRepository)
const scheduleRepositoryProvider = ScheduleRepositoryProvider._();

final class ScheduleRepositoryProvider
    extends
        $FunctionalProvider<
          ScheduleRepository,
          ScheduleRepository,
          ScheduleRepository
        >
    with $Provider<ScheduleRepository> {
  const ScheduleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScheduleRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScheduleRepository create(Ref ref) {
    return scheduleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleRepository>(value),
    );
  }
}

String _$scheduleRepositoryHash() =>
    r'9ad078c6767e6fb555c62bc532f32640ee304dd3';

@ProviderFor(scheduleListStream)
const scheduleListStreamProvider = ScheduleListStreamProvider._();

final class ScheduleListStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ScheduleState>>,
          List<ScheduleState>,
          Stream<List<ScheduleState>>
        >
    with
        $FutureModifier<List<ScheduleState>>,
        $StreamProvider<List<ScheduleState>> {
  const ScheduleListStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleListStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleListStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<ScheduleState>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ScheduleState>> create(Ref ref) {
    return scheduleListStream(ref);
  }
}

String _$scheduleListStreamHash() =>
    r'f9a65ef62b7eb285176744dcf5cc0bff4ad38c1d';

@ProviderFor(ScheduleNotifier)
const scheduleProvider = ScheduleNotifierProvider._();

final class ScheduleNotifierProvider
    extends $NotifierProvider<ScheduleNotifier, void> {
  const ScheduleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleNotifierHash();

  @$internal
  @override
  ScheduleNotifier create() => ScheduleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$scheduleNotifierHash() => r'63322e3eccbf625a9e7ce50f36253a1702b9c406';

abstract class _$ScheduleNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
