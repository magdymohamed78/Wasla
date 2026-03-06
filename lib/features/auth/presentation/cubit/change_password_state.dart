enum ChangePasswordStatus { initial, loading, success, failure }

enum ChangePasswordErrorType {
  otpInvalid,    // wrong code or regular expired OTP
  otpExpired,    // permanently invalidated after 5 failed attempts
  passwordPolicy,
  rateLimit,
  network,
  server,
}

class ChangePasswordState {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final String? newPasswordError;
  final String? confirmPasswordError;
  final ChangePasswordStatus status;
  /// Localization key for client-side / network errors (e.g. 'network', 'rateLimit', 'otpInvalid').
  final String? errorMessage;
  /// Raw human-readable message returned by the server (ProblemDetails.detail / title).
  /// When set, the UI should display this text directly instead of a localized fallback.
  final String? serverMessage;
  final ChangePasswordErrorType? errorType;
  final bool hasSubmitted;

  const ChangePasswordState({
    this.email = '',
    this.otp = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.obscureNewPassword = true,
    this.obscureConfirmPassword = true,
    this.newPasswordError,
    this.confirmPasswordError,
    this.status = ChangePasswordStatus.initial,
    this.errorMessage,
    this.serverMessage,
    this.errorType,
    this.hasSubmitted = false,
  });

  bool get isValid =>
      otp.length == 6 &&
      newPassword.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      newPasswordError == null &&
      confirmPasswordError == null;

  ChangePasswordState copyWith({
    String? email,
    String? otp,
    String? newPassword,
    String? confirmPassword,
    bool? obscureNewPassword,
    bool? obscureConfirmPassword,
    String? newPasswordError,
    String? confirmPasswordError,
    ChangePasswordStatus? status,
    String? errorMessage,
    String? serverMessage,
    ChangePasswordErrorType? errorType,
    bool? hasSubmitted,
  }) {
    return ChangePasswordState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscureNewPassword: obscureNewPassword ?? this.obscureNewPassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      newPasswordError: newPasswordError,
      confirmPasswordError: confirmPasswordError,
      status: status ?? this.status,
      errorMessage: errorMessage,
      serverMessage: serverMessage,
      errorType: errorType,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }
}
