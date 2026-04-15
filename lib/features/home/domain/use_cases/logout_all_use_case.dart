import '../repositories/customer_portal_repository.dart';

class LogoutAllUseCase {
  final CustomerPortalRepository _repository;

  const LogoutAllUseCase(this._repository);

  Future<void> call() {
    return _repository.logoutAll();
  }
}
