import 'customer_offers_repository.dart';
import 'customer_reviews_repository.dart';
import 'customer_requests_repository.dart';
import 'digital_signature_repository.dart';
import 'logout_repository.dart';
import 'profile_repository.dart';
import '../entities/customer_dashboard_metrics.dart';

abstract class CustomerPortalRepository
    implements
        ProfileRepository,
        CustomerRequestsRepository,
        CustomerOffersRepository,
        CustomerReviewsRepository,
        DigitalSignatureRepository,
        LogoutRepository {
  Future<CustomerDashboardMetrics> getCustomerDashboardMetrics();
}
