abstract class OnboardingRepository {
  Future<void> saveUserPurpose(String purpose);
  String? getUserPurpose();
}