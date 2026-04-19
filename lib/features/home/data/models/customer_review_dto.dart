import '../../domain/entities/customer_review_item.dart';
import 'json_helpers.dart';

class CustomerReviewDto {
  final int reviewId;
  final int companyId;
  final String? companyName;
  final String? companyLogoUrl;
  final String? customerFirstName;
  final int rating;
  final String? reviewText;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CustomerReviewDto({
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

  factory CustomerReviewDto.fromJson(Map<String, dynamic> json) {
    return CustomerReviewDto(
      reviewId: asInt(json['companyReviewId']),
      companyId: asInt(json['companyId']),
      companyName: asString(json['companyName']),
      companyLogoUrl: asString(json['companyLogoUrl']),
      customerFirstName: asString(json['customerFirstName']),
      rating: asInt(json['rating']),
      reviewText: asString(json['reviewText']),
      createdAt: asDate(json['createdAt']),
      updatedAt: asDate(json['updatedAt']),
    );
  }

  CustomerReviewItem toDomain() {
    return CustomerReviewItem(
      reviewId: reviewId,
      companyId: companyId,
      companyName: companyName,
      companyLogoUrl: companyLogoUrl,
      customerFirstName: customerFirstName,
      rating: rating,
      reviewText: reviewText,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
