import '../entities/weather_state.dart';

abstract class WeatherRepository {
  Stream<WeatherState> watchWeather({required int nx, required int ny});
}