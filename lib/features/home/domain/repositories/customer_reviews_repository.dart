import '../entities/customer_review_item.dart';
import '../entities/customer_reviews_page_result.dart';

abstract class CustomerReviewsRepository {
  Future<int> getMyReviewsCount();

  Future<CustomerReviewsPageResult> getMyReviews({
    required int pageIndex,
    required int pageSize,
  });

  Future<CustomerReviewItem> updateReview({
    required int companyId,
    required int rating,
    String? reviewText,
  });

  Future<void> deleteReview({
    required int companyId,
  });
}
