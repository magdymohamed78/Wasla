import 'package:dio/dio.dart';

import '../models/customer_portal_models.dart';

class ProfileRemoteDataSource {
  static const String _profileEndpoint = '/api/customer-portal/my/profile';
  static const String _leadProfileEndpoint =
      '/api/customer-portal/my/lead-profile';

  final Dio _dio;

  const ProfileRemoteDataSource(this._dio);

  Future<CustomerProfileDto> getMyProfile() async {
    final response = await _dio.get<dynamic>(_profileEndpoint);
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

  Future<LeadProfileDto> getMyLeadProfile() async {
    final response = await _dio.get<dynamic>(_leadProfileEndpoint);
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

  Future<CustomerProfileDto> updateMyProfile({
    required UpdateCustomerProfileDto payload,
  }) async {
    final response = await _dio.put<dynamic>(
      _profileEndpoint,
      data: payload.toJson(),
    );
    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid customer profile update response payload.',
      );
    }

    return CustomerProfileDto.fromJson(body);
  }

  Future<LeadProfileDto> updateMyLeadProfile({
    required UpdateCustomerProfileDto payload,
  }) async {
    final response = await _dio.put<dynamic>(
      _leadProfileEndpoint,
      data: payload.toJson(),
    );
    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid lead profile update response payload.',
      );
    }

    return LeadProfileDto.fromJson(body);
  }
}
