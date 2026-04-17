import '../entities/customer_service_request_summary.dart';
import '../repositories/customer_portal_repository.dart';
import '../../../requests/domain/entities/request_filter.dart';
import '../../../requests/domain/entities/request_page_result.dart';

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

  Future<RequestPageResult> getPaged({
    required int pageIndex,
    required int pageSize,
    RequestFilter? filter,
  }) {
    return _repository.getCustomerServiceRequestsPaged(
      pageIndex: pageIndex,
      pageSize: pageSize,
      filter: filter,
    );
  }
}
