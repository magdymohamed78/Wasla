import '../../domain/entities/request_filter.dart';
import '../models/request_details_compact_dto.dart';
import '../models/request_page_result_dto.dart';

abstract class RequestsRepository {
  Future<RequestPageResultDto> getRequests({
    required int pageIndex,
    required int pageSize,
    RequestFilter? filter,
  });

  Future<RequestDetailsCompactDto> getRequestDetails({
    required int serviceRequestId,
  });
}
