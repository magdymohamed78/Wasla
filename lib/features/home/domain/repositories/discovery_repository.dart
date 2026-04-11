import '../entities/company_details.dart';
import '../entities/company_summary.dart';
import '../entities/discovery_types.dart';
import '../entities/explore_pagination.dart';

abstract class DiscoveryRepository {
  Future<DiscoveryPage<CompanySummary>> getAllCompanies({
    int pageIndex,
    int pageSize,
    String? search,
    String? city,
    ServiceFilterOption service,
    String sortBy,
  });

  Future<DiscoveryPage<CompanySummary>> getRecommendedCompanies({
    int pageIndex,
    int pageSize,
    ServiceFilterOption service,
  });

  Future<DiscoveryPage<CompanySummary>> getTrendingCompanies({
    int pageIndex,
    int pageSize,
    ServiceFilterOption service,
  });

  Future<CompanyDetailsModel> getCompanyDetails(int companyId);

  Future<DiscoveryPage<CompanyReviewItem>> getCompanyReviews({
    required int companyId,
    int pageIndex,
    int pageSize,
  });
}
