import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final AuthRepository _authRepository;
  Timer? _cooldownTimer;

  LoginCubit({
    required LoginUseCase loginUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _authRepository = authRepository,
        super(const LoginState());

  void emailChanged(String email) {
    emit(state.copyWith(
      email: email,
      emailError: state.hasSubmitted ? _validateEmail(email) : null,
      status: LoginStatus.initial,
      errorCategory: null,
      errorCode: null,
      isRateLimited: false,
      rateLimitRemainingSeconds: 0,
    ));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: password,
      passwordError: state.hasSubmitted ? _validatePassword(password) : null,
      status: LoginStatus.initial,
      errorCategory: null,
      errorCode: null,
      isRateLimited: false,
      rateLimitRemainingSeconds: 0,
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  Future<void> login() async {
    if (state.isRateLimited) return;

    emit(state.copyWith(hasSubmitted: true));

    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);

    if (emailError != null || passwordError != null) {
      emit(state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final normalizedEmail = _normalizeInput(state.email);
      final normalizedPassword = _normalizeInput(state.password);
      
      final user = await _loginUseCase(
        email: normalizedEmail,
        password: normalizedPassword,
        rememberMe: state.rememberMe,
      );
      
      await _authRepository.saveSession(user, rememberMe: state.rememberMe);
      
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } on DioException catch (e) {
      final errorResult = _extractErrorCode(e);
      _logError('DioException during login', e);
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorCode: errorResult.code,
        errorCategory: errorResult.category,
      ));
      if (errorResult.category == LoginErrorCategory.rateLimit) {
        _startRateLimitCooldown();
      }
    } catch (e, stackTrace) {
      _logError('Unexpected error during login', e, stackTrace);
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorCode: LoginErrorCode.unexpectedError,
        errorCategory: LoginErrorCategory.server,
      ));
    }
  }

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final user = await _authRepository.getStoredSession();
      if (user != null) {
        emit(state.copyWith(status: LoginStatus.success, user: user));
      } else {
        emit(state.copyWith(status: LoginStatus.initial));
      }
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.initial));
    }
  }

  Future<void> handleSessionExpiry() async {
    await _authRepository.clearSession();
    emit(state.copyWith(
      status: LoginStatus.failure,
      errorCode: LoginErrorCode.sessionExpired,
    ));
  }

  void resetState() {
    emit(const LoginState());
  }

  String? _validateEmail(String email) {
    return Validators.validateEmail(email);
  }

  String? _validatePassword(String password) {
    return Validators.validatePassword(password);
  }

  String _normalizeInput(String input) {
    String normalized = input.trim();
    
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const westernDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    
    for (int i = 0; i < arabicDigits.length; i++) {
      normalized = normalized.replaceAll(arabicDigits[i], westernDigits[i]);
    }
    
    normalized = normalized.replaceAll('\u200E', '');
    normalized = normalized.replaceAll('\u200F', '');
    normalized = normalized.replaceAll('\u202A', '');
    normalized = normalized.replaceAll('\u202B', '');
    normalized = normalized.replaceAll('\u202C', '');
    normalized = normalized.replaceAll('\u202D', '');
    normalized = normalized.replaceAll('\u202E', '');
    normalized = normalized.replaceAll('\u061C', '');
    
    return normalized;
  }

  void _startRateLimitCooldown() {
    _cooldownTimer?.cancel();
    emit(state.copyWith(
      isRateLimited: true,
      rateLimitRemainingSeconds: 30,
    ));
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.rateLimitRemainingSeconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(
          isRateLimited: false,
          rateLimitRemainingSeconds: 0,
        ));
      } else {
        emit(state.copyWith(rateLimitRemainingSeconds: remaining));
      }
    });
  }

  void _logError(String message, dynamic error, [StackTrace? stackTrace]) {
    debugPrint('════════════════════════════════════════════════════');
    debugPrint('[LoginCubit] ERROR: $message');
    debugPrint('[LoginCubit] Error: $error');
    if (stackTrace != null) {
      debugPrint('[LoginCubit] StackTrace: $stackTrace');
    }
    debugPrint('════════════════════════════════════════════════════');
  }

  ({LoginErrorCode code, LoginErrorCategory category}) _extractErrorCode(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      
      if (statusCode == 200 || statusCode == 201) {
        return (code: LoginErrorCode.serverError, category: LoginErrorCategory.server);
      }
      
      switch (statusCode) {
        case 400:
          return (code: LoginErrorCode.accountNotSetup, category: LoginErrorCategory.accountLink);
        case 401:
          return (code: LoginErrorCode.invalidCredentials, category: LoginErrorCategory.credentials);
        case 403:
          return (code: LoginErrorCode.serverError, category: LoginErrorCategory.server);
        case 404:
          return (code: LoginErrorCode.serverError, category: LoginErrorCategory.server);
        case 429:
          return (code: LoginErrorCode.rateLimit, category: LoginErrorCategory.rateLimit);
        case 500:
        case 502:
        case 503:
          return (code: LoginErrorCode.serverError, category: LoginErrorCategory.server);
        default:
          return (code: LoginErrorCode.unexpectedError, category: LoginErrorCategory.server);
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return (code: LoginErrorCode.networkError, category: LoginErrorCategory.network);
      case DioExceptionType.badResponse:
        return (code: LoginErrorCode.serverError, category: LoginErrorCategory.server);
      case DioExceptionType.cancel:
        return (code: LoginErrorCode.serverError, category: LoginErrorCategory.server);
      case DioExceptionType.unknown:
        final errorStr = e.error?.toString() ?? '';
        if (errorStr.contains('SocketException') || 
            errorStr.contains('Connection refused') ||
            errorStr.contains('Network is unreachable')) {
          return (code: LoginErrorCode.networkError, category: LoginErrorCategory.network);
        }
        return (code: LoginErrorCode.unexpectedError, category: LoginErrorCategory.server);
      default:
        return (code: LoginErrorCode.unexpectedError, category: LoginErrorCategory.server);
    }
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }
}
