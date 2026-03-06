import '../repositories/auth_repository.dart';

/// Use case for requesting a forgot password OTP.
///
/// Encapsulates the business logic for initiating a password reset.
/// Single responsibility: call the repository with the user's email.
class ForgotPasswordUseCase {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  /// Executes the forgot password operation, sending an OTP to the email.
  Future<void> call({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}
