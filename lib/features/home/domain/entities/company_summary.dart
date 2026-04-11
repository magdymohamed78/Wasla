import 'discovery_types.dart';

class CompanySummary {
  final int companyId;
  final String companyName;
  final String? companyLogoUrl;
  final String? city;
  final String? country;
  final double? averageRating;
  final int? reviewCount;
  final List<String> serviceTypes;
  final TrendDirection? trendDirection;
  final double? improvementDelta;

  const CompanySummary({
    required this.companyId,
    required this.companyName,
    this.companyLogoUrl,
    this.city,
    this.country,
    this.averageRating,
    this.reviewCount,
    this.serviceTypes = const <String>[],
    this.trendDirection,
    this.improvementDelta,
  });
}
