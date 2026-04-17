import 'package:dio/dio.dart';

import '../models/customer_portal_models.dart';

class CustomerRequestsRemoteDataSource {
  static const String _endpoint = '/api/customer-portal/my/service-requests';

  final Dio _dio;

  const CustomerRequestsRemoteDataSource(this._dio);

  Future<List<CustomerServiceRequestSummaryDto>> getMyServiceRequests({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final response = await _dio.get<dynamic>(
      _endpoint,
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

  Future<Map<String, dynamic>> getMyServiceRequestsPaged({
    int pageIndex = 1,
    int pageSize = 10,
    String? status,
  }) async {
    final response = await _dio.get<dynamic>(
      _endpoint,
      queryParameters: <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
      },
    );

    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    return {
      'items': <dynamic>[],
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'totalCount': 0,
      'totalPages': 0,
    };
  }

  Future<Map<String, dynamic>> getServiceRequestDetails({
    required int serviceRequestId,
  }) async {
    final response = await _dio.get<dynamic>('$_endpoint/$serviceRequestId');

    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    throw Exception('Invalid response for request details');
  }
}
