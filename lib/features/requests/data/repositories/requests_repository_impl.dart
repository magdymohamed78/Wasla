import '../../domain/entities/request_filter.dart';
import '../models/service_request_details_dto.dart';
import '../models/request_page_result_dto.dart';

abstract class RequestsRepository {
  Future<RequestPageResultDto> getRequests({
    required int pageIndex,
    required int pageSize,
    RequestFilter? filter,
  });

  Future<ServiceRequestDetailsDto> getRequestDetails({
    required int serviceRequestId,
  });
}
