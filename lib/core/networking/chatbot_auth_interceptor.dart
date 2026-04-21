import 'package:dio/dio.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';

class ChatbotAuthInterceptor extends Interceptor {
  AuthRepository? _authRepository;

  ChatbotAuthInterceptor();

  void setAuthRepository(AuthRepository authRepository) {
    _authRepository = authRepository;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_authRepository != null) {
      final token = await _authRepository!.getStoredAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = token;
      }
    }
    handler.next(options);
  }
}
