enum ForgotPasswordStatus { initial, loading, success, failure }

class ForgotPasswordState {
  final String email;
  final String? emailError;
  final bool isSubmitting;
  final ForgotPasswordStatus status;
  final String? errorMessage;

  const ForgotPasswordState({
    this.email = '',
    this.emailError,
    this.isSubmitting = false,
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
  });

  bool get isValid => email.isNotEmpty && emailError == null;

  ForgotPasswordState copyWith({
    String? email,
    String? emailError,
    bool? isSubmitting,
    ForgotPasswordStatus? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailError: emailError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
