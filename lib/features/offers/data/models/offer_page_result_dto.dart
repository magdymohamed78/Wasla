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
    final domainItems = items
        .map((dto) {
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
        })
        .toList(growable: false);

    return OfferPageResult(
      items: domainItems,
      pageIndex: pageIndex,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
      statusCounts: _buildStatusCounts(
        rawStatusCounts,
        domainItems,
        totalCount,
      ),
    );
  }

  static OfferFilter _normalizeStatus(String? rawStatus) {
    return OfferFilter.fromQueryValue(rawStatus);
  }

  static OfferStatusCounts _buildStatusCounts(
    Map<String, int> rawCounts,
    List<OfferSummaryItem> items,
    int totalCount,
  ) {
    final derived = _deriveCountsFromItems(items);

    if (rawCounts.isNotEmpty) {
      final pending =
          _resolveCount(rawCounts, const ['pending', 'sent', 'offersent']) ??
          derived.pending;
      final accepted =
          _resolveCount(rawCounts, const ['accepted']) ?? derived.accepted;
      final rejected =
          _resolveCount(rawCounts, const ['rejected', 'declined']) ??
          derived.rejected;
      final canceled =
          _resolveCount(rawCounts, const ['canceled', 'expired']) ??
          derived.canceled;

      final countsSum = pending + accepted + rejected + canceled;
      final all =
          _resolveCount(rawCounts, const [
            'all',
            'total',
            'totalcount',
            'totaloffers',
            'offerscount',
            'offercount',
          ]) ??
          (totalCount > 0 ? totalCount : countsSum);

      return OfferStatusCounts(
        all: all < 0 ? 0 : all,
        pending: pending < 0 ? 0 : pending,
        accepted: accepted < 0 ? 0 : accepted,
        rejected: rejected < 0 ? 0 : rejected,
        canceled: canceled < 0 ? 0 : canceled,
      );
    }

    if (totalCount > 0) {
      return OfferStatusCounts(
        all: totalCount,
        pending: derived.pending,
        accepted: derived.accepted,
        rejected: derived.rejected,
        canceled: derived.canceled,
      );
    }

    return derived;
  }

  static OfferStatusCounts _deriveCountsFromItems(
    List<OfferSummaryItem> items,
  ) {
    int pending = 0, accepted = 0, rejected = 0, canceled = 0;
    for (final item in items) {
      switch (item.normalizedFilter) {
        case OfferFilter.pending:
          pending++;
        case OfferFilter.accepted:
          accepted++;
        case OfferFilter.rejected:
          rejected++;
        case OfferFilter.canceled:
          canceled++;
        case OfferFilter.all:
          break;
      }
    }

    return OfferStatusCounts(
      all: items.length,
      pending: pending,
      accepted: accepted,
      rejected: rejected,
      canceled: canceled,
    );
  }

  static int? _resolveCount(Map<String, int> rawCounts, List<String> aliases) {
    for (final entry in rawCounts.entries) {
      final normalizedKey = _normalizeCountKey(entry.key);
      if (aliases.contains(normalizedKey)) {
        return entry.value;
      }
    }

    return null;
  }

  static String _normalizeCountKey(String key) {
    return key.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  static Map<String, int> _parseStatusCounts(dynamic raw) {
    if (raw is! Map) return const {};
    return raw.map((key, value) => MapEntry(key.toString(), asInt(value)));
  }
}
