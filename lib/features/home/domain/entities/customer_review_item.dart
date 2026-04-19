class CustomerReviewItem {
  final int reviewId;
  final int companyId;
  final String? companyName;
  final String? companyLogoUrl;
  final String? customerFirstName;
  final int rating;
  final String? reviewText;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CustomerReviewItem({
    required this.reviewId,
    required this.companyId,
    required this.rating,
    this.companyName,
    this.companyLogoUrl,
    this.customerFirstName,
    this.reviewText,
    this.createdAt,
    this.updatedAt,
  });
}
