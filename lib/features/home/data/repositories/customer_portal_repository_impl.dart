import 'package:waslaapp/features/home/data/models/customer_portal_models.dart';
import 'package:waslaapp/features/requests/data/models/request_details_compact_dto.dart';
import 'package:waslaapp/features/requests/data/models/request_page_result_dto.dart';
import 'package:waslaapp/features/requests/domain/entities/request_details_compact.dart';
import 'package:waslaapp/features/requests/domain/entities/request_filter.dart';
import 'package:waslaapp/features/requests/domain/entities/request_page_result.dart';
import 'package:waslaapp/features/requests/domain/entities/request_status_counts.dart';
import 'package:waslaapp/features/requests/domain/use_cases/request_status_normalization_use_case.dart';

import '../../domain/entities/customer_portal_content.dart';
import '../../domain/repositories/customer_portal_repository.dart';
import '../data_sources/customer_portal_remote_data_source.dart';

class CustomerPortalRepositoryImpl implements CustomerPortalRepository {
  final CustomerPortalRemoteDataSource _remote;
  final RequestStatusNormalizationUseCase _normalizer;

  CustomerPortalRepositoryImpl({
    required CustomerPortalRemoteDataSource remote,
    RequestStatusNormalizationUseCase? normalizer,
  }) : _remote = remote,
       _normalizer = normalizer ?? RequestStatusNormalizationUseCase();

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
  Future<RequestPageResult> getCustomerServiceRequestsPaged({
    required int pageIndex,
    required int pageSize,
    RequestFilter? filter,
  }) async {
    final statusQuery = filter != null && filter != RequestFilter.all
        ? filter.toQueryValue()
        : null;

    final rawJson = await _remote.getMyServiceRequestsPaged(
      pageIndex: pageIndex,
      pageSize: pageSize,
      status: statusQuery,
    );

    final dto = RequestPageResultDto.fromJson(rawJson);

    final items = dto.items
        .map(
          (item) => RequestSummaryItem(
            serviceRequestId: item.serviceRequestId,
            referenceNumber: item.referenceNumber,
            companyId: item.companyId,
            companyName: item.companyName,
            companyLogoUrl: item.companyLogoUrl,
            serviceType: item.serviceType,
            rawStatus: item.rawStatus,
            normalizedFilter: item.normalizedFilter,
            preferredDate: item.preferredDate,
            createdAt: item.createdAt,
            hasOffer: item.hasOffer,
            offerId: item.offerId,
          ),
        )
        .toList(growable: false);

    return RequestPageResult(
      items: items,
      pageIndex: dto.pageIndex,
      pageSize: dto.pageSize,
      totalCount: dto.totalCount,
      totalPages: dto.totalPages,
      statusCounts: _buildStatusCounts(dto.statusCounts, items),
    );
  }

  @override
  Future<RequestDetailsCompact> getCustomerServiceRequestDetails({
    required int serviceRequestId,
  }) async {
    final rawJson = await _remote.getServiceRequestDetails(
      serviceRequestId: serviceRequestId,
    );

    final dto = RequestDetailsCompactDto.fromJson(
      rawJson,
      normalizer: _normalizer,
    );

    return RequestDetailsCompact(
      serviceRequestId: dto.serviceRequestId,
      referenceNumber: dto.referenceNumber,
      companyId: dto.companyId,
      companyName: dto.companyName,
      companyLogoUrl: dto.companyLogoUrl,
      serviceType: dto.serviceType,
      rawStatus: dto.rawStatus,
      normalizedFilter: dto.normalizedFilter,
      preferredDate: dto.preferredDate,
      createdAt: dto.createdAt,
    );
  }

  RequestStatusCounts _buildStatusCounts(
    Map<RequestFilter, int> _,
    List<RequestSummaryItem> items,
  ) {
    int pending = 0;
    int offerSent = 0;
    int declined = 0;
    int expired = 0;

    for (final item in items) {
      switch (item.normalizedFilter) {
        case RequestFilter.pending:
          pending++;
        case RequestFilter.offerSent:
          offerSent++;
        case RequestFilter.declined:
          declined++;
        case RequestFilter.expired:
          expired++;
        case RequestFilter.all:
          break;
      }
    }

    return RequestStatusCounts(
      all: items.length,
      pending: pending,
      offerSent: offerSent,
      declined: declined,
      expired: expired,
    );
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
  Future<CustomerPortalProfile> updateCustomerProfile({
    required UpdatePortalProfileInput input,
  }) async {
    final payload = UpdateCustomerProfileDto.fromDomain(input);
    final updated = await _remote.updateMyProfile(payload: payload);
    return updated.toDomain();
  }

  @override
  Future<LeadPortalProfile> updateLeadProfile({
    required UpdatePortalProfileInput input,
  }) async {
    final payload = UpdateCustomerProfileDto.fromDomain(input);
    final updated = await _remote.updateMyLeadProfile(payload: payload);
    return updated.toDomain();
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
