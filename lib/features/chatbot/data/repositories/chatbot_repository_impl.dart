import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_response.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../data_sources/chatbot_remote_data_source.dart';
import '../data_sources/chat_history_local_data_source.dart';
import '../models/chat_response_dto.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  static const String _sessionIdKeyPrefix = 'chatbot_session_id';
  static const String _legacySessionIdKey = 'chatbot_session_id';
  static const String _sessionMigrationFlagKey =
      'chat_session_id_scoped_migrated';

  final ChatbotRemoteDataSource _remote;
  final ChatHistoryLocalDataSource _historyLocal;
  final SharedPreferences _sharedPreferences;
  final String Function() customerIdProvider;

  ChatbotRepositoryImpl({
    required ChatbotRemoteDataSource remote,
    required ChatHistoryLocalDataSource historyLocal,
    required SharedPreferences sharedPreferences,
    required this.customerIdProvider,
  }) : _remote = remote,
       _historyLocal = historyLocal,
       _sharedPreferences = sharedPreferences;

  String get _scopedSessionIdKey {
    final scope = customerIdProvider();
    return '${_sessionIdKeyPrefix}_$scope';
  }

  Future<void> _migrateFromLegacyKey() async {
    final migrated =
        _sharedPreferences.getBool(_sessionMigrationFlagKey) ?? false;
    if (migrated) return;

    final legacyValue = _sharedPreferences.getString(_legacySessionIdKey);
    if (legacyValue != null && legacyValue.isNotEmpty) {
      final scopedKey = _scopedSessionIdKey;
      final existing = _sharedPreferences.getString(scopedKey);
      if (existing == null || existing.isEmpty) {
        await _sharedPreferences.setString(scopedKey, legacyValue);
      }
      await _sharedPreferences.remove(_legacySessionIdKey);
    }

    await _sharedPreferences.setBool(_sessionMigrationFlagKey, true);
  }

  @override
  Future<ChatResponse> sendMessage({
    required String message,
    String? sessionId,
  }) async {
    await _migrateFromLegacyKey();
    final effectiveSessionId =
        sessionId ?? _sharedPreferences.getString(_scopedSessionIdKey);

    try {
      final ChatResponseDto dto = await _remote.sendMessage(
        message: message,
        sessionId: effectiveSessionId,
      );

      if (dto.sessionId.isNotEmpty) {
        await _sharedPreferences.setString(_scopedSessionIdKey, dto.sessionId);
      }

      return dto.toDomain();
    } on DioException catch (e) {
      if (_shouldRetryWithoutAuth(e)) {
        try {
          final fallbackDto = await _remote.sendMessage(
            message: message,
            sessionId: effectiveSessionId,
            skipAuth: true,
          );

          if (fallbackDto.sessionId.isNotEmpty) {
            await _sharedPreferences.setString(
              _scopedSessionIdKey,
              fallbackDto.sessionId,
            );
          }

          return fallbackDto.toDomain();
        } on DioException catch (fallbackError) {
          throw _mapDioException(fallbackError);
        }
      }

      throw _mapDioException(e);
    } catch (e) {
      throw ChatbotException(message: e.toString());
    }
  }

  @override
  String? getStoredSessionId() {
    return _sharedPreferences.getString(_scopedSessionIdKey);
  }

  @override
  Future<void> saveSessionId(String sessionId) async {
    await _sharedPreferences.setString(_scopedSessionIdKey, sessionId);
  }

  @override
  Future<void> clearSession() async {
    await _sharedPreferences.remove(_scopedSessionIdKey);
  }

  @override
  Future<List<ChatSession>> getChatSummaries() {
    return _historyLocal.getChatSummaries();
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String sessionId) {
    return _historyLocal.getChatMessages(sessionId);
  }

  @override
  Future<void> saveChat({
    required String sessionId,
    required String title,
    required List<ChatMessage> messages,
  }) {
    return _historyLocal.saveChat(sessionId, title, messages);
  }

  @override
  Future<void> deleteChat(String sessionId) {
    return _historyLocal.deleteChat(sessionId);
  }

  ChatbotException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ChatbotException(
          message: 'Connection timed out. Please try again.',
        );
      case DioExceptionType.connectionError:
        return const ChatbotException(
          message: 'No internet connection. Please check your network.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final detailMessage = _extractServerMessage(e.response?.data);
        if (statusCode == 401) {
          return const ChatbotException(
            message: 'Session expired. Please sign in again.',
          );
        }
        if (statusCode == 403) {
          return const ChatbotException(
            message: 'Access denied. Please sign in with a valid account.',
          );
        }
        if (statusCode == 503 && detailMessage != null) {
          return ChatbotException(message: detailMessage);
        }
        if (statusCode != null && statusCode >= 500) {
          return ChatbotException(
            message: detailMessage ?? 'Server error. Please try again later.',
          );
        }
        if (detailMessage != null) {
          return ChatbotException(message: detailMessage);
        }
        return const ChatbotException(
          message: 'Something went wrong. Please try again.',
        );
      case DioExceptionType.cancel:
        return const ChatbotException(message: 'Request was cancelled.');
      default:
        return const ChatbotException(message: 'An unexpected error occurred.');
    }
  }

  String? _extractServerMessage(dynamic payload) {
    if (payload == null) {
      return null;
    }

    if (payload is String) {
      final trimmed = payload.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    if (payload is Map<String, dynamic>) {
      final detail = payload['detail']?.toString().trim();
      if (detail != null && detail.isNotEmpty) {
        return detail;
      }

      final message = payload['message']?.toString().trim();
      if (message != null && message.isNotEmpty) {
        return message;
      }

      final error = payload['error']?.toString().trim();
      if (error != null && error.isNotEmpty) {
        return error;
      }
    }

    return null;
  }

  bool _shouldRetryWithoutAuth(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return true;
    }

    if (statusCode == 503) {
      final detail = _extractServerMessage(error.response?.data)?.toLowerCase();
      if (detail != null && detail.contains('authentication failed')) {
        return true;
      }
    }

    return false;
  }
}

class ChatbotException implements Exception {
  final String message;
  const ChatbotException({required this.message});

  @override
  String toString() => message;
}
