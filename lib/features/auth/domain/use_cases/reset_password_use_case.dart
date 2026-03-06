import '../repositories/auth_repository.dart';

/// Use case for resetting the user's password.
///
/// Encapsulates the business logic for setting a new password
/// using the OTP verification code.
/// Single responsibility: call the repository with email, OTP, and new password.
class ResetPasswordUseCase {
  final AuthRepository _repository;

  const ResetPasswordUseCase(this._repository);

  /// Executes the reset password operation.
  Future<void> call({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return _repository.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }
}
