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