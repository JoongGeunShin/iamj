class OnboardingState {
  final bool isFirstLaunch;

  final int currentStep;
  final List<bool> isCompleted;
  final int totalSteps;


  OnboardingState({
    required this.isFirstLaunch,
    required this.currentStep,
    required this.isCompleted,
    this.totalSteps = 3,
  });

  OnboardingState copyWith({
    bool? isFirstLaunch,
    int? currentStep,
    List<bool>? isCompleted,
  }) {
    return OnboardingState(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      currentStep: currentStep ?? this.currentStep,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
