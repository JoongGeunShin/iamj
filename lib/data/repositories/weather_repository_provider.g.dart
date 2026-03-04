// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dio)
const dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  const DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'088d5c03610503c2407a8d7429b0e9f3ee76406f';

@ProviderFor(weatherRepository)
const weatherRepositoryProvider = WeatherRepositoryProvider._();

final class WeatherRepositoryProvider
    extends
        $FunctionalProvider<
          WeatherRepository,
          WeatherRepository,
          WeatherRepository
        >
    with $Provider<WeatherRepository> {
  const WeatherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeatherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherRepository create(Ref ref) {
    return weatherRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherRepository>(value),
    );
  }
}

String _$weatherRepositoryHash() => r'8a5b0e099ffb75f226880b9cb03b50c1a31a3f60';

@ProviderFor(watchWeather)
const watchWeatherProvider = WatchWeatherFamily._();

final class WatchWeatherProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeatherState>,
          WeatherState,
          Stream<WeatherState>
        >
    with $FutureModifier<WeatherState>, $StreamProvider<WeatherState> {
  const WatchWeatherProvider._({
    required WatchWeatherFamily super.from,
    required ({int nx, int ny}) super.argument,
  }) : super(
         retry: null,
         name: r'watchWeatherProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchWeatherHash();

  @override
  String toString() {
    return r'watchWeatherProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<WeatherState> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WeatherState> create(Ref ref) {
    final argument = this.argument as ({int nx, int ny});
    return watchWeather(ref, nx: argument.nx, ny: argument.ny);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchWeatherProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchWeatherHash() => r'8f49623ac8daf0001bfb14827d8a1cfb36d6246e';

final class WatchWeatherFamily extends $Family
    with $FunctionalFamilyOverride<Stream<WeatherState>, ({int nx, int ny})> {
  const WatchWeatherFamily._()
    : super(
        retry: null,
        name: r'watchWeatherProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchWeatherProvider call({required int nx, required int ny}) =>
      WatchWeatherProvider._(argument: (nx: nx, ny: ny), from: this);

  @override
  String toString() => r'watchWeatherProvider';
}
