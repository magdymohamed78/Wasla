import 'package:waslaapp/features/home/data/models/customer_portal_models.dart';
import 'package:waslaapp/features/requests/data/models/service_request_details_dto.dart';
import 'package:waslaapp/features/requests/data/models/request_page_result_dto.dart';
import 'package:waslaapp/features/requests/domain/entities/service_request_details.dart';
import 'package:waslaapp/features/requests/domain/entities/request_filter.dart';
import 'package:waslaapp/features/requests/domain/entities/request_page_result.dart';
import 'package:waslaapp/features/requests/domain/entities/request_status_counts.dart';
import 'package:waslaapp/features/requests/domain/use_cases/request_status_normalization_use_case.dart';
import 'package:waslaapp/features/offers/data/models/offer_page_result_dto.dart';
import 'package:waslaapp/features/offers/domain/entities/offer_page_result.dart';
import 'package:waslaapp/features/home/domain/entities/customer_dashboard_metrics.dart';

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
  Future<CustomerDashboardMetrics> getCustomerDashboardMetrics() async {
    final rawJson = await _remote.getMyDashboard();

    final totalOffers = asInt(rawJson['totalOffers']);
    final totalReviews = asInt(rawJson['totalReviews']);

    final rawOffersByStatus = rawJson['offersByStatus'];
    final offersByStatus = rawOffersByStatus is Map
        ? rawOffersByStatus.map(
            (key, value) => MapEntry(key.toString(), asInt(value)),
          )
        : const <String, int>{};

    final acceptedOffers =
        _resolveStatusCount(offersByStatus, const ['accepted']) ?? 0;
    final pendingOffers =
        _resolveStatusCount(offersByStatus, const [
          'pending',
          'sent',
          'offersent',
        ]) ??
        0;

    return CustomerDashboardMetrics(
      totalOffers: totalOffers < 0 ? 0 : totalOffers,
      acceptedOffers: acceptedOffers < 0 ? 0 : acceptedOffers,
      pendingOffers: pendingOffers < 0 ? 0 : pendingOffers,
      totalReviews: totalReviews < 0 ? 0 : totalReviews,
    );
  }

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
      statusCounts: _buildRequestStatusCounts(dto.statusCounts, dto.totalCount),
    );
  }

  @override
  Future<ServiceRequestDetails> getCustomerServiceRequestDetails({
    required int serviceRequestId,
  }) async {
    final rawJson = await _remote.getServiceRequestDetails(
      serviceRequestId: serviceRequestId,
    );

    final dto = ServiceRequestDetailsDto.fromJson(
      rawJson,
      normalizer: _normalizer,
    );

    return dto.toDomain();
  }

  RequestStatusCounts _buildRequestStatusCounts(
    Map<RequestFilter, int> counts,
    int fallbackAll,
  ) {
    final pending = counts[RequestFilter.pending] ?? 0;
    final offerSent = counts[RequestFilter.offerSent] ?? 0;
    final declined = counts[RequestFilter.declined] ?? 0;
    final expired = counts[RequestFilter.expired] ?? 0;
    final knownSum = pending + offerSent + declined + expired;

    final all =
        counts[RequestFilter.all] ?? (fallbackAll > 0 ? fallbackAll : knownSum);

    return RequestStatusCounts(
      all: all < 0 ? 0 : all,
      pending: pending < 0 ? 0 : pending,
      offerSent: offerSent < 0 ? 0 : offerSent,
      declined: declined < 0 ? 0 : declined,
      expired: expired < 0 ? 0 : expired,
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
  Future<OfferPageResult> getCustomerOffersPaged({
    required int pageIndex,
    required int pageSize,
    String? status,
  }) async {
    final rawJson = await _remote.getMyOffersPaged(
      pageIndex: pageIndex,
      pageSize: pageSize,
      status: status,
    );

    final dto = OfferPageResultDto.fromJson(rawJson);
    return dto.toDomain();
  }

  @override
  Future<CustomerReviewsPageResult> getMyReviews({
    required int pageIndex,
    required int pageSize,
  }) async {
    final rawJson = await _remote.getMyReviewsPaged(
      pageIndex: pageIndex,
      pageSize: pageSize,
    );

    final rawItems = rawJson['items'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(CustomerReviewDto.fromJson)
              .map((dto) => dto.toDomain())
              .toList(growable: false)
        : const <CustomerReviewItem>[];

    final normalizedPageIndex = asInt(
      rawJson['pageIndex'],
      fallback: pageIndex,
    );
    final normalizedPageSize = asInt(rawJson['pageSize'], fallback: pageSize);
    final normalizedTotalCount = asInt(
      rawJson['totalCount'],
      fallback: items.length,
    );

    var normalizedTotalPages = asInt(rawJson['totalPages']);
    if (normalizedTotalPages <= 0) {
      final safePageSize = normalizedPageSize <= 0
          ? pageSize
          : normalizedPageSize;
      normalizedTotalPages = safePageSize > 0
          ? (normalizedTotalCount / safePageSize).ceil()
          : 1;
    }

    return CustomerReviewsPageResult(
      items: items,
      pageIndex: normalizedPageIndex,
      pageSize: normalizedPageSize,
      totalCount: normalizedTotalCount,
      totalPages: normalizedTotalPages,
    );
  }

  @override
  Future<int> getMyReviewsCount() async {
    final result = await getMyReviews(pageIndex: 1, pageSize: 1);
    return result.totalCount;
  }

  @override
  Future<CustomerReviewItem> updateReview({
    required int companyId,
    required int rating,
    String? reviewText,
  }) async {
    final rawJson = await _remote.updateMyReview(
      companyId: companyId,
      rating: rating,
      reviewText: reviewText,
    );

    final dto = CustomerReviewDto.fromJson(rawJson);
    return dto.toDomain();
  }

  @override
  Future<CustomerReviewItem> createReview({
    required int companyId,
    required int rating,
    String? reviewText,
  }) async {
    final rawJson = await _remote.createMyReview(
      companyId: companyId,
      rating: rating,
      reviewText: reviewText,
    );

    final dto = CustomerReviewDto.fromJson(rawJson);
    return dto.toDomain();
  }

  @override
  Future<void> deleteReview({required int companyId}) {
    return _remote.deleteMyReview(companyId: companyId);
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

  int? _resolveStatusCount(Map<String, int> counts, List<String> aliases) {
    for (final entry in counts.entries) {
      final normalizedKey = _normalizeStatusKey(entry.key);
      if (aliases.contains(normalizedKey)) {
        return entry.value;
      }
    }

    return null;
  }

  String _normalizeStatusKey(String key) {
    return key.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}
