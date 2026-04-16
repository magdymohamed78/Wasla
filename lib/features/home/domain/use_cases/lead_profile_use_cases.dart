import '../entities/lead_portal_profile.dart';
import '../entities/update_portal_profile_input.dart';
import '../repositories/customer_portal_repository.dart';

class GetLeadProfileUseCase {
  final CustomerPortalRepository _repository;

  const GetLeadProfileUseCase(this._repository);

  Future<LeadPortalProfile> call() {
    return _repository.getLeadProfile();
  }
}

class UpdateLeadProfileUseCase {
  final CustomerPortalRepository _repository;

  const UpdateLeadProfileUseCase(this._repository);

  Future<LeadPortalProfile> call(UpdatePortalProfileInput input) {
    return _repository.updateLeadProfile(input: input);
  }
}
