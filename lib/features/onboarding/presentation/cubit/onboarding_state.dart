enum OnboardingNavigation { idle, navigateToLogin, navigateToRegister, navigateToSupport }

class OnboardingState {
  final OnboardingNavigation navigation;

  const OnboardingState({this.navigation = OnboardingNavigation.idle});

  OnboardingState copyWith({OnboardingNavigation? navigation}) {
    return OnboardingState(navigation: navigation ?? this.navigation);
  }
}
