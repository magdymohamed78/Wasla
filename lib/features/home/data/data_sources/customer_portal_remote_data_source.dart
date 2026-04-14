import 'package:dio/dio.dart';

import '../models/customer_portal_models.dart';

abstract class CustomerPortalRemoteDataSource {
  Future<List<CustomerServiceRequestSummaryDto>> getMyServiceRequests({
    int pageIndex,
    int pageSize,
    String? status,
  });

  Future<List<CustomerOfferSummaryDto>> getMyOffers({
    int pageIndex,
    int pageSize,
    String? status,
  });

  Future<CustomerProfileDto> getMyProfile();

  Future<LeadProfileDto> getMyLeadProfile();
}

class CustomerPortalRemoteDataSourceImpl
    implements CustomerPortalRemoteDataSource {
  static const String _myServiceRequestsEndpoint =
      '/api/customer-portal/my/service-requests';
  static const String _myOffersEndpoint = '/api/customer-portal/my/offers';
  static const String _myProfileEndpoint = '/api/customer-portal/my/profile';
  static const String _myLeadProfileEndpoint =
      '/api/customer-portal/my/lead-profile';

  final Dio _dio;

  const CustomerPortalRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CustomerServiceRequestSummaryDto>> getMyServiceRequests({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final response = await _dio.get<dynamic>(
      _myServiceRequestsEndpoint,
      queryParameters: <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
      },
    );

    final payload = response.data;
    final items = payload is Map<String, dynamic> ? payload['items'] : payload;
    if (items is! List) {
      return const <CustomerServiceRequestSummaryDto>[];
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map(CustomerServiceRequestSummaryDto.fromJson)
        .toList(growable: false);
  }

  @override
  Future<List<CustomerOfferSummaryDto>> getMyOffers({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final response = await _dio.get<dynamic>(
      _myOffersEndpoint,
      queryParameters: <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
      },
    );

    final payload = response.data;
    final items = payload is Map<String, dynamic> ? payload['items'] : payload;
    if (items is! List) {
      return const <CustomerOfferSummaryDto>[];
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map(CustomerOfferSummaryDto.fromJson)
        .toList(growable: false);
  }

  @override
  Future<CustomerProfileDto> getMyProfile() async {
    final response = await _dio.get<dynamic>(_myProfileEndpoint);
    final payload = response.data;
    if (payload is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid customer profile response payload.',
      );
    }

    return CustomerProfileDto.fromJson(payload);
  }

  @override
  Future<LeadProfileDto> getMyLeadProfile() async {
    final response = await _dio.get<dynamic>(_myLeadProfileEndpoint);
    final payload = response.data;
    if (payload is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid lead profile response payload.',
      );
    }

    return LeadProfileDto.fromJson(payload);
  }
}
