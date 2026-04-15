import '../../domain/entities/customer_portal_content.dart';
import '../../domain/repositories/customer_portal_repository.dart';
import '../data_sources/customer_portal_remote_data_source.dart';

class CustomerPortalRepositoryImpl implements CustomerPortalRepository {
  final CustomerPortalRemoteDataSource _remote;

  const CustomerPortalRepositoryImpl({
    required CustomerPortalRemoteDataSource remote,
  }) : _remote = remote;

  @override
  Future<List<CustomerServiceRequestSummary>> getCustomerServiceRequests({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final items = await _remote.getMyServiceRequests(
      pageIndex: pageIndex,
      pageSize: pageSize,
      status: status,
    );

    return items.map((item) => item.toDomain()).toList(growable: false);
  }

  @override
  Future<List<CustomerOfferSummary>> getCustomerOffers({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final items = await _remote.getMyOffers(
      pageIndex: pageIndex,
      pageSize: pageSize,
      status: status,
    );

    return items.map((item) => item.toDomain()).toList(growable: false);
  }

  @override
  Future<CustomerPortalProfile> getCustomerProfile() async {
    final profile = await _remote.getMyProfile();
    return profile.toDomain();
  }

  @override
  Future<LeadPortalProfile> getLeadProfile() async {
    final profile = await _remote.getMyLeadProfile();
    return profile.toDomain();
  }

  @override
  Future<String> revealDigitalSignature({required String password}) {
    return _remote.revealDigitalSignature(password: password);
  }

  @override
  Future<void> logout() {
    return _remote.logout();
  }

  @override
  Future<void> logoutAll() {
    return _remote.logoutAll();
  }
}
