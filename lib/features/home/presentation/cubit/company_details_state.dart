import '../../domain/entities/company_details.dart';
import '../../domain/entities/discovery_types.dart';

class CompanyDetailsState {
  static const Object _unset = Object();

  final int companyId;
  final LoadStatus detailsStatus;
  final String companyName;
  final String? companyLogoUrl;
  final double? averageRating;
  final int reviewCount;
  final String contactEmail;
  final String phoneNumber;
  final String addressLine;
  final String locationLine;
  final List<CompanyServiceItem> services;
  final List<CompanyReviewItem> reviews;
  final bool isRestrictionPromptVisible;
  final bool hasMoreReviews;
  final bool isLoadingMoreReviews;
  final int nextReviewsPage;
  final String? errorMessage;
  final String? reviewsErrorMessage;

  const CompanyDetailsState({
    required this.companyId,
    this.detailsStatus = LoadStatus.initial,
    this.companyName = '',
    this.companyLogoUrl,
    this.averageRating,
    this.reviewCount = 0,
    this.contactEmail = '',
    this.phoneNumber = '',
    this.addressLine = '',
    this.locationLine = '',
    this.services = const <CompanyServiceItem>[],
    this.reviews = const <CompanyReviewItem>[],
    this.isRestrictionPromptVisible = false,
    this.hasMoreReviews = false,
    this.isLoadingMoreReviews = false,
    this.nextReviewsPage = 2,
    this.errorMessage,
    this.reviewsErrorMessage,
  });

  bool get hasContactInfo {
    return contactEmail.isNotEmpty ||
        phoneNumber.isNotEmpty ||
        addressLine.isNotEmpty ||
        locationLine.isNotEmpty;
  }

  bool get hasServices => services.isNotEmpty;

  bool get hasReviews => reviews.isNotEmpty;

  bool get hasRating => averageRating != null && reviewCount > 0;

  CompanyDetailsState copyWith({
    LoadStatus? detailsStatus,
    String? companyName,
    Object? companyLogoUrl = _unset,
    Object? averageRating = _unset,
    int? reviewCount,
    String? contactEmail,
    String? phoneNumber,
    String? addressLine,
    String? locationLine,
    List<CompanyServiceItem>? services,
    List<CompanyReviewItem>? reviews,
    bool? isRestrictionPromptVisible,
    bool? hasMoreReviews,
    bool? isLoadingMoreReviews,
    int? nextReviewsPage,
    Object? errorMessage = _unset,
    Object? reviewsErrorMessage = _unset,
  }) {
    return CompanyDetailsState(
      companyId: companyId,
      detailsStatus: detailsStatus ?? this.detailsStatus,
      companyName: companyName ?? this.companyName,
      companyLogoUrl: identical(companyLogoUrl, _unset)
          ? this.companyLogoUrl
          : companyLogoUrl as String?,
      averageRating: identical(averageRating, _unset)
          ? this.averageRating
          : averageRating as double?,
      reviewCount: reviewCount ?? this.reviewCount,
      contactEmail: contactEmail ?? this.contactEmail,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addressLine: addressLine ?? this.addressLine,
      locationLine: locationLine ?? this.locationLine,
      services: services ?? this.services,
      reviews: reviews ?? this.reviews,
      isRestrictionPromptVisible:
          isRestrictionPromptVisible ?? this.isRestrictionPromptVisible,
      hasMoreReviews: hasMoreReviews ?? this.hasMoreReviews,
      isLoadingMoreReviews: isLoadingMoreReviews ?? this.isLoadingMoreReviews,
      nextReviewsPage: nextReviewsPage ?? this.nextReviewsPage,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      reviewsErrorMessage: identical(reviewsErrorMessage, _unset)
          ? this.reviewsErrorMessage
          : reviewsErrorMessage as String?,
    );
  }
}
