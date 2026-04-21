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
    try {
      final effectiveSessionId =
          sessionId ?? _sharedPreferences.getString(_scopedSessionIdKey);

      final ChatResponseDto dto = await _remote.sendMessage(
        message: message,
        sessionId: effectiveSessionId,
      );

      if (dto.sessionId.isNotEmpty) {
        await _sharedPreferences.setString(_scopedSessionIdKey, dto.sessionId);
      }

      return dto.toDomain();
    } on DioException catch (e) {
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
        if (statusCode == 401) {
          return const ChatbotException(
            message: 'Session expired. Please sign in again.',
          );
        }
        if (statusCode != null && statusCode >= 500) {
          return const ChatbotException(
            message: 'Server error. Please try again later.',
          );
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
}

class ChatbotException implements Exception {
  final String message;
  const ChatbotException({required this.message});

  @override
  String toString() => message;
}
