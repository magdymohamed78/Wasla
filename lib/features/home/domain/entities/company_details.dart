class CompanyServiceItem {
  final int? id;
  final String name;
  final String? description;
  final double? price;
  final double? indicativePriceFrom;
  final double? indicativePriceTo;
  final String? pricingUnit;

  const CompanyServiceItem({
    this.id,
    required this.name,
    this.description,
    this.price,
    this.indicativePriceFrom,
    this.indicativePriceTo,
    this.pricingUnit,
  });
}

class CompanyReviewItem {
  final int? reviewId;
  final String? customerName;
  final String? comment;
  final double? rating;
  final DateTime? createdAt;

  const CompanyReviewItem({
    this.reviewId,
    this.customerName,
    this.comment,
    this.rating,
    this.createdAt,
  });
}

class CompanyDetailsModel {
  final int companyId;
  final String companyName;
  final String? companyLogoUrl;
  final String? contactEmail;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? country;
  final double? averageRating;
  final int? reviewCount;
  final List<CompanyServiceItem> serviceCatalog;
  final List<CompanyReviewItem> recentReviews;

  const CompanyDetailsModel({
    required this.companyId,
    required this.companyName,
    this.companyLogoUrl,
    this.contactEmail,
    this.phoneNumber,
    this.address,
    this.city,
    this.zipCode,
    this.country,
    this.averageRating,
    this.reviewCount,
    this.serviceCatalog = const <CompanyServiceItem>[],
    this.recentReviews = const <CompanyReviewItem>[],
  });
}
