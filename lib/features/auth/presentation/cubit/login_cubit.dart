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
    ));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: password,
      passwordError: state.hasSubmitted ? _validatePassword(password) : null,
      status: LoginStatus.initial,
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  Future<void> login() async {
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
      final user = await _loginUseCase(
        email: state.email.trim(),
        password: state.password.trim(),
      );
      if (state.rememberMe) {
        await _authRepository.saveSession(user);
      }
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      _logError('DioException during login', e);
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: errorMessage));
    } catch (e, stackTrace) {
      _logError('Unexpected error during login', e, stackTrace);
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'An unexpected error occurred. Please try again.',
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
      errorMessage: 'session_expired',
    ));
  }

  void resetState() {
    emit(state.copyWith(status: LoginStatus.initial));
  }

  String? _validateEmail(String email) {
    return Validators.validateEmail(email);
  }

  String? _validatePassword(String password) {
    return Validators.validatePassword(password);
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

  String _extractErrorMessage(DioException e) {
    final responseData = e.response?.data;
    String? serverMessage;

    if (responseData is Map<String, dynamic>) {
      serverMessage = responseData['message'] as String? ??
          responseData['error'] as String? ??
          responseData['errorMessage'] as String? ??
          responseData['errors']?.toString();
    } else if (responseData is String && responseData.isNotEmpty) {
      serverMessage = responseData;
    }

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      
      if (statusCode == 200 || statusCode == 201) {
        return 'Success but failed to parse response';
      }
      
      if (statusCode == 400 || statusCode == 401) {
        return serverMessage ?? 'Invalid email or password';
      }
      
      switch (statusCode) {
        case 403:
          return serverMessage ?? 'Access denied';
        case 404:
          return 'Service not found. Please contact support.';
        case 429:
          return 'Too many attempts. Please try again later.';
        case 500:
        case 502:
        case 503:
          return 'Server error. Please try again later.';
        default:
          return serverMessage ?? 'Request failed with status $statusCode';
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.badResponse:
        return serverMessage ?? 'Server returned an error';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.unknown:
        final errorStr = e.error?.toString() ?? '';
        if (errorStr.contains('SocketException') || 
            errorStr.contains('Connection refused') ||
            errorStr.contains('Network is unreachable')) {
          return 'No internet connection. Please check your network.';
        }
        return serverMessage ?? 'An unexpected error occurred';
      default:
        return serverMessage ?? 'An unexpected error occurred';
    }
  }
}
