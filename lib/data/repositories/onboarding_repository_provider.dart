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
    return OnboardingState();
  }

  Future<void> selectPurpose(String purpose) async {
    state = state.copyWith(selectedPurpose: purpose);
    await ref.read(onboardingRepositoryProvider).saveUserPurpose(purpose);
    ref.invalidate(savedUserPurposeProvider);
  }
}

@riverpod
Future<String?> savedUserPurpose(Ref ref) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  return repository.getUserPurpose(); // SharedPreferences에서 읽어옴
}
// @riverpod
// String? savedUserPurpose(Ref ref) {
//   final repository = ref.watch(onboardingRepositoryProvider);
//   return repository.getUserPurpose();
// }