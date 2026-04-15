class ChangePasswordState {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final String? currentPasswordError;
  final String? newPasswordError;
  final String? confirmPasswordError;
  final String? generalError;
  final bool isSubmitting;
  final bool isSuccess;
  final bool hasSubmitted;
  final bool currentPasswordTouched;
  final bool newPasswordTouched;
  final bool confirmPasswordTouched;

  const ChangePasswordState({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.currentPasswordError,
    this.newPasswordError,
    this.confirmPasswordError,
    this.generalError,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.hasSubmitted = false,
    this.currentPasswordTouched = false,
    this.newPasswordTouched = false,
    this.confirmPasswordTouched = false,
  });

  ChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    String? currentPasswordError,
    bool clearCurrentPasswordError = false,
    String? newPasswordError,
    bool clearNewPasswordError = false,
    String? confirmPasswordError,
    bool clearConfirmPasswordError = false,
    String? generalError,
    bool clearGeneralError = false,
    bool? isSubmitting,
    bool? isSuccess,
    bool? hasSubmitted,
    bool? currentPasswordTouched,
    bool? newPasswordTouched,
    bool? confirmPasswordTouched,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      currentPasswordError: clearCurrentPasswordError
          ? null
          : (currentPasswordError ?? this.currentPasswordError),
      newPasswordError: clearNewPasswordError
          ? null
          : (newPasswordError ?? this.newPasswordError),
      confirmPasswordError: clearConfirmPasswordError
          ? null
          : (confirmPasswordError ?? this.confirmPasswordError),
      generalError: clearGeneralError
          ? null
          : (generalError ?? this.generalError),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      currentPasswordTouched:
          currentPasswordTouched ?? this.currentPasswordTouched,
      newPasswordTouched: newPasswordTouched ?? this.newPasswordTouched,
      confirmPasswordTouched:
          confirmPasswordTouched ?? this.confirmPasswordTouched,
    );
  }
}
