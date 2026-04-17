import 'request_filter.dart';
import 'request_status_counts.dart';

class RequestSummaryItem {
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
  final bool hasOffer;
  final int? offerId;

  const RequestSummaryItem({
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
    this.hasOffer = false,
    this.offerId,
  });
}

class RequestPageResult {
  final List<RequestSummaryItem> items;
  final int pageIndex;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final RequestStatusCounts statusCounts;

  const RequestPageResult({
    required this.items,
    required this.pageIndex,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.statusCounts,
  });

  bool get hasReachedEnd => pageIndex >= totalPages || items.isEmpty;
}
