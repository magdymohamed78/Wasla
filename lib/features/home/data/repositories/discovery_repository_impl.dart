import '../../domain/entities/company_details.dart';
import '../../domain/entities/company_summary.dart';
import '../../domain/entities/discovery_types.dart';
import '../../domain/entities/explore_pagination.dart';
import '../../domain/repositories/discovery_repository.dart';
import '../data_sources/discovery_remote_data_source.dart';
import '../models/discovery_query_mapper.dart';

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final DiscoveryRemoteDataSource _remote;
  final Map<String, Future<DiscoveryPage<CompanySummary>>>
  _allCompaniesInFlight = <String, Future<DiscoveryPage<CompanySummary>>>{};

  DiscoveryRepositoryImpl({required DiscoveryRemoteDataSource remote})
    : _remote = remote;

  @override
  Future<DiscoveryPage<CompanySummary>> getAllCompanies({
    int pageIndex = 1,
    int pageSize = 12,
    String? search,
    String? city,
    ServiceFilterOption service = ServiceFilterOption.allServices,
    String sortBy = 'rating',
  }) async {
    final requestKey = _buildAllCompaniesRequestKey(
      pageIndex: pageIndex,
      pageSize: pageSize,
      search: search,
      city: city,
      service: service,
      sortBy: sortBy,
    );

    final inFlightRequest = _allCompaniesInFlight[requestKey];
    if (inFlightRequest != null) {
      return inFlightRequest;
    }

    final request = _fetchAllCompaniesPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      search: search,
      city: city,
      service: service,
      sortBy: sortBy,
    );

    _allCompaniesInFlight[requestKey] = request;
    return request.whenComplete(() {
      _allCompaniesInFlight.remove(requestKey);
    });
  }

  Future<DiscoveryPage<CompanySummary>> _fetchAllCompaniesPage({
    required int pageIndex,
    required int pageSize,
    String? search,
    String? city,
    required ServiceFilterOption service,
    required String sortBy,
  }) async {
    final query = DiscoveryQueryMapper.companiesQuery(
      pageIndex: pageIndex,
      pageSize: pageSize,
      search: search,
      city: city,
      service: service,
      sortBy: sortBy,
    );

    final items = await _remote.getAllCompanies(queryParameters: query);
    final domainItems = items
        .map((item) => item.toDomain())
        .toList(growable: false);

    return DiscoveryPage<CompanySummary>(
      items: domainItems,
      pageIndex: pageIndex,
      pageSize: pageSize,
      totalCount: null,
      hasReachedEnd: domainItems.length < pageSize,
    );
  }

  String _buildAllCompaniesRequestKey({
    required int pageIndex,
    required int pageSize,
    String? search,
    String? city,
    required ServiceFilterOption service,
    required String sortBy,
  }) {
    final normalizedSearch = search?.trim().toLowerCase() ?? '';
    final normalizedCity = city?.trim().toLowerCase() ?? '';
    final normalizedSort = sortBy.trim().toLowerCase();

    return '$pageIndex|$pageSize|$normalizedSearch|$normalizedCity|${service.name}|$normalizedSort';
  }

  @override
  Future<DiscoveryPage<CompanySummary>> getRecommendedCompanies({
    int pageIndex = 1,
    int pageSize = 10,
    ServiceFilterOption service = ServiceFilterOption.allServices,
  }) async {
    final query = DiscoveryQueryMapper.recommendedQuery(
      pageIndex: pageIndex,
      pageSize: pageSize,
      service: service,
    );

    final page = await _remote.getRecommendedCompanies(queryParameters: query);

    return DiscoveryPage<CompanySummary>(
      items: page.items.map((item) => item.toDomain()).toList(growable: false),
      pageIndex: page.pageIndex,
      pageSize: page.pageSize,
      totalCount: page.totalCount,
      hasReachedEnd: !page.hasMore,
    );
  }

  @override
  Future<DiscoveryPage<CompanySummary>> getTrendingCompanies({
    int pageIndex = 1,
    int pageSize = 10,
    ServiceFilterOption service = ServiceFilterOption.allServices,
  }) async {
    final query = DiscoveryQueryMapper.trendingQuery(
      pageIndex: pageIndex,
      pageSize: pageSize,
      service: service,
    );

    final page = await _remote.getTrendingCompanies(queryParameters: query);

    return DiscoveryPage<CompanySummary>(
      items: page.items.map((item) => item.toDomain()).toList(growable: false),
      pageIndex: page.pageIndex,
      pageSize: page.pageSize,
      totalCount: page.totalCount,
      hasReachedEnd: !page.hasMore,
    );
  }

  @override
  Future<CompanyDetailsModel> getCompanyDetails(int companyId) async {
    final details = await _remote.getCompanyDetails(companyId: companyId);
    return _normalizeCompanyDetails(details.toDomain());
  }

  @override
  Future<DiscoveryPage<CompanyReviewItem>> getCompanyReviews({
    required int companyId,
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    final query = DiscoveryQueryMapper.reviewsQuery(
      pageIndex: pageIndex,
      pageSize: pageSize,
    );

    final reviews = await _remote.getCompanyReviews(
      companyId: companyId,
      queryParameters: query,
    );

    final mappedReviews = reviews
        .map((item) => item.toDomain())
        .toList(growable: false);
    final normalizedReviews = _normalizeReviews(mappedReviews);

    return DiscoveryPage<CompanyReviewItem>(
      items: normalizedReviews,
      pageIndex: 1,
      pageSize: normalizedReviews.length,
      totalCount: normalizedReviews.length,
      hasReachedEnd: true,
    );
  }

  CompanyDetailsModel _normalizeCompanyDetails(CompanyDetailsModel details) {
    final normalizedServices = _normalizeServices(details.serviceCatalog);
    final normalizedReviews = _normalizeReviews(details.recentReviews);

    return CompanyDetailsModel(
      companyId: details.companyId,
      companyName: _normalizeText(details.companyName),
      companyLogoUrl: _normalizeOptionalText(details.companyLogoUrl),
      contactEmail: _normalizeOptionalText(details.contactEmail),
      phoneNumber: _normalizeOptionalText(details.phoneNumber),
      address: _normalizeOptionalText(details.address),
      city: _normalizeOptionalText(details.city),
      zipCode: _normalizeOptionalText(details.zipCode),
      country: _normalizeOptionalText(details.country),
      averageRating: _normalizeAverageRating(
        details.averageRating,
        normalizedReviews,
      ),
      reviewCount: _normalizeReviewCount(
        details.reviewCount,
        normalizedReviews,
      ),
      serviceCatalog: normalizedServices,
      recentReviews: normalizedReviews,
    );
  }

  List<CompanyServiceItem> _normalizeServices(
    List<CompanyServiceItem> services,
  ) {
    return services
        .map(
          (service) => CompanyServiceItem(
            id: service.id,
            name: _normalizeText(service.name),
            description: _normalizeOptionalText(service.description),
            price: service.price,
            indicativePriceFrom: service.indicativePriceFrom,
            indicativePriceTo: service.indicativePriceTo,
            pricingUnit: _normalizeOptionalText(service.pricingUnit),
          ),
        )
        .toList(growable: false);
  }

  List<CompanyReviewItem> _normalizeReviews(List<CompanyReviewItem> reviews) {
    return reviews
        .map(
          (review) => CompanyReviewItem(
            reviewId: review.reviewId,
            customerName: _normalizeOptionalText(review.customerName),
            comment: _normalizeOptionalText(review.comment),
            rating: review.rating,
            createdAt: review.createdAt,
          ),
        )
        .where(
          (review) =>
              review.customerName != null ||
              review.comment != null ||
              review.rating != null,
        )
        .toList(growable: false);
  }

  String _normalizeText(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return '';
    }
    return normalized;
  }

  String? _normalizeOptionalText(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  int _normalizeReviewCount(int? count, List<CompanyReviewItem> reviews) {
    if (count != null && count > 0) {
      return count;
    }
    return reviews.length;
  }

  double? _normalizeAverageRating(
    double? averageRating,
    List<CompanyReviewItem> reviews,
  ) {
    if (averageRating != null && averageRating > 0) {
      return averageRating;
    }

    final ratings = reviews
        .map((review) => review.rating)
        .whereType<double>()
        .where((rating) => rating > 0)
        .toList(growable: false);

    if (ratings.isEmpty) {
      return null;
    }

    final total = ratings.fold<double>(0, (sum, rating) => sum + rating);
    return total / ratings.length;
  }
}
