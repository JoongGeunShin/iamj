class WeatherState {
  final double temperature;
  final String rainType;
  final double humidity; //습도
  final double windSpeed;
  final DateTime lastUpdated;

  WeatherState({
    required this.temperature,
    required this.rainType,
    required this.humidity,
    required this.windSpeed,
    required this.lastUpdated
  });

  factory WeatherState.empty() => WeatherState(
    temperature: 0,
    rainType: '0',
    humidity: 0,
    windSpeed: 0,
    lastUpdated: DateTime.now(),
  );
}
enum WeatherType { clear, rainy, snowy, cloudy }

extension WeatherStateX on WeatherState {
  WeatherType get type {
    switch (rainType) {
      case '3':
        return WeatherType.snowy;
      case '1':
      case '2':
      case '4':
        return WeatherType.rainy;
      case '0':
      default:
        return humidity >= 80 ? WeatherType.cloudy : WeatherType.clear;
    }
  }
}