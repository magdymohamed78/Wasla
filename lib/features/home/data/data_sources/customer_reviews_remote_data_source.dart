import 'package:dio/dio.dart';

import '../models/json_helpers.dart';

class CustomerReviewsRemoteDataSource {
  static const String _myReviewsEndpoint = '/api/customer-portal/my/reviews';
  static const String _companyReviewEndpoint = '/api/customer-portal/companies';

  final Dio _dio;

  const CustomerReviewsRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> getMyReviewsPaged({
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    final response = await _dio.get<dynamic>(
      _myReviewsEndpoint,
      queryParameters: <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
      },
    );

    return _normalizePagedResponse(
      payload: response.data,
      requestedPageIndex: pageIndex,
      requestedPageSize: pageSize,
    );
  }

  Future<Map<String, dynamic>> updateMyReview({
    required int companyId,
    required int rating,
    String? reviewText,
  }) async {
    final response = await _dio.put<dynamic>(
      '$_companyReviewEndpoint/$companyId/reviews',
      data: <String, dynamic>{
        'rating': rating,
        'reviewText': reviewText?.trim(),
      },
    );

    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    throw Exception('Invalid response for update review');
  }

  Future<Map<String, dynamic>> createMyReview({
    required int companyId,
    required int rating,
    String? reviewText,
  }) async {
    final response = await _dio.post<dynamic>(
      '$_companyReviewEndpoint/$companyId/reviews',
      data: <String, dynamic>{
        'rating': rating,
        'reviewText': reviewText?.trim(),
      },
    );

    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    throw Exception('Invalid response for create review');
  }

  Future<void> deleteMyReview({required int companyId}) async {
    await _dio.delete<void>('$_companyReviewEndpoint/$companyId/reviews');
  }

  Map<String, dynamic> _normalizePagedResponse({
    required dynamic payload,
    required int requestedPageIndex,
    required int requestedPageSize,
  }) {
    if (payload is Map<String, dynamic>) {
      final itemsDynamic = _extractItemsFromMap(payload);
      final itemList = itemsDynamic.whereType<Map<String, dynamic>>().toList();

      final pageIndex = asInt(
        payload['pageIndex'],
        fallback: requestedPageIndex,
      );
      final pageSize = asInt(payload['pageSize'], fallback: requestedPageSize);
      final totalCount = asInt(
        payload['totalCount'],
        fallback: itemList.length,
      );

      var totalPages = asInt(payload['totalPages']);
      if (totalPages <= 0) {
        final effectivePageSize = pageSize <= 0 ? requestedPageSize : pageSize;
        totalPages = effectivePageSize > 0
            ? (totalCount / effectivePageSize).ceil()
            : 1;
      }

      return <String, dynamic>{
        'items': itemList,
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'totalCount': totalCount,
        'totalPages': totalPages,
      };
    }

    if (payload is List) {
      final itemList = payload.whereType<Map<String, dynamic>>().toList();
      final totalCount = itemList.length;
      final totalPages = requestedPageSize > 0
          ? (totalCount / requestedPageSize).ceil()
          : 1;

      return <String, dynamic>{
        'items': itemList,
        'pageIndex': requestedPageIndex,
        'pageSize': requestedPageSize,
        'totalCount': totalCount,
        'totalPages': totalPages,
      };
    }

    return <String, dynamic>{
      'items': <Map<String, dynamic>>[],
      'pageIndex': requestedPageIndex,
      'pageSize': requestedPageSize,
      'totalCount': 0,
      'totalPages': 0,
    };
  }

  List<dynamic> _extractItemsFromMap(Map<String, dynamic> payload) {
    final items = payload['items'] ?? payload['data'] ?? payload['results'];
    if (items is List) {
      return items;
    }
    return const <dynamic>[];
  }
}
