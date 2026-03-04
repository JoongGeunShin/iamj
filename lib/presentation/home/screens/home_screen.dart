import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iamj/data/repositories/clock_repository_provider.dart';
import 'package:iamj/data/repositories/geolocation_provider.dart';
import 'package:iamj/data/repositories/onboarding_repository_provider.dart';
import 'package:iamj/data/repositories/weather_repository_provider.dart';
import 'package:iamj/domain/entities/weather_state.dart';
import 'package:iamj/presentation/home/widgets/backgrounds/weather_background.dart';
import 'package:iamj/presentation/home/widgets/items/time_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeAsync = ref.watch(watchTimeProvider);
    final purposeAsync = ref.watch(savedUserPurposeProvider);
    final gridAsync = ref.watch(currentGridProvider);

    final weatherAsync = gridAsync.maybeWhen(
      data: (grid) => ref.watch(watchWeatherProvider(nx: grid.nx, ny: grid.ny)),
      orElse: () => const AsyncLoading<WeatherState>(),
    );

    final weatherType = weatherAsync.maybeWhen(
      data: _mapWeatherType,
      orElse: () => WeatherType.clear,
    );

    return Scaffold(
      body: WeatherBackground(
        type: weatherType,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                timeAsync.when(
                  data: (now) => TimeCard(now: now),
                  loading: () => const SizedBox(height: 100),
                  error: (err, _) =>
                      Center(child: Text('시간 로드 오류: $err')),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Center(
                    child: purposeAsync.when(
                      data: (purpose) => Text(
                        purpose != null
                            ? '당신의 목표는: ${purpose.toUpperCase()}입니다!'
                            : '설정된 목표가 없습니다.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) =>
                          Text('오류 발생: $err', style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                if (gridAsync.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '위치/날씨 로드 오류: ${gridAsync.error}',
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

WeatherType _mapWeatherType(WeatherState weather) {
  // PTY(강수형태): 0(없음), 1(비), 2(비/눈), 3(눈), 4(소나기)
  switch (weather.rainType) {
    case '3':
      return WeatherType.snowy;
    case '1':
    case '2':
    case '4':
      return WeatherType.rainy;
    case '0':
    default:
      // SKY 데이터가 없어서, 간단히 습도로 흐림을 추정
      return weather.humidity >= 80 ? WeatherType.cloudy : WeatherType.clear;
  }
}