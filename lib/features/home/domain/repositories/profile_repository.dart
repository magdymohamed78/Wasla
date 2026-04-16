import '../entities/customer_portal_profile.dart';
import '../entities/lead_portal_profile.dart';
import '../entities/update_portal_profile_input.dart';

abstract class ProfileRepository {
  Future<CustomerPortalProfile> getCustomerProfile();

  Future<LeadPortalProfile> getLeadProfile();

  Future<CustomerPortalProfile> updateCustomerProfile({
    required UpdatePortalProfileInput input,
  });

  Future<LeadPortalProfile> updateLeadProfile({
    required UpdatePortalProfileInput input,
  });
}
