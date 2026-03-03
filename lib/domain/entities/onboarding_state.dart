class OnboardingState {
  final String? selectedPurpose;
  OnboardingState({this.selectedPurpose});

  bool isSelected(String purpose) => selectedPurpose == purpose;

  OnboardingState copyWith({String? selectedPurpose}) {
    return OnboardingState(
      selectedPurpose: selectedPurpose ?? this.selectedPurpose,
    );
  }
}