import 'package:dio/dio.dart';

import '../models/customer_portal_models.dart';
import 'customer_offers_remote_data_source.dart';
import 'customer_reviews_remote_data_source.dart';
import 'customer_requests_remote_data_source.dart';
import 'digital_signature_remote_data_source.dart';
import 'logout_remote_data_source.dart';
import 'profile_remote_data_source.dart';

export 'customer_offers_remote_data_source.dart';
export 'customer_reviews_remote_data_source.dart';
export 'customer_requests_remote_data_source.dart';
export 'digital_signature_remote_data_source.dart';
export 'logout_remote_data_source.dart';
export 'profile_remote_data_source.dart';

abstract class CustomerPortalRemoteDataSource {
  Future<List<CustomerServiceRequestSummaryDto>> getMyServiceRequests({
    int pageIndex,
    int pageSize,
    String? status,
  });

  Future<Map<String, dynamic>> getMyServiceRequestsPaged({
    int pageIndex,
    int pageSize,
    String? status,
  });

  Future<Map<String, dynamic>> getServiceRequestDetails({
    required int serviceRequestId,
  });

  Future<List<CustomerOfferSummaryDto>> getMyOffers({
    int pageIndex,
    int pageSize,
    String? status,
  });

  Future<Map<String, dynamic>> getMyOffersPaged({
    int pageIndex,
    int pageSize,
    String? status,
  });

  Future<Map<String, dynamic>> getMyReviewsPaged({
    int pageIndex,
    int pageSize,
  });

  Future<Map<String, dynamic>> updateMyReview({
    required int companyId,
    required int rating,
    String? reviewText,
  });

  Future<void> deleteMyReview({required int companyId});

  Future<CustomerProfileDto> getMyProfile();

  Future<LeadProfileDto> getMyLeadProfile();

  Future<CustomerProfileDto> updateMyProfile({
    required UpdateCustomerProfileDto payload,
  });

  Future<LeadProfileDto> updateMyLeadProfile({
    required UpdateCustomerProfileDto payload,
  });

  Future<String> revealDigitalSignature({required String password});

  Future<void> logout();

  Future<void> logoutAll();
}

class CustomerPortalRemoteDataSourceImpl
    implements CustomerPortalRemoteDataSource {
  final ProfileRemoteDataSource _profile;
  final CustomerRequestsRemoteDataSource _requests;
  final CustomerOffersRemoteDataSource _offers;
  final CustomerReviewsRemoteDataSource _reviews;
  final DigitalSignatureRemoteDataSource _signature;
  final LogoutRemoteDataSource _logout;

  CustomerPortalRemoteDataSourceImpl(Dio dio)
    : _profile = ProfileRemoteDataSource(dio),
      _requests = CustomerRequestsRemoteDataSource(dio),
      _offers = CustomerOffersRemoteDataSource(dio),
      _reviews = CustomerReviewsRemoteDataSource(dio),
      _signature = DigitalSignatureRemoteDataSource(dio),
      _logout = LogoutRemoteDataSource(dio);

  @override
  Future<List<CustomerServiceRequestSummaryDto>> getMyServiceRequests({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) => _requests.getMyServiceRequests(
    pageIndex: pageIndex,
    pageSize: pageSize,
    status: status,
  );

  @override
  Future<Map<String, dynamic>> getMyServiceRequestsPaged({
    int pageIndex = 1,
    int pageSize = 10,
    String? status,
  }) => _requests.getMyServiceRequestsPaged(
    pageIndex: pageIndex,
    pageSize: pageSize,
    status: status,
  );

  @override
  Future<Map<String, dynamic>> getServiceRequestDetails({
    required int serviceRequestId,
  }) => _requests.getServiceRequestDetails(serviceRequestId: serviceRequestId);

  @override
  Future<List<CustomerOfferSummaryDto>> getMyOffers({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) => _offers.getMyOffers(
    pageIndex: pageIndex,
    pageSize: pageSize,
    status: status,
  );

  @override
  Future<Map<String, dynamic>> getMyOffersPaged({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) => _offers.getMyOffersPaged(
    pageIndex: pageIndex,
    pageSize: pageSize,
    status: status,
  );

  @override
  Future<Map<String, dynamic>> getMyReviewsPaged({
    int pageIndex = 1,
    int pageSize = 10,
  }) => _reviews.getMyReviewsPaged(
    pageIndex: pageIndex,
    pageSize: pageSize,
  );

  @override
  Future<Map<String, dynamic>> updateMyReview({
    required int companyId,
    required int rating,
    String? reviewText,
  }) => _reviews.updateMyReview(
    companyId: companyId,
    rating: rating,
    reviewText: reviewText,
  );

  @override
  Future<void> deleteMyReview({required int companyId}) =>
      _reviews.deleteMyReview(companyId: companyId);

  @override
  Future<CustomerProfileDto> getMyProfile() => _profile.getMyProfile();

  @override
  Future<LeadProfileDto> getMyLeadProfile() => _profile.getMyLeadProfile();

  @override
  Future<CustomerProfileDto> updateMyProfile({
    required UpdateCustomerProfileDto payload,
  }) => _profile.updateMyProfile(payload: payload);

  @override
  Future<LeadProfileDto> updateMyLeadProfile({
    required UpdateCustomerProfileDto payload,
  }) => _profile.updateMyLeadProfile(payload: payload);

  @override
  Future<String> revealDigitalSignature({required String password}) =>
      _signature.revealDigitalSignature(password: password);

  @override
  Future<void> logout() => _logout.logout();

  @override
  Future<void> logoutAll() => _logout.logoutAll();
}
