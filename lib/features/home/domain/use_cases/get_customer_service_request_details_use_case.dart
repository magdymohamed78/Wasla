import '../repositories/customer_portal_repository.dart';
import '../../../requests/domain/entities/service_request_details.dart';

class GetCustomerServiceRequestDetailsUseCase {
  final CustomerPortalRepository _repository;

  const GetCustomerServiceRequestDetailsUseCase(this._repository);

  Future<ServiceRequestDetails> call({required int serviceRequestId}) {
    return _repository.getCustomerServiceRequestDetails(
      serviceRequestId: serviceRequestId,
    );
  }
}
