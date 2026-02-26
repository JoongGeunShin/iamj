import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iamj/domain/repositories/onboarding_repository.dart';

part 'onboarding_repository_provider.g.dart';

@riverpod
OnboardingRepository onboardingRepository(Ref ref) {
  // 이 부분은 SharedPreferences 인스턴스가 준비되었다는 가정하에 작동합니다.
  throw UnimplementedError();
}