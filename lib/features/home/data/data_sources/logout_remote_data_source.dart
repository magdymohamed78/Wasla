import 'package:dio/dio.dart';

class LogoutRemoteDataSource {
  static const String _logoutEndpoint = '/api/customer-portal/logout';
  static const String _logoutAllEndpoint = '/api/customer-portal/logout-all';

  final Dio _dio;

  const LogoutRemoteDataSource(this._dio);

  Future<void> logout() async {
    await _dio.post<dynamic>(_logoutEndpoint);
  }

  Future<void> logoutAll() async {
    await _dio.post<dynamic>(_logoutAllEndpoint);
  }
}
