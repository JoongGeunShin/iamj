import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iamj/data/repositories/weather_repository_impl.dart';
import 'package:iamj/domain/repositories/weather_repository.dart';
import 'package:iamj/domain/entities/weather_state.dart';

part 'weather_repository_provider.g.dart';


@riverpod
Dio dio(Ref ref) => Dio();

@riverpod
WeatherRepository weatherRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return WeatherRepositoryImpl(dio);
}

@riverpod
Stream<WeatherState> watchWeather(ref, {required int nx, required int ny}) {
  final repository = ref.watch(weatherRepositoryProvider);
  return repository.watchWeather(nx: nx, ny: ny);
}