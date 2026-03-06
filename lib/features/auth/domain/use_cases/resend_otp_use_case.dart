import '../repositories/auth_repository.dart';

/// Use case for resending an OTP during the forgot password flow.
///
/// Encapsulates the business logic for requesting a new OTP.
/// Single responsibility: call the repository with the user's email.
class ResendOtpUseCase {
  final AuthRepository _repository;

  const ResendOtpUseCase(this._repository);

  /// Executes the resend OTP operation.
  Future<void> call({required String email}) {
    return _repository.resendOtp(email: email);
  }
}
