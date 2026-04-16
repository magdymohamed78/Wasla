import '../entities/customer_service_request_summary.dart';

abstract class CustomerRequestsRepository {
  Future<List<CustomerServiceRequestSummary>> getCustomerServiceRequests({
    int pageIndex,
    int pageSize,
    String? status,
  });
}
