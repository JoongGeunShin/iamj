abstract class OnboardingRepository{
  bool isFirstLaunch();
  Future<void> saveUserPurpose(String purpose);
}