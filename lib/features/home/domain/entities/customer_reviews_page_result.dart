import 'customer_review_item.dart';

class CustomerReviewsPageResult {
  final List<CustomerReviewItem> items;
  final int pageIndex;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  const CustomerReviewsPageResult({
    required this.items,
    required this.pageIndex,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  bool get hasReachedEnd => pageIndex >= totalPages || items.isEmpty;
}
