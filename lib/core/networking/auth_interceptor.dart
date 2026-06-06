import 'dart:async';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import '../routing/app_router.dart';
import '../../features/auth/data/models/refresh_token_request_model.dart';
import '../../features/auth/data/models/refresh_token_response_model.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

class AuthInterceptor extends QueuedInterceptorsWrapper {
  final String _baseUrl;
  AuthRepository? _authRepository;
  late final Dio _refreshDio;

  Future<bool>? _refreshInFlight;

  static const String _refreshAttemptedKey = 'auth_refresh_attempted';
  static const String _refreshTokenEndpoint = '/api/customer-portal/refresh-token';
  static const List<String> _noRefreshEndpoints = <String>[
    '/api/customer-portal/login',
    '/api/customer-portal/register',
    _refreshTokenEndpoint,
    '/api/customer-portal/logout',
  ];

  AuthInterceptor({required String baseUrl}) : _baseUrl = baseUrl {
    _refreshDio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
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
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    if (!_isRecoverableAuthFailure(statusCode)) {
      handler.next(err);
      return;
    }

    if (_shouldSkipRefresh(err.requestOptions)) {
      handler.next(err);
      return;
    }

    if (_authRepository == null) {
      handler.next(err);
      return;
    }

    final authReason = _resolveAuthReason(
      requestOptions: err.requestOptions,
      statusCode: statusCode,
    );

    final alreadyAttempted =
        err.requestOptions.extra[_refreshAttemptedKey] == true;
    if (alreadyAttempted) {
      await _fallbackToGuest(authReason: authReason);
      handler.next(err);
      return;
    }

    final refreshSucceeded = await _refreshAccessToken();
    if (!refreshSucceeded) {
      await _fallbackToGuest(authReason: authReason);
      handler.next(err);
      return;
    }

    try {
      final retryResponse = await _retryWithFreshToken(err.requestOptions);
      handler.resolve(retryResponse);
    } catch (_) {
      await _fallbackToGuest(authReason: authReason);
      handler.next(err);
    }
  }

  bool _isRecoverableAuthFailure(int? statusCode) {
    return statusCode == 401 || statusCode == 403;
  }

  String _resolveAuthReason({
    required RequestOptions requestOptions,
    required int? statusCode,
  }) {
    final path = requestOptions.path.toLowerCase();
    final isCustomerPortalMyEndpoint = path.contains(
      '/api/customer-portal/my/',
    );

    if (statusCode == 403 && isCustomerPortalMyEndpoint) {
      return AppRouter.authReasonUpgradeRelogin;
    }

    return AppRouter.authReasonSessionExpired;
  }

  bool _shouldSkipRefresh(RequestOptions requestOptions) {
    final path = requestOptions.path.toLowerCase();
    return _noRefreshEndpoints.any(path.contains);
  }

  Future<bool> _refreshAccessToken() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    final completer = Completer<bool>();
    _refreshInFlight = completer.future;
    _performRefresh(completer);
    return _refreshInFlight!;
  }

  Future<void> _performRefresh(Completer<bool> completer) async {
    try {
      final refreshToken = await _authRepository!.getStoredRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        completer.complete(false);
        return;
      }

      // Use the interceptor-free client so QueuedInterceptorsWrapper cannot
      // deadlock while this handler is still awaiting refresh.
      final response = await _refreshDio.post<Map<String, dynamic>>(
        _refreshTokenEndpoint,
        data: RefreshTokenRequestModel(refreshToken: refreshToken).toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        completer.complete(false);
        return;
      }

      final payload = response.data;
      if (payload == null) {
        completer.complete(false);
        return;
      }

      final refreshedSession =
          RefreshTokenResponseModel.fromJson(payload).toEntity();

      await _authRepository!.updateStoredSession(
        refreshedSession,
        isRefresh: true,
      );

      completer.complete(true);
    } catch (_) {
      completer.complete(false);
    } finally {
      _refreshInFlight = null;
    }
  }

  Future<Response<dynamic>> _retryWithFreshToken(
    RequestOptions requestOptions,
  ) async {
    final token = await _authRepository?.getStoredAccessToken();

    final headers = Map<String, dynamic>.from(requestOptions.headers);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final extra = Map<String, dynamic>.from(requestOptions.extra);
    extra[_refreshAttemptedKey] = true;

    final options = Options(
      method: requestOptions.method,
      headers: headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      followRedirects: requestOptions.followRedirects,
      validateStatus: requestOptions.validateStatus,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      extra: extra,
    );

    return _refreshDio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
      cancelToken: requestOptions.cancelToken,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
    );
  }

  Future<void> _fallbackToGuest({required String authReason}) async {
    final hadAccessToken =
        (await _authRepository?.getStoredAccessToken())?.isNotEmpty == true;
    await _authRepository?.clearSession(preservePendingIntent: true);

    if (!hadAccessToken) {
      return;
    }

    final context = AppRouter.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      context.go(AppRouter.loginLocation(authReason: authReason));
    }
  }
}
