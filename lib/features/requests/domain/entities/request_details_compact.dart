import 'request_filter.dart';

class RequestDetailsCompact {
  final int serviceRequestId;
  final String? referenceNumber;
  final int companyId;
  final String? companyName;
  final String? companyLogoUrl;
  final String? serviceType;
  final String? rawStatus;
  final RequestFilter normalizedFilter;
  final DateTime? preferredDate;
  final DateTime? createdAt;

  const RequestDetailsCompact({
    required this.serviceRequestId,
    required this.companyId,
    required this.normalizedFilter,
    this.referenceNumber,
    this.companyName,
    this.companyLogoUrl,
    this.serviceType,
    this.rawStatus,
    this.preferredDate,
    this.createdAt,
  });
}
