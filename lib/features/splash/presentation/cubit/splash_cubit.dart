import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository _authRepository;
  bool _animationFinished = false;
  bool _authFinished = false;

  SplashCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const SplashState());

  void startAnimation() {
    emit(state.copyWith(phase: SplashAnimationPhase.animating));
  }

  void onAnimationComplete() {
    emit(state.copyWith(phase: SplashAnimationPhase.completed));
    _animationFinished = true;
    _tryNavigate();
  }

  Future<void> checkAuthStatus() async {
    try {
      final rememberMe = await _authRepository.getRememberMeFlag();
      
      if (!rememberMe) {
        emit(state.copyWith(authStatus: SplashAuthStatus.unauthenticated));
        _authFinished = true;
        _tryNavigate();
        return;
      }

      final storedSession = await _authRepository.getStoredSession();
      
      if (storedSession != null && storedSession.token.isNotEmpty) {
        emit(state.copyWith(authStatus: SplashAuthStatus.authenticated));
      } else {
        emit(state.copyWith(authStatus: SplashAuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(authStatus: SplashAuthStatus.unauthenticated));
    }
    
    _authFinished = true;
    _tryNavigate();
  }

  void _tryNavigate() {
    if (_animationFinished && _authFinished) {
      emit(state.copyWith(readyToNavigate: true));
    }
  }
}
