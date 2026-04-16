import '../entities/customer_portal_content.dart';

abstract class CustomerPortalRepository {
  Future<List<CustomerServiceRequestSummary>> getCustomerServiceRequests({
    int pageIndex,
    int pageSize,
    String? status,
  });

  Future<List<CustomerOfferSummary>> getCustomerOffers({
    int pageIndex,
    int pageSize,
    String? status,
  });

  Future<CustomerPortalProfile> getCustomerProfile();

  Future<LeadPortalProfile> getLeadProfile();

  Future<CustomerPortalProfile> updateCustomerProfile({
    required UpdatePortalProfileInput input,
  });

  Future<LeadPortalProfile> updateLeadProfile({
    required UpdatePortalProfileInput input,
  });

  Future<String> revealDigitalSignature({required String password});

  Future<void> logout();

  Future<void> logoutAll();
}
