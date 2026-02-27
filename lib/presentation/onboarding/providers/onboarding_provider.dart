import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iamj/data/repositories/onboarding_repository_provider.dart';
import '../../../domain/entities/onboarding_state.dart';

part 'onboarding_provider.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingState build() {
    // 1. 초기 실행 여부 확인
    final isFirst = ref.watch(onboardingRepositoryProvider).isFirstLaunch();

    return OnboardingState(
      isFirstLaunch: isFirst,
      currentStep: 0,
      isCompleted: [false, false, false], // 총 3단계 가정
    );
  }

  // 2. 단계 완료 및 다음 단계 이동 로직
  Future<void> completeCurrentStep() async {
    // 현재 단계가 마지막 단계이고 이미 완료되었다면 중단
    if (state.currentStep >= state.isCompleted.length) return;

    // 예: 1단계에서는 목적 저장 로직을 실행하고 싶다면?
    if (state.currentStep == 0) {
      await ref.read(onboardingRepositoryProvider).saveUserPurpose("사용자 선택값");
    }

    // 상태 업데이트 로직
    final newList = List<bool>.from(state.isCompleted);
    newList[state.currentStep] = true;

    int nextStep = state.currentStep;
    if (state.currentStep < state.isCompleted.length - 1) {
      nextStep++;
    }

    state = state.copyWith(
      currentStep: nextStep,
      isCompleted: newList,
      // 모든 단계가 끝나면 isFirstLaunch를 false로 변경
      isFirstLaunch: nextStep == state.isCompleted.length - 1 && newList.last ? false : state.isFirstLaunch,
    );
  }
}