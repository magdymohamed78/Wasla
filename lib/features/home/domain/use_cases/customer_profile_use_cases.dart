import '../entities/customer_portal_profile.dart';
import '../entities/update_portal_profile_input.dart';
import '../repositories/customer_portal_repository.dart';

class GetCustomerProfileUseCase {
  final CustomerPortalRepository _repository;

  const GetCustomerProfileUseCase(this._repository);

  Future<CustomerPortalProfile> call() {
    return _repository.getCustomerProfile();
  }
}

class UpdateCustomerProfileUseCase {
  final CustomerPortalRepository _repository;

  const UpdateCustomerProfileUseCase(this._repository);

  Future<CustomerPortalProfile> call(UpdatePortalProfileInput input) {
    return _repository.updateCustomerProfile(input: input);
  }
}
