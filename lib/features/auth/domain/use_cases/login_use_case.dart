import '../entities/login_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for customer login.
///
/// Encapsulates the business logic for authentication.
/// Single responsibility: call the repository with login credentials.
class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  /// Executes the login operation with the provided credentials.
  Future<LoginEntity> call({
    required String email,
    required String password,
    required bool rememberMe,
  }) {
    return _repository.login(email: email, password: password, rememberMe: rememberMe);
  }
}
