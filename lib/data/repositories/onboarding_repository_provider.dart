import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iamj/domain/repositories/onboarding_repository.dart';

import '../../domain/entities/onboarding_state.dart';

part 'onboarding_repository_provider.g.dart';

@riverpod
OnboardingRepository onboardingRepository(Ref ref) {
  throw UnimplementedError();
}

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingState build() {
    return OnboardingState(isSelected: [false, false, false]);
  }

  Future<void> selectPurpose(int index, String purpose) async {
    final newList = [false, false, false];
    newList[index] = true;

    state = state.copyWith(
      isSelected: newList,
      selectedPurpose: purpose,
    );

    await ref.read(onboardingRepositoryProvider).saveUserPurpose(purpose);
  }
}