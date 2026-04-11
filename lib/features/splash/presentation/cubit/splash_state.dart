enum SplashAnimationPhase { initial, animating, completed }

enum SplashAuthStatus { pending, authenticated, unauthenticated }

class SplashState {
  final SplashAnimationPhase phase;
  final SplashAuthStatus authStatus;
  final bool readyToNavigate;

  const SplashState({
    this.phase = SplashAnimationPhase.initial,
    this.authStatus = SplashAuthStatus.pending,
    this.readyToNavigate = false,
  });

  String get destination {
    if (!readyToNavigate) return '';
    return '/home';
  }

  SplashState copyWith({
    SplashAnimationPhase? phase,
    SplashAuthStatus? authStatus,
    bool? readyToNavigate,
  }) {
    return SplashState(
      phase: phase ?? this.phase,
      authStatus: authStatus ?? this.authStatus,
      readyToNavigate: readyToNavigate ?? this.readyToNavigate,
    );
  }
}
