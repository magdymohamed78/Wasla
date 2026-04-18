import '../entities/customer_service_request_summary.dart';
import '../../../requests/domain/entities/service_request_details.dart';
import '../../../requests/domain/entities/request_filter.dart';
import '../../../requests/domain/entities/request_page_result.dart';

abstract class CustomerRequestsRepository {
  Future<List<CustomerServiceRequestSummary>> getCustomerServiceRequests({
    int pageIndex,
    int pageSize,
    String? status,
  });

  Future<RequestPageResult> getCustomerServiceRequestsPaged({
    required int pageIndex,
    required int pageSize,
    RequestFilter? filter,
  });

  Future<ServiceRequestDetails> getCustomerServiceRequestDetails({
    required int serviceRequestId,
  });
}
