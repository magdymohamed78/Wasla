import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  static const String _loginEndpoint = '/api/customer-portal/login';

  const AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final url = '${_dio.options.baseUrl}${_loginEndpoint}';
    
    debugPrint('════════════════════════════════════════════════════');
    debugPrint('[AuthRemoteDataSource] LOGIN REQUEST');
    debugPrint('[AuthRemoteDataSource] URL: POST $url');
    debugPrint('[AuthRemoteDataSource] Headers: ${_dio.options.headers}');
    debugPrint('[AuthRemoteDataSource] Body: ${request.toJson()}');
    debugPrint('════════════════════════════════════════════════════');

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _loginEndpoint,
        data: request.toJson(),
      );

      debugPrint('════════════════════════════════════════════════════');
      debugPrint('[AuthRemoteDataSource] LOGIN RESPONSE');
      debugPrint('[AuthRemoteDataSource] Status Code: ${response.statusCode}');
      debugPrint('[AuthRemoteDataSource] Data: ${response.data}');
      debugPrint('════════════════════════════════════════════════════');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Empty response body from server',
          );
        }
        return LoginResponseModel.fromJson(response.data!);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Unexpected status code: ${response.statusCode}',
      );
    } on DioException catch (e) {
      debugPrint('════════════════════════════════════════════════════');
      debugPrint('[AuthRemoteDataSource] DIO EXCEPTION');
      debugPrint('[AuthRemoteDataSource] Type: ${e.type}');
      debugPrint('[AuthRemoteDataSource] Message: ${e.message}');
      debugPrint('[AuthRemoteDataSource] Status Code: ${e.response?.statusCode}');
      debugPrint('[AuthRemoteDataSource] Response Data: ${e.response?.data}');
      debugPrint('[AuthRemoteDataSource] Error: ${e.error}');
      debugPrint('════════════════════════════════════════════════════');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('════════════════════════════════════════════════════');
      debugPrint('[AuthRemoteDataSource] UNEXPECTED EXCEPTION: $e');
      debugPrint('[AuthRemoteDataSource] StackTrace: $stackTrace');
      debugPrint('════════════════════════════════════════════════════');
      throw DioException(
        requestOptions: RequestOptions(path: _loginEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Unexpected error: $e',
      );
    }
  }
}
