import '../../../../core/types/load_status.dart';
import '../../domain/entities/request_details_compact.dart';

class RequestDetailsState {
  final int serviceRequestId;
  final LoadStatus status;
  final RequestDetailsCompact? details;
  final String? errorCode;

  static const String notFoundError = 'request_not_found';
  static const String accessDeniedError = 'request_access_denied';
  static const String loadFailedError = 'request_details_load_failed';

  const RequestDetailsState({
    required this.serviceRequestId,
    this.status = LoadStatus.initial,
    this.details,
    this.errorCode,
  });

  RequestDetailsState copyWith({
    LoadStatus? status,
    RequestDetailsCompact? details,
    String? errorCode,
  }) {
    return RequestDetailsState(
      serviceRequestId: serviceRequestId,
      status: status ?? this.status,
      details: details ?? this.details,
      errorCode: errorCode,
    );
  }
}
