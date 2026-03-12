enum OtpVerificationStatus { initial, success, failure }

class OtpVerificationState {
  final String email;
  final String otp;
  final List<String> otpDigits;
  final OtpVerificationStatus status;
  final int timerRemainingSeconds;
  final bool isResending;
  final String? errorMessage;

  const OtpVerificationState({
    this.email = '',
    this.otp = '',
    this.otpDigits = const ['', '', '', '', '', ''],
    this.status = OtpVerificationStatus.initial,
    this.timerRemainingSeconds = 120,
    this.isResending = false,
    this.errorMessage,
  });

  bool get canResend => timerRemainingSeconds == 0 && !isResending;

  bool get isComplete => otpDigits.every((d) => d.isNotEmpty);

  OtpVerificationState copyWith({
    String? email,
    String? otp,
    List<String>? otpDigits,
    OtpVerificationStatus? status,
    int? timerRemainingSeconds,
    bool? isResending,
    String? errorMessage,
  }) {
    return OtpVerificationState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      otpDigits: otpDigits ?? this.otpDigits,
      status: status ?? this.status,
      timerRemainingSeconds:
          timerRemainingSeconds ?? this.timerRemainingSeconds,
      isResending: isResending ?? this.isResending,
      errorMessage: errorMessage,
    );
  }
}
