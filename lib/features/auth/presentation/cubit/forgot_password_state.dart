enum ForgotPasswordStatus { initial, loading, success, failure }

class ForgotPasswordState {
  final String email;
  final String? emailError;
  final bool isSubmitting;
  final bool emailTouched;
  final ForgotPasswordStatus status;
  final String? errorMessage;
  final int rateLimitSecondsRemaining;

  const ForgotPasswordState({
    this.email = '',
    this.emailError,
    this.isSubmitting = false,
    this.emailTouched = false,
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
    this.rateLimitSecondsRemaining = 0,
  });

  bool get isValid => email.isNotEmpty && emailError == null;

  bool get isRateLimited => rateLimitSecondsRemaining > 0;

  ForgotPasswordState copyWith({
    String? email,
    String? emailError,
    bool? isSubmitting,
    bool? emailTouched,
    ForgotPasswordStatus? status,
    String? errorMessage,
    int? rateLimitSecondsRemaining,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailError: emailError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      emailTouched: emailTouched ?? this.emailTouched,
      status: status ?? this.status,
      errorMessage: errorMessage,
      rateLimitSecondsRemaining:
          rateLimitSecondsRemaining ?? this.rateLimitSecondsRemaining,
    );
  }
}
