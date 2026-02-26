import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iamj/data/repositories/onboarding_repository_provider.dart';

part 'onboarding_provider.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  bool build() {
    // 1. Repository를 통해 첫 진입 여부 확인
    return ref.read(onboardingRepositoryProvider).isFirstLaunch();
  }

  // 2. 사용자가 목적을 선택했을 때 호출할 함수
  Future<void> selectPurpose(String purpose) async {
    await ref.read(onboardingRepositoryProvider).saveUserPurpose(purpose);
    state = false; // 상태를 '첫 진입 아님'으로 변경하여 UI 업데이트
  }
}