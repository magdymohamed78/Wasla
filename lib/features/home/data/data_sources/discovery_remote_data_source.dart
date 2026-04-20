import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/discovery_api_models.dart';

abstract class DiscoveryRemoteDataSource {
  Future<List<PublicCompanyListDto>> getAllCompanies({
    required Map<String, dynamic> queryParameters,
  });

  Future<DiscoveryPaginatedDto<RecommendedCompanyDto>> getRecommendedCompanies({
    required Map<String, dynamic> queryParameters,
  });

  Future<DiscoveryPaginatedDto<TrendingCompanyDto>> getTrendingCompanies({
    required Map<String, dynamic> queryParameters,
  });

  Future<PublicCompanyDetailsDto> getCompanyDetails({required int companyId});

  Future<List<CompanyReviewDto>> getCompanyReviews({
    required int companyId,
    required Map<String, dynamic> queryParameters,
  });
}

class DiscoveryRemoteDataSourceImpl implements DiscoveryRemoteDataSource {
  final Dio _dio;

  static const String _companiesEndpoint = '/api/customer-portal/companies';
  static const String _recommendedEndpoint =
      '/api/customer-portal/recommended-companies';
  static const String _trendingEndpoint =
      '/api/customer-portal/trending-companies';

  const DiscoveryRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PublicCompanyListDto>> getAllCompanies({
    required Map<String, dynamic> queryParameters,
  }) async {
    final response = await _dio.get<dynamic>(
      _companiesEndpoint,
      queryParameters: queryParameters,
    );

    final raw = response.data;
    final items = raw is List
        ? raw
        : (raw is Map<String, dynamic>
              ? (raw['items'] ?? raw['data'] ?? raw['results'])
              : null);

    if (items is! List) {
      return const <PublicCompanyListDto>[];
    }

    final companies = items
        .whereType<Map<String, dynamic>>()
        .map(PublicCompanyListDto.fromJson)
        .toList(growable: false);

    _debugLogLogoUrls(source: 'all-companies', companies: companies);

    return companies;
  }

  @override
  Future<DiscoveryPaginatedDto<RecommendedCompanyDto>> getRecommendedCompanies({
    required Map<String, dynamic> queryParameters,
  }) async {
    final response = await _dio.get<dynamic>(
      _recommendedEndpoint,
      queryParameters: queryParameters,
    );

    final page = DiscoveryPaginatedDto<RecommendedCompanyDto>.fromJson(
      response.data,
      RecommendedCompanyDto.fromJson,
    );

    _debugLogLogoUrls(
      source: 'recommended-companies',
      companies: page.items.map((item) => item.base),
    );

    return page;
  }

  @override
  Future<DiscoveryPaginatedDto<TrendingCompanyDto>> getTrendingCompanies({
    required Map<String, dynamic> queryParameters,
  }) async {
    final response = await _dio.get<dynamic>(
      _trendingEndpoint,
      queryParameters: queryParameters,
    );

    final page = DiscoveryPaginatedDto<TrendingCompanyDto>.fromJson(
      response.data,
      TrendingCompanyDto.fromJson,
    );

    _debugLogLogoUrls(
      source: 'trending-companies',
      companies: page.items.map((item) => item.base),
    );

    return page;
  }

  @override
  Future<PublicCompanyDetailsDto> getCompanyDetails({
    required int companyId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_companiesEndpoint/$companyId',
    );
    final data = response.data ?? const <String, dynamic>{};
    return PublicCompanyDetailsDto.fromJson(data);
  }

  @override
  Future<List<CompanyReviewDto>> getCompanyReviews({
    required int companyId,
    required Map<String, dynamic> queryParameters,
  }) async {
    final response = await _dio.get<dynamic>(
      '$_companiesEndpoint/$companyId/reviews',
      queryParameters: queryParameters,
    );

    final raw = response.data;
    final items = raw is List
        ? raw
        : (raw is Map<String, dynamic>
              ? (raw['items'] ?? raw['data'] ?? raw['results'])
              : null);

    if (items is! List) {
      return const <CompanyReviewDto>[];
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map(CompanyReviewDto.fromJson)
        .toList(growable: false);
  }

  void _debugLogLogoUrls({
    required String source,
    required Iterable<PublicCompanyListDto> companies,
  }) {
    if (!kDebugMode) {
      return;
    }

    for (final company in companies) {
      debugPrint(
        '[LogoDebug][$source] Company "${company.companyName}": '
        'logoUrl = ${company.companyLogoUrl}',
      );
    }
  }
}
