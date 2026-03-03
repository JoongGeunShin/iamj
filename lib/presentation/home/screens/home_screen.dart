import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iamj/data/repositories/onboarding_repository_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 다시 AsyncValue 형태로 구독합니다.
    final purposeAsync = ref.watch(savedUserPurposeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        // 2. 비동기 상태에 따라 UI 분기 (타이밍 이슈 해결)
        child: purposeAsync.when(
          data: (purpose) => Text(
            purpose != null
                ? '당신의 목표는: ${purpose.toUpperCase()}입니다!'
                : '설정된 목표가 없습니다.',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          loading: () => const CircularProgressIndicator(), // 데이터 읽는 동안 뱅글뱅글
          error: (err, stack) => Text('오류 발생: $err'),
        ),
      ),
    );
  }
}