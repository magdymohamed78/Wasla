import 'request_filter.dart';

class RequestStatusCounts {
  final int all;
  final int pending;
  final int offerSent;
  final int declined;
  final int expired;

  const RequestStatusCounts({
    this.all = 0,
    this.pending = 0,
    this.offerSent = 0,
    this.declined = 0,
    this.expired = 0,
  });

  int countForFilter(RequestFilter filter) {
    switch (filter) {
      case RequestFilter.all:
        return all;
      case RequestFilter.pending:
        return pending;
      case RequestFilter.offerSent:
        return offerSent;
      case RequestFilter.declined:
        return declined;
      case RequestFilter.expired:
        return expired;
    }
  }
}
