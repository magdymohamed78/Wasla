import '../../domain/entities/company_details.dart';
import '../../domain/entities/company_summary.dart';
import '../../domain/entities/discovery_types.dart';

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

String? _asString(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  return value.toString();
}

List<String> _asStringList(dynamic value) {
  if (value is List) {
    return value
        .map((item) {
          if (item is String) return item.trim();
          if (item is Map<String, dynamic>) {
            return _asString(item['title']) ??
                _asString(item['name']) ??
                _asString(item['serviceType']) ??
                '';
          }
          return item.toString();
        })
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }
  return const <String>[];
}

List<dynamic> _extractItems(dynamic json) {
  if (json is List) return json;
  if (json is Map<String, dynamic>) {
    final candidates = <String>['items', 'data', 'results', 'value'];
    for (final key in candidates) {
      final value = json[key];
      if (value is List) return value;
    }
  }
  return const <dynamic>[];
}

TrendDirection? _trendFromDelta(double? delta) {
  if (delta == null) return null;
  if (delta > 0) return TrendDirection.improving;
  if (delta < 0) return TrendDirection.declining;
  return TrendDirection.neutral;
}

class DiscoveryPaginatedDto<T> {
  final List<T> items;
  final int pageIndex;
  final int pageSize;
  final int? totalCount;
  final bool hasMore;

  const DiscoveryPaginatedDto({
    required this.items,
    required this.pageIndex,
    required this.pageSize,
    this.totalCount,
    required this.hasMore,
  });

  factory DiscoveryPaginatedDto.fromJson(
    dynamic json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    final itemsRaw = _extractItems(json);
    final mappedItems = itemsRaw
        .whereType<Map<String, dynamic>>()
        .map(fromItem)
        .toList(growable: false);

    if (json is! Map<String, dynamic>) {
      return DiscoveryPaginatedDto<T>(
        items: mappedItems,
        pageIndex: 1,
        pageSize: mappedItems.length,
        totalCount: mappedItems.length,
        hasMore: false,
      );
    }

    final pageIndex = _asInt(
      json['pageIndex'] ?? json['PageIndex'] ?? json['currentPage'] ?? 1,
      fallback: 1,
    );
    final pageSize = _asInt(
      json['pageSize'] ??
          json['PageSize'] ??
          json['perPage'] ??
          mappedItems.length,
      fallback: mappedItems.length,
    );
    final totalCountValue =
        json['totalCount'] ??
        json['TotalCount'] ??
        json['total'] ??
        json['totalRecords'];
    final totalCount = totalCountValue == null ? null : _asInt(totalCountValue);

    final hasMoreExplicit = json['hasMore'] ?? json['HasMore'];
    final hasMore = hasMoreExplicit is bool
        ? hasMoreExplicit
        : (totalCount == null ? false : (pageIndex * pageSize) < totalCount);

    return DiscoveryPaginatedDto<T>(
      items: mappedItems,
      pageIndex: pageIndex,
      pageSize: pageSize,
      totalCount: totalCount,
      hasMore: hasMore,
    );
  }
}

class PublicCompanyListDto {
  final int companyId;
  final String companyName;
  final String? companyLogoUrl;
  final String? city;
  final String? country;
  final double? averageRating;
  final int? reviewCount;
  final List<String> serviceTypes;

  const PublicCompanyListDto({
    required this.companyId,
    required this.companyName,
    this.companyLogoUrl,
    this.city,
    this.country,
    this.averageRating,
    this.reviewCount,
    this.serviceTypes = const <String>[],
  });

  factory PublicCompanyListDto.fromJson(Map<String, dynamic> json) {
    return PublicCompanyListDto(
      companyId: _asInt(json['companyId'] ?? json['id']),
      companyName:
          _asString(json['companyName'] ?? json['name']) ?? 'Unknown Company',
      companyLogoUrl: _asString(json['companyLogoUrl'] ?? json['logoUrl']),
      city: _asString(json['city']),
      country: _asString(json['country']),
      averageRating: _asDouble(json['averageRating'] ?? json['rating']),
      reviewCount: json['reviewCount'] == null
          ? null
          : _asInt(json['reviewCount']),
      serviceTypes: _asStringList(json['serviceTypes'] ?? json['services']),
    );
  }

  CompanySummary toDomain({double? improvementDelta}) {
    return CompanySummary(
      companyId: companyId,
      companyName: companyName,
      companyLogoUrl: companyLogoUrl,
      city: city,
      country: country,
      averageRating: averageRating,
      reviewCount: reviewCount,
      serviceTypes: serviceTypes,
      trendDirection: _trendFromDelta(improvementDelta),
      improvementDelta: improvementDelta,
    );
  }
}

class RecommendedCompanyDto {
  final PublicCompanyListDto base;

  const RecommendedCompanyDto({required this.base});

  factory RecommendedCompanyDto.fromJson(Map<String, dynamic> json) {
    return RecommendedCompanyDto(base: PublicCompanyListDto.fromJson(json));
  }

  CompanySummary toDomain() => base.toDomain();
}

class TrendingCompanyDto {
  final PublicCompanyListDto base;
  final double? improvementDelta;

  const TrendingCompanyDto({required this.base, this.improvementDelta});

  factory TrendingCompanyDto.fromJson(Map<String, dynamic> json) {
    return TrendingCompanyDto(
      base: PublicCompanyListDto.fromJson(json),
      improvementDelta: _asDouble(json['improvementDelta']),
    );
  }

  CompanySummary toDomain() =>
      base.toDomain(improvementDelta: improvementDelta);
}

class CompanyReviewDto {
  final int? reviewId;
  final String? customerName;
  final String? comment;
  final double? rating;
  final DateTime? createdAt;

  const CompanyReviewDto({
    this.reviewId,
    this.customerName,
    this.comment,
    this.rating,
    this.createdAt,
  });

  factory CompanyReviewDto.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = _asString(json['createdAt']);
    return CompanyReviewDto(
      reviewId: json['companyReviewId'] == null
          ? null
          : _asInt(json['companyReviewId']),
      customerName: _asString(json['customerFirstName']),
      comment: _asString(json['reviewText']),
      rating: _asDouble(json['rating']),
      createdAt: createdAtRaw == null ? null : DateTime.tryParse(createdAtRaw),
    );
  }

  CompanyReviewItem toDomain() {
    return CompanyReviewItem(
      reviewId: reviewId,
      customerName: customerName,
      comment: comment,
      rating: rating,
      createdAt: createdAt,
    );
  }
}

class PublicCompanyDetailsDto {
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
  final List<CompanyReviewDto> recentReviews;

  const PublicCompanyDetailsDto({
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
    this.recentReviews = const <CompanyReviewDto>[],
  });

  factory PublicCompanyDetailsDto.fromJson(Map<String, dynamic> json) {
    final servicesRaw = _extractItems(
      json['serviceCatalog'] ?? json['services'],
    );
    final reviewsRaw = _extractItems(json['recentReviews'] ?? json['reviews']);

    return PublicCompanyDetailsDto(
      companyId: _asInt(json['companyId'] ?? json['id']),
      companyName:
          _asString(json['companyName'] ?? json['name']) ?? 'Unknown Company',
      companyLogoUrl: _asString(json['companyLogoUrl'] ?? json['logoUrl']),
      contactEmail: _asString(json['contactEmail'] ?? json['email']),
      phoneNumber: _asString(json['phoneNumber'] ?? json['phone']),
      address: _asString(json['address']),
      city: _asString(json['city']),
      zipCode: _asString(json['zipCode'] ?? json['postalCode']),
      country: _asString(json['country']),
      averageRating: _asDouble(json['averageRating'] ?? json['rating']),
      reviewCount: json['reviewCount'] == null
          ? null
          : _asInt(json['reviewCount']),
      serviceCatalog: servicesRaw
          .whereType<Map<String, dynamic>>()
          .map(
            (service) => CompanyServiceItem(
              id: null,
              name:
                  _asString(service['title']) ??
                  _asString(service['serviceType']) ??
                  'Service',
              description: _asString(service['description']),
              price: _asDouble(service['indicativePriceFrom']),
              indicativePriceFrom: _asDouble(service['indicativePriceFrom']),
              indicativePriceTo: _asDouble(service['indicativePriceTo']),
              pricingUnit: _asString(service['pricingUnit']),
            ),
          )
          .toList(growable: false),
      recentReviews: reviewsRaw
          .whereType<Map<String, dynamic>>()
          .map(CompanyReviewDto.fromJson)
          .toList(growable: false),
    );
  }

  CompanyDetailsModel toDomain() {
    return CompanyDetailsModel(
      companyId: companyId,
      companyName: companyName,
      companyLogoUrl: companyLogoUrl,
      contactEmail: contactEmail,
      phoneNumber: phoneNumber,
      address: address,
      city: city,
      zipCode: zipCode,
      country: country,
      averageRating: averageRating,
      reviewCount: reviewCount,
      serviceCatalog: serviceCatalog,
      recentReviews: recentReviews
          .map((review) => review.toDomain())
          .toList(growable: false),
    );
  }
}
