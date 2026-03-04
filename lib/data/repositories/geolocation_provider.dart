import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iamj/service/kma_grid_converter.dart';

part 'geolocation_provider.g.dart';

@riverpod
Future<Position> currentPosition(Ref ref) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('위치 서비스가 비활성화되어 있습니다.');
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    throw Exception('위치 권한이 거부되었습니다.');
  }
  if (permission == LocationPermission.deniedForever) {
    throw Exception('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.');
  }

  return Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.low,
  );
}

@riverpod
Future<({int nx, int ny})> currentGrid(Ref ref) async {
  final pos = await ref.watch(currentPositionProvider.future);
  return KmaGridConverter.toGrid(lat: pos.latitude, lon: pos.longitude);
}

