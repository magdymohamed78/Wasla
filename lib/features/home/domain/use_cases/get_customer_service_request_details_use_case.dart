import '../repositories/customer_portal_repository.dart';
import '../../../requests/domain/entities/request_details_compact.dart';

class GetCustomerServiceRequestDetailsUseCase {
  final CustomerPortalRepository _repository;

  const GetCustomerServiceRequestDetailsUseCase(this._repository);

  Future<RequestDetailsCompact> call({required int serviceRequestId}) {
    return _repository.getCustomerServiceRequestDetails(
      serviceRequestId: serviceRequestId,
    );
  }
}
