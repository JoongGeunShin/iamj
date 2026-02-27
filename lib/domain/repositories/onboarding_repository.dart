abstract class OnboardingRepository{
  bool isFirstLaunch();
  Future<void> saveUserPurpose(String purpose);

  // Onboarding Process
  Future<void> saveProgress(int step);
  Future<int> getLatestStep();
}