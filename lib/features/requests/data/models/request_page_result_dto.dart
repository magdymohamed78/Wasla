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
    if (raw is! Map<String, dynamic>) {
      return const {};
    }

    final result = <RequestFilter, int>{};
    for (final entry in raw.entries) {
      final key = entry.key;
      final value = asInt(entry.value);
      if (key.toLowerCase() == 'all') {
        result[RequestFilter.all] = value;
      } else {
        for (final filter in RequestFilter.values) {
          if (filter != RequestFilter.all &&
              filter.name.toLowerCase() == key.toLowerCase()) {
            result[filter] = value;
            break;
          }
        }
      }
    }
    return result;
  }
}
