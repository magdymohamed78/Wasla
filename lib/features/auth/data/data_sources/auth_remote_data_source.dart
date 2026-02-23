import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<LoginResponseModel> register(RegisterRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  static const String _loginEndpoint = '/api/customer-portal/login';
  static const String _registerEndpoint = '/api/customer-portal/register';

  const AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final url = '${_dio.options.baseUrl}$_loginEndpoint';
    
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
        
        if (_isErrorResponse(response.data!)) {
          final errorMessage = _extractErrorMessage(response.data!);
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: errorMessage,
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

  @override
  Future<LoginResponseModel> register(RegisterRequestModel request) async {
    final url = '${_dio.options.baseUrl}$_registerEndpoint';
    
    debugPrint('════════════════════════════════════════════════════');
    debugPrint('[AuthRemoteDataSource] REGISTER REQUEST');
    debugPrint('[AuthRemoteDataSource] URL: POST $url');
    debugPrint('[AuthRemoteDataSource] Headers: ${_dio.options.headers}');
    debugPrint('[AuthRemoteDataSource] Body: ${request.toJson()}');
    debugPrint('════════════════════════════════════════════════════');

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _registerEndpoint,
        data: request.toJson(),
      );

      debugPrint('════════════════════════════════════════════════════');
      debugPrint('[AuthRemoteDataSource] REGISTER RESPONSE');
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
        
        if (_isErrorResponse(response.data!)) {
          final errorMessage = _extractErrorMessage(response.data!);
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: errorMessage,
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
        requestOptions: RequestOptions(path: _registerEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Unexpected error: $e',
      );
    }
  }

  bool _isErrorResponse(Map<String, dynamic> data) {
    if (data.containsKey('token') && data['token'] is String) {
      return false;
    }
    
    if (data.containsKey('success') && data['success'] == false) {
      return true;
    }
    
    if (data.containsKey('error') || data.containsKey('errors')) {
      return !data.containsKey('token');
    }
    
    if (data.containsKey('statusCode')) {
      final code = data['statusCode'];
      if (code is int && code >= 400) {
        return true;
      }
    }
    
    return !data.containsKey('token');
  }

  String _extractErrorMessage(Map<String, dynamic> data) {
    return data['message'] as String? ??
        data['error'] as String? ??
        data['errorMessage'] as String? ??
        data['errors']?.toString() ??
        'Unknown error occurred';
  }
}
