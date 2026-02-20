import '../../domain/entities/login_entity.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final String email;
  final String password;
  final bool obscurePassword;
  final bool rememberMe;
  final LoginStatus status;
  final String? errorMessage;
  final LoginEntity? user;
  final String? emailError;
  final String? passwordError;
  final bool hasSubmitted;

  const LoginState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.rememberMe = false,
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.user,
    this.emailError,
    this.passwordError,
    this.hasSubmitted = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    bool? rememberMe,
    LoginStatus? status,
    String? errorMessage,
    LoginEntity? user,
    String? emailError,
    String? passwordError,
    bool? hasSubmitted,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      emailError: emailError,
      passwordError: passwordError,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }
}
