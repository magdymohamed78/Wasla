enum SplashAnimationPhase { initial, animating, completed }

class SplashState {
  final SplashAnimationPhase phase;

  const SplashState({this.phase = SplashAnimationPhase.initial});

  SplashState copyWith({SplashAnimationPhase? phase}) {
    return SplashState(phase: phase ?? this.phase);
  }
}
