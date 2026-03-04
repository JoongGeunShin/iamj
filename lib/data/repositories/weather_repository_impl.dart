import 'package:dio/dio.dart';
import 'package:iamj/domain/entities/weather_state.dart';
import 'package:iamj/domain/repositories/weather_repository.dart';
import 'package:iamj/service/api_keys.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final Dio _dio;
  final String _URL = WeatherAPI.BASEURL + WeatherAPI.ENDPOINT;
  final String _serviceKey = WeatherAPI.APIKEY;

  WeatherRepositoryImpl(this._dio);

  @override
  Stream<WeatherState> watchWeather({required int nx, required int ny}) async* {
    yield await _fetchWeather(nx, ny);

    yield* Stream.periodic(const Duration(minutes: 30), (_) => _fetchWeather(nx, ny))
        .asyncMap((event) async => await event);
  }

  Future<WeatherState> _fetchWeather(int nx, int ny) async {
    final now = DateTime.now();
    final baseDateTime = now.minute < 40 ? now.subtract(const Duration(hours: 1)) : now;
    final baseDate = "${baseDateTime.year}${baseDateTime.month.toString().padLeft(2, '0')}${baseDateTime.day.toString().padLeft(2, '0')}";
    final baseTime = "${baseDateTime.hour.toString().padLeft(2, '0')}00";

    try {
      final response = await _dio.get(
        _URL,
        queryParameters: {
          'serviceKey': _serviceKey,
          'pageNo': '1',
          'numOfRows': '10',
          'dataType': 'JSON',
          'base_date': baseDate,
          'base_time': baseTime,
          'nx': nx,
          'ny': ny,
        },
      );

      final List items = response.data['response']['body']['items']['item'];

      return WeatherState(
        temperature: double.parse(items.firstWhere((i) => i['category'] == 'T1H')['obsrValue']),
        rainType: items.firstWhere((i) => i['category'] == 'PTY')['obsrValue'],
        humidity: double.parse(items.firstWhere((i) => i['category'] == 'REH')['obsrValue']),
        windSpeed: double.parse(items.firstWhere((i) => i['category'] == 'WSD')['obsrValue']),
        lastUpdated: now,
      );
    } catch (e) {
      return WeatherState.empty();
    }
  }
}