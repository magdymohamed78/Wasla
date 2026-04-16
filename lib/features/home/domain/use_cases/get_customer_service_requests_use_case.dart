import '../entities/customer_service_request_summary.dart';
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
