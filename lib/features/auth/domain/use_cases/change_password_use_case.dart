import '../../domain/repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository _repository;

  const ChangePasswordUseCase(this._repository);

  Future<void> call({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }
}
