import 'package:dio/dio.dart';

import '../models/service_request_models.dart';

abstract class ServiceRequestRemoteDataSource {
  Future<CustomerServiceRequestDetailsDto> submitServiceRequest({
    required CreateServiceRequestDto request,
  });
}

class ServiceRequestRemoteDataSourceImpl
    implements ServiceRequestRemoteDataSource {
  static const String _serviceRequestsEndpoint =
      '/api/customer-portal/service-requests';

  final Dio _dio;

  const ServiceRequestRemoteDataSourceImpl(this._dio);

  @override
  Future<CustomerServiceRequestDetailsDto> submitServiceRequest({
    required CreateServiceRequestDto request,
  }) async {
    final response = await _dio.post<dynamic>(
      _serviceRequestsEndpoint,
      data: request.toJson(),
    );

    final body = response.data;
    if (body is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid service request response payload.',
      );
    }

    return CustomerServiceRequestDetailsDto.fromJson(
      Map<String, dynamic>.from(body),
    );
  }
}
