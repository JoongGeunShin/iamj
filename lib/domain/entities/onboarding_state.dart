class OnboardingState {
  final List<bool> isSelected;
  final String? selectedPurpose;

  OnboardingState({
    required this.isSelected,
    this.selectedPurpose,
  });

  OnboardingState copyWith({
    List<bool>? isSelected,
    String? selectedPurpose,
  }) {
    return OnboardingState(
      isSelected: isSelected ?? this.isSelected,
      selectedPurpose: selectedPurpose ?? this.selectedPurpose,
    );
  }
}