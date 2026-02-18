import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void goToLogin() {
    emit(state.copyWith(navigation: OnboardingNavigation.navigateToLogin));
  }

  void goToRegister() {
    emit(state.copyWith(navigation: OnboardingNavigation.navigateToRegister));
  }

  void goToSupport() {
    emit(state.copyWith(navigation: OnboardingNavigation.navigateToSupport));
  }

  void resetNavigation() {
    emit(state.copyWith(navigation: OnboardingNavigation.idle));
  }
}
