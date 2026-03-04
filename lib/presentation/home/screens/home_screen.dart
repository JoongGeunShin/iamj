import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iamj/data/repositories/clock_repository_provider.dart';
import 'package:iamj/data/repositories/onboarding_repository_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _weekdayKo(int weekday) {
    return ['월', '화', '수', '목', '금', '토', '일'][weekday - 1];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 시계와 목적 데이터를 모두 watch합니다.
    final timeAsync = ref.watch(watchTimeProvider);
    final purposeAsync = ref.watch(savedUserPurposeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 2. 시간 표시 섹션
              timeAsync.when(
                data: (now) => _buildTimeCard(context, now),
                loading: () => const SizedBox(height: 100), // 초기 로딩 시 공간 확보
                error: (err, _) => Center(child: Text('시간 로드 오류: $err')),
              ),
              const SizedBox(height: 18),
              // 3. 목적 표시 섹션
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
                      ),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (err, stack) => Text('오류 발생: $err'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context, DateTime now) {
    final timeText =
        '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';
    final dateText =
        '${now.year}.${_twoDigits(now.month)}.${_twoDigits(now.day)} (${_weekdayKo(now.weekday)})';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeText,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dateText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}