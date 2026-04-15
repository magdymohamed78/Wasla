import '../repositories/customer_portal_repository.dart';

class RevealDigitalSignatureUseCase {
  final CustomerPortalRepository _repository;

  const RevealDigitalSignatureUseCase(this._repository);

  Future<String> call({required String password}) {
    return _repository.revealDigitalSignature(password: password);
  }
}
