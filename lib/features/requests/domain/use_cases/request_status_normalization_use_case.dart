import '../entities/request_filter.dart';
import '../entities/request_status_counts.dart';

class RequestStatusNormalizationUseCase {
  static const Map<String, RequestFilter> _statusMap = {
    'Pending': RequestFilter.pending,
    'New': RequestFilter.pending,
    'Submitted': RequestFilter.pending,
    'OfferSent': RequestFilter.offerSent,
    'Declined': RequestFilter.declined,
    'Rejected': RequestFilter.declined,
    'Expired': RequestFilter.expired,
  };

  RequestFilter normalize(String? rawStatus) {
    if (rawStatus == null) return RequestFilter.all;
    return _statusMap[rawStatus.trim()] ?? RequestFilter.all;
  }

  bool isKnownStatus(String? rawStatus) {
    if (rawStatus == null) return false;
    return _statusMap.containsKey(rawStatus.trim());
  }

  RequestStatusCounts normalizeStatusCounts(
    Map<String, dynamic>? rawCounts, {
    int fallbackAll = 0,
  }) {
    if (rawCounts == null) {
      return RequestStatusCounts(all: fallbackAll);
    }

    int pending = 0;
    int offerSent = 0;
    int declined = 0;
    int expired = 0;

    for (final entry in rawCounts.entries) {
      final key = entry.key.trim();
      final value = _toInt(entry.value);
      final filter = _statusMap[key];

      if (filter == null) {
        continue;
      }

      switch (filter) {
        case RequestFilter.pending:
          pending += value;
        case RequestFilter.offerSent:
          offerSent += value;
        case RequestFilter.declined:
          declined += value;
        case RequestFilter.expired:
          expired += value;
        case RequestFilter.all:
          break;
      }
    }

    final all = rawCounts['all'] is num
        ? (rawCounts['all'] as num).toInt()
        : pending + offerSent + declined + expired;

    return RequestStatusCounts(
      all: all,
      pending: pending,
      offerSent: offerSent,
      declined: declined,
      expired: expired,
    );
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
