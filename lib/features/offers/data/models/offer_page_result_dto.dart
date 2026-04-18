import '../../../home/data/models/json_helpers.dart';
import '../../../home/data/models/customer_offer_summary_dto.dart';
import '../../domain/entities/offer_filter.dart';
import '../../domain/entities/offer_status_counts.dart';
import '../../domain/entities/offer_summary_item.dart';
import '../../domain/entities/offer_page_result.dart';

class OfferPageResultDto {
  final List<CustomerOfferSummaryDto> items;
  final int pageIndex;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final Map<String, int> rawStatusCounts;

  const OfferPageResultDto({
    required this.items,
    required this.pageIndex,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.rawStatusCounts,
  });

  factory OfferPageResultDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final itemList = rawItems is List
        ? rawItems.whereType<Map<String, dynamic>>().toList(growable: false)
        : const <Map<String, dynamic>>[];

    return OfferPageResultDto(
      items: itemList
          .map(CustomerOfferSummaryDto.fromJson)
          .toList(growable: false),
      pageIndex: asInt(json['pageIndex']),
      pageSize: asInt(json['pageSize']),
      totalCount: asInt(json['totalCount']),
      totalPages: asInt(json['totalPages']),
      rawStatusCounts: _parseStatusCounts(json['statusCounts']),
    );
  }

  OfferPageResult toDomain() {
    final domainItems = items.map((dto) {
      final rawStatus = dto.status;
      final filter = _normalizeStatus(rawStatus);
      return OfferSummaryItem(
        offerId: dto.offerId,
        offerNumber: dto.offerNumber,
        companyId: dto.companyId,
        companyName: dto.companyName,
        companyLogoUrl: dto.companyLogoUrl,
        status: rawStatus,
        normalizedFilter: filter,
        serviceTypeOverall: dto.serviceTypeOverall,
        totalAmount: dto.totalAmount,
        discountAmount: dto.discountAmount,
        issueDate: dto.issueDate,
        acceptDate: dto.acceptDate,
      );
    }).toList(growable: false);

    return OfferPageResult(
      items: domainItems,
      pageIndex: pageIndex,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
      statusCounts: _buildStatusCounts(rawStatusCounts, domainItems),
    );
  }

  static OfferFilter _normalizeStatus(String? rawStatus) {
    return OfferFilter.fromQueryValue(rawStatus);
  }

  static OfferStatusCounts _buildStatusCounts(
    Map<String, int> rawCounts,
    List<OfferSummaryItem> items,
  ) {
    if (rawCounts.isNotEmpty) {
      return OfferStatusCounts(
        all: rawCounts['All'] ?? rawCounts['all'] ?? items.length,
        pending: rawCounts['Pending'] ?? rawCounts['pending'] ?? 0,
        accepted: rawCounts['Accepted'] ?? rawCounts['accepted'] ?? 0,
        rejected: rawCounts['Rejected'] ?? rawCounts['rejected'] ?? 0,
        expired: rawCounts['Expired'] ?? rawCounts['expired'] ?? 0,
      );
    }

    int pending = 0, accepted = 0, rejected = 0, expired = 0;
    for (final item in items) {
      switch (item.normalizedFilter) {
        case OfferFilter.pending:
          pending++;
        case OfferFilter.accepted:
          accepted++;
        case OfferFilter.rejected:
          rejected++;
        case OfferFilter.expired:
          expired++;
        case OfferFilter.all:
          break;
      }
    }

    return OfferStatusCounts(
      all: items.length,
      pending: pending,
      accepted: accepted,
      rejected: rejected,
      expired: expired,
    );
  }

  static Map<String, int> _parseStatusCounts(dynamic raw) {
    if (raw is! Map) return const {};
    return raw.map(
      (key, value) => MapEntry(key.toString(), asInt(value)),
    );
  }
}
