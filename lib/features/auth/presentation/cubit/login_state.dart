import '../../domain/entities/login_entity.dart';

enum LoginStatus { initial, loading, success, failure }

enum LoginErrorCategory { credentials, accountLink, rateLimit, server, network }

enum LoginErrorCode {
  invalidCredentials,
  accountNotSetup,
  rateLimit,
  networkError,
  serverError,
  sessionExpired,
  unexpectedError,
}

class LoginState {
  final String email;
  final String password;
  final bool obscurePassword;
  final bool rememberMe;
  final LoginStatus status;
  final LoginErrorCode? errorCode;
  final LoginEntity? user;
  final String? emailError;
  final String? passwordError;
  final bool hasSubmitted;
  final LoginErrorCategory? errorCategory;
  final bool isRateLimited;
  final int rateLimitRemainingSeconds;

  const LoginState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.rememberMe = false,
    this.status = LoginStatus.initial,
    this.errorCode,
    this.user,
    this.emailError,
    this.passwordError,
    this.hasSubmitted = false,
    this.errorCategory,
    this.isRateLimited = false,
    this.rateLimitRemainingSeconds = 0,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    bool? rememberMe,
    LoginStatus? status,
    LoginErrorCode? errorCode,
    LoginEntity? user,
    String? emailError,
    String? passwordError,
    bool? hasSubmitted,
    LoginErrorCategory? errorCategory,
    bool? isRateLimited,
    int? rateLimitRemainingSeconds,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      status: status ?? this.status,
      errorCode: errorCode,
      user: user ?? this.user,
      emailError: emailError,
      passwordError: passwordError,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      errorCategory: errorCategory ?? this.errorCategory,
      isRateLimited: isRateLimited ?? this.isRateLimited,
      rateLimitRemainingSeconds: rateLimitRemainingSeconds ?? this.rateLimitRemainingSeconds,
    );
  }
}
