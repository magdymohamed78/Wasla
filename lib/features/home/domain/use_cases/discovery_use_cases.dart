import '../entities/company_details.dart';
import '../entities/company_summary.dart';
import '../entities/discovery_types.dart';
import '../entities/explore_pagination.dart';
import '../repositories/discovery_repository.dart';

class GetAllCompaniesUseCase {
  final DiscoveryRepository _repository;

  const GetAllCompaniesUseCase(this._repository);

  Future<DiscoveryPage<CompanySummary>> call({
    int pageIndex = 1,
    int pageSize = 12,
    String? search,
    String? city,
    ServiceFilterOption service = ServiceFilterOption.allServices,
    String sortBy = 'rating',
  }) {
    return _repository.getAllCompanies(
      pageIndex: pageIndex,
      pageSize: pageSize,
      search: search,
      city: city,
      service: service,
      sortBy: sortBy,
    );
  }
}

class GetRecommendedCompaniesUseCase {
  final DiscoveryRepository _repository;

  const GetRecommendedCompaniesUseCase(this._repository);

  Future<DiscoveryPage<CompanySummary>> call({
    int pageIndex = 1,
    int pageSize = 10,
    ServiceFilterOption service = ServiceFilterOption.allServices,
  }) {
    return _repository.getRecommendedCompanies(
      pageIndex: pageIndex,
      pageSize: pageSize,
      service: service,
    );
  }
}

class GetTrendingCompaniesUseCase {
  final DiscoveryRepository _repository;

  const GetTrendingCompaniesUseCase(this._repository);

  Future<DiscoveryPage<CompanySummary>> call({
    int pageIndex = 1,
    int pageSize = 10,
    ServiceFilterOption service = ServiceFilterOption.allServices,
  }) {
    return _repository.getTrendingCompanies(
      pageIndex: pageIndex,
      pageSize: pageSize,
      service: service,
    );
  }
}

class GetCompanyDetailsUseCase {
  final DiscoveryRepository _repository;

  const GetCompanyDetailsUseCase(this._repository);

  Future<CompanyDetailsModel> call(int companyId) {
    return _repository.getCompanyDetails(companyId);
  }
}

class GetCompanyReviewsUseCase {
  final DiscoveryRepository _repository;

  const GetCompanyReviewsUseCase(this._repository);

  Future<DiscoveryPage<CompanyReviewItem>> call({
    required int companyId,
    int pageIndex = 1,
    int pageSize = 10,
  }) {
    return _repository.getCompanyReviews(
      companyId: companyId,
      pageIndex: pageIndex,
      pageSize: pageSize,
    );
  }
}
