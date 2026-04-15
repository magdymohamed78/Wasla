import '../repositories/customer_portal_repository.dart';

class LogoutUseCase {
  final CustomerPortalRepository _repository;

  const LogoutUseCase(this._repository);

  Future<void> call() {
    return _repository.logout();
  }
}
