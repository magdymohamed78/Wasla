import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  bool _animationFinished = false;
  bool _authFinished = false;

  SplashCubit() : super(const SplashState());

  void startAnimation() {
    emit(state.copyWith(phase: SplashAnimationPhase.animating));
  }

  void onAnimationComplete() {
    emit(state.copyWith(phase: SplashAnimationPhase.completed));
    _animationFinished = true;
    _tryNavigate();
  }

  Future<void> checkAuthStatus() async {
    // Discovery-first launch: no onboarding/auth gating on startup.
    emit(state.copyWith(authStatus: SplashAuthStatus.unauthenticated));
    _authFinished = true;
    _tryNavigate();
  }

  void _tryNavigate() {
    if (_animationFinished && _authFinished) {
      emit(state.copyWith(readyToNavigate: true));
    }
  }
}
