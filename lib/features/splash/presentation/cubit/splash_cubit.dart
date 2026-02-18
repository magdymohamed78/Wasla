import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  void startAnimation() {
    emit(state.copyWith(phase: SplashAnimationPhase.animating));
  }

  void onAnimationComplete() {
    emit(state.copyWith(phase: SplashAnimationPhase.completed));
  }
}
