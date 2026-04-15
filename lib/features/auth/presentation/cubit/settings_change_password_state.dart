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
    );
  }
}
