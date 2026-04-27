import 'offer_filter.dart';

class OfferStatusCounts {
  final int all;
  final int pending;
  final int accepted;
  final int rejected;
  final int canceled;

  const OfferStatusCounts({
    this.all = 0,
    this.pending = 0,
    this.accepted = 0,
    this.rejected = 0,
    this.canceled = 0,
  });

  int countForFilter(OfferFilter filter) {
    switch (filter) {
      case OfferFilter.all:
        return all;
      case OfferFilter.pending:
        return pending;
      case OfferFilter.accepted:
        return accepted;
      case OfferFilter.rejected:
        return rejected;
      case OfferFilter.canceled:
        return canceled;
    }
  }
}
