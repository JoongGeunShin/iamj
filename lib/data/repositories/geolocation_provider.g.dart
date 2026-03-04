// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geolocation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentPosition)
const currentPositionProvider = CurrentPositionProvider._();

final class CurrentPositionProvider
    extends
        $FunctionalProvider<AsyncValue<Position>, Position, FutureOr<Position>>
    with $FutureModifier<Position>, $FutureProvider<Position> {
  const CurrentPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPositionHash();

  @$internal
  @override
  $FutureProviderElement<Position> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Position> create(Ref ref) {
    return currentPosition(ref);
  }
}

String _$currentPositionHash() => r'7a77bdf719b3c1cfcba04e46cf3a89b883ea2bca';

@ProviderFor(currentGrid)
const currentGridProvider = CurrentGridProvider._();

final class CurrentGridProvider
    extends
        $FunctionalProvider<
          AsyncValue<({int nx, int ny})>,
          ({int nx, int ny}),
          FutureOr<({int nx, int ny})>
        >
    with
        $FutureModifier<({int nx, int ny})>,
        $FutureProvider<({int nx, int ny})> {
  const CurrentGridProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentGridProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentGridHash();

  @$internal
  @override
  $FutureProviderElement<({int nx, int ny})> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<({int nx, int ny})> create(Ref ref) {
    return currentGrid(ref);
  }
}

String _$currentGridHash() => r'8900952651647e3768ef9496848e9dd922377aeb';
