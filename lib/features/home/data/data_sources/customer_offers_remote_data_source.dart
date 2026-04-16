import 'package:dio/dio.dart';

import '../models/customer_portal_models.dart';

class CustomerOffersRemoteDataSource {
  static const String _endpoint = '/api/customer-portal/my/offers';

  final Dio _dio;

  const CustomerOffersRemoteDataSource(this._dio);

  Future<List<CustomerOfferSummaryDto>> getMyOffers({
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
      return const <CustomerOfferSummaryDto>[];
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map(CustomerOfferSummaryDto.fromJson)
        .toList(growable: false);
  }
}
