import 'offer_status_counts.dart';
import 'offer_summary_item.dart';

class OfferPageResult {
  final List<OfferSummaryItem> items;
  final int pageIndex;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final OfferStatusCounts statusCounts;

  const OfferPageResult({
    required this.items,
    required this.pageIndex,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.statusCounts,
  });

  bool get hasReachedEnd => pageIndex >= totalPages || items.isEmpty;
}
