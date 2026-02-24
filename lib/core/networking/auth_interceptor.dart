import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import '../routing/app_router.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

class AuthInterceptor extends QueuedInterceptorsWrapper {
  final String _baseUrl;
  AuthRepository? _authRepository;
  late final Dio _refreshDio;
  
  int _consecutive401Count = 0;
  bool _isRefreshing = false;

  AuthInterceptor({required String baseUrl}) : _baseUrl = baseUrl {
    _refreshDio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));
  }

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
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _consecutive401Count = 0;
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    if (_authRepository == null) {
      handler.next(err);
      return;
    }

    _consecutive401Count++;

    if (_consecutive401Count <= 3) {
      try {
        final retryResponse = await _retry(err.requestOptions);
        handler.resolve(retryResponse);
        return;
      } catch (e) {
        handler.next(err);
        return;
      }
    }

    if (_isRefreshing) {
      handler.next(err);
      return;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _authRepository!.getStoredRefreshToken();
      
      if (refreshToken == null || refreshToken.isEmpty) {
        await _forceLogout();
        handler.next(err);
        return;
      }

      final newSession = await _authRepository!.refreshToken(
        refreshToken: refreshToken,
      );

      await _authRepository!.saveAccessToken(newSession.token);
      await _authRepository!.saveRefreshTokenData(
        newSession.refreshToken,
        newSession.refreshTokenExpiry,
      );

      _consecutive401Count = 0;
      _isRefreshing = false;

      final retryResponse = await _retry(err.requestOptions);
      handler.resolve(retryResponse);
    } on DioException catch (e) {
      _isRefreshing = false;
      
      if (_isAuthError(e)) {
        await _forceLogout();
      }
      handler.next(err);
    } catch (e) {
      _isRefreshing = false;
      handler.next(err);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final token = await _authRepository?.getStoredAccessToken();
    
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      },
    );

    return _refreshDio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  bool _isAuthError(DioException e) {
    final statusCode = e.response?.statusCode;
    return statusCode == 401 || statusCode == 403;
  }

  Future<void> _forceLogout() async {
    await _authRepository?.clearSession();
    
    final context = AppRouter.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      context.go('/login');
    }
  }
}
