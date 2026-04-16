import '../entities/customer_portal_content.dart';
import '../repositories/customer_portal_repository.dart';

class GetCustomerServiceRequestsUseCase {
  final CustomerPortalRepository _repository;

  const GetCustomerServiceRequestsUseCase(this._repository);

  Future<List<CustomerServiceRequestSummary>> call({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) {
    return _repository.getCustomerServiceRequests(
      pageIndex: pageIndex,
      pageSize: pageSize,
      status: status,
    );
  }
}

class GetCustomerOffersUseCase {
  final CustomerPortalRepository _repository;

  const GetCustomerOffersUseCase(this._repository);

  Future<List<CustomerOfferSummary>> call({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) {
    return _repository.getCustomerOffers(
      pageIndex: pageIndex,
      pageSize: pageSize,
      status: status,
    );
  }
}

class GetCustomerProfileUseCase {
  final CustomerPortalRepository _repository;

  const GetCustomerProfileUseCase(this._repository);

  Future<CustomerPortalProfile> call() {
    return _repository.getCustomerProfile();
  }
}

class GetLeadProfileUseCase {
  final CustomerPortalRepository _repository;

  const GetLeadProfileUseCase(this._repository);

  Future<LeadPortalProfile> call() {
    return _repository.getLeadProfile();
  }
}

class UpdateCustomerProfileUseCase {
  final CustomerPortalRepository _repository;

  const UpdateCustomerProfileUseCase(this._repository);

  Future<CustomerPortalProfile> call(UpdatePortalProfileInput input) {
    return _repository.updateCustomerProfile(input: input);
  }
}

class UpdateLeadProfileUseCase {
  final CustomerPortalRepository _repository;

  const UpdateLeadProfileUseCase(this._repository);

  Future<LeadPortalProfile> call(UpdatePortalProfileInput input) {
    return _repository.updateLeadProfile(input: input);
  }
}
