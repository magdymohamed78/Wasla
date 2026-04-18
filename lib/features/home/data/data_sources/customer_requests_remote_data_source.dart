import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/customer_portal_models.dart';

class CustomerRequestsRemoteDataSource {
  static const String _endpoint = '/api/customer-portal/my/service-requests';

  final Dio _dio;

  const CustomerRequestsRemoteDataSource(this._dio);

  Options _noCacheOptions() {
    return Options(
      headers: const <String, String>{
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0',
      },
    );
  }

  Future<List<CustomerServiceRequestSummaryDto>> getMyServiceRequests({
    int pageIndex = 1,
    int pageSize = 20,
    String? status,
  }) async {
    debugPrint(
      '[CustomerRequestsRemoteDataSource] getMyServiceRequests request '
      'pageIndex=$pageIndex pageSize=$pageSize status=$status',
    );

    final response = await _dio.get<dynamic>(
      _endpoint,
      options: _noCacheOptions(),
      queryParameters: <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
      },
    );

    final payload = response.data;
    final items = payload is Map<String, dynamic> ? payload['items'] : payload;
    if (items is! List) {
      debugPrint(
        '[CustomerRequestsRemoteDataSource] getMyServiceRequests response '
        'invalid items payload type=${items.runtimeType}',
      );
      return const <CustomerServiceRequestSummaryDto>[];
    }

    debugPrint(
      '[CustomerRequestsRemoteDataSource] getMyServiceRequests response '
      'items=${items.length}',
    );

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
    debugPrint(
      '[CustomerRequestsRemoteDataSource] getMyServiceRequestsPaged request '
      'pageIndex=$pageIndex pageSize=$pageSize status=$status',
    );

    final response = await _dio.get<dynamic>(
      _endpoint,
      options: _noCacheOptions(),
      queryParameters: <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
      },
    );

    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final items = payload['items'];
      final totalCount = payload['totalCount'];
      final totalPages = payload['totalPages'];
      final itemCount = items is List ? items.length : 0;

      debugPrint(
        '[CustomerRequestsRemoteDataSource] getMyServiceRequestsPaged response '
        'itemCount=$itemCount totalCount=$totalCount totalPages=$totalPages',
      );
      return payload;
    }

    debugPrint(
      '[CustomerRequestsRemoteDataSource] getMyServiceRequestsPaged response '
      'invalid payload type=${payload.runtimeType}',
    );

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
    debugPrint(
      '[CustomerRequestsRemoteDataSource] getServiceRequestDetails request '
      'serviceRequestId=$serviceRequestId',
    );

    final response = await _dio.get<dynamic>(
      '$_endpoint/$serviceRequestId',
      options: _noCacheOptions(),
    );

    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      debugPrint(
        '[CustomerRequestsRemoteDataSource] getServiceRequestDetails response '
        'serviceRequestId=$serviceRequestId status=${payload['status']}',
      );
      return payload;
    }

    debugPrint(
      '[CustomerRequestsRemoteDataSource] getServiceRequestDetails response '
      'invalid payload type=${payload.runtimeType}',
    );

    throw Exception('Invalid response for request details');
  }
}
