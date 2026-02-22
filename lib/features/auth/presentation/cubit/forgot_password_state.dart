enum ForgotPasswordStatus { initial, success }

class ForgotPasswordState {
  final String email;
  final String? emailError;
  final bool isSubmitting;
  final ForgotPasswordStatus status;

  const ForgotPasswordState({
    this.email = '',
    this.emailError,
    this.isSubmitting = false,
    this.status = ForgotPasswordStatus.initial,
  });

  bool get isValid => email.isNotEmpty && emailError == null;

  ForgotPasswordState copyWith({
    String? email,
    String? emailError,
    bool? isSubmitting,
    ForgotPasswordStatus? status,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailError: emailError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      status: status ?? this.status,
    );
  }
}
