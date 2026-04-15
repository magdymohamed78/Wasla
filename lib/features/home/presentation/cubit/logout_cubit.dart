import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_cubit.dart';
import '../../domain/use_cases/logout_all_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase _logoutUseCase;
  final LogoutAllUseCase _logoutAllUseCase;
  final SessionCubit _sessionCubit;

  LogoutCubit({
    required LogoutUseCase logoutUseCase,
    required LogoutAllUseCase logoutAllUseCase,
    required SessionCubit sessionCubit,
  }) : _logoutUseCase = logoutUseCase,
       _logoutAllUseCase = logoutAllUseCase,
       _sessionCubit = sessionCubit,
       super(const LogoutState());

  Future<void> logoutCurrent() async {
    emit(state.copyWith(isLoggingOutCurrent: true, errorMessage: null));

    try {
      await _logoutUseCase();
    } catch (_) {}

    await _sessionCubit.logout();
    emit(state.copyWith(isLoggingOutCurrent: false));
  }

  Future<void> logoutAll() async {
    emit(state.copyWith(isLoggingOutAll: true, errorMessage: null));

    try {
      await _logoutAllUseCase();
    } catch (_) {}

    await _sessionCubit.logout();
    emit(state.copyWith(isLoggingOutAll: false));
  }
}
