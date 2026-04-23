import '../../domain/entities/request_filter.dart';
import '../../../home/data/models/json_helpers.dart';
import 'service_request_details_dto.dart';

class RequestPageResultDto {
  final List<ServiceRequestDetailsDto> items;
  final int pageIndex;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final Map<RequestFilter, int> statusCounts;

  const RequestPageResultDto({
    required this.items,
    required this.pageIndex,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.statusCounts,
  });

  factory RequestPageResultDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final itemList = rawItems is List
        ? rawItems.whereType<Map<String, dynamic>>().toList(growable: false)
        : const <Map<String, dynamic>>[];

    return RequestPageResultDto(
      items: itemList
          .map(ServiceRequestDetailsDto.fromJson)
          .toList(growable: false),
      pageIndex: asInt(json['pageIndex']),
      pageSize: asInt(json['pageSize']),
      totalCount: asInt(json['totalCount']),
      totalPages: asInt(json['totalPages']),
      statusCounts: _parseStatusCounts(json['statusCounts']),
    );
  }

  bool get hasReachedEnd => pageIndex >= totalPages || items.isEmpty;

  static Map<RequestFilter, int> _parseStatusCounts(dynamic raw) {
    if (raw is! Map) {
      return const {};
    }

    final result = <RequestFilter, int>{};
    for (final entry in raw.entries) {
      final normalizedKey = _normalizeCountKey(entry.key.toString());
      final value = asInt(entry.value);

      final filter = _mapCountKeyToFilter(normalizedKey);
      if (filter == null) {
        continue;
      }

      if (filter == RequestFilter.all) {
        result[filter] = value;
      } else {
        result[filter] = (result[filter] ?? 0) + value;
      }
    }

    return result;
  }

  static RequestFilter? _mapCountKeyToFilter(String normalizedKey) {
    switch (normalizedKey) {
      case 'all':
      case 'total':
      case 'totalcount':
      case 'requestcount':
      case 'requestscount':
        return RequestFilter.all;
      case 'pending':
      case 'new':
      case 'submitted':
        return RequestFilter.pending;
      case 'offersent':
        return RequestFilter.offerSent;
      case 'declined':
      case 'rejected':
        return RequestFilter.declined;
      case 'expired':
        return RequestFilter.expired;
      default:
        return null;
    }
  }

  static String _normalizeCountKey(String key) {
    return key.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}
