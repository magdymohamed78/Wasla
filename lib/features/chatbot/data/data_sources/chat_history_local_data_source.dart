import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';
import '../models/chat_message_dto.dart';
import '../models/chat_session_dto.dart';

abstract class ChatHistoryLocalDataSource {
  Future<List<ChatSession>> getChatSummaries();
  Future<List<ChatMessage>> getChatMessages(String sessionId);
  Future<void> saveChat(
    String sessionId,
    String title,
    List<ChatMessage> messages,
  );
  Future<void> deleteChat(String sessionId);
  Future<void> clearAll();
}

class ChatHistoryLocalDataSourceImpl implements ChatHistoryLocalDataSource {
  static const String _historyKey = 'chatbot_chat_history';
  static const int _maxChats = 20;

  final SharedPreferences _sharedPreferences;

  ChatHistoryLocalDataSourceImpl({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  @override
  Future<List<ChatSession>> getChatSummaries() async {
    final sessions = _loadSessions();
    return sessions.map((dto) => dto.toSummary()).toList();
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String sessionId) async {
    final sessions = _loadSessions();
    final session = sessions.firstWhere(
      (s) => s.sessionId == sessionId,
      orElse: () => ChatSessionDto(
        sessionId: '',
        title: '',
        updatedAt: DateTime.now().toIso8601String(),
        messages: [],
      ),
    );
    if (session.sessionId.isEmpty) return [];
    return session.messages.map((m) => m.toDomain()).toList();
  }

  @override
  Future<void> saveChat(
    String sessionId,
    String title,
    List<ChatMessage> messages,
  ) async {
    final sessions = _loadSessions();
    final messageDtos = messages
        .map((m) => ChatMessageDto.fromDomain(m))
        .toList();
    final updatedAt = messages.isNotEmpty
        ? messages.last.timestamp.toIso8601String()
        : DateTime.now().toIso8601String();

    final existingIndex = sessions.indexWhere((s) => s.sessionId == sessionId);
    final updatedSession = ChatSessionDto(
      sessionId: sessionId,
      title: title,
      updatedAt: updatedAt,
      messages: messageDtos,
    );

    if (existingIndex >= 0) {
      sessions[existingIndex] = updatedSession;
    } else {
      sessions.insert(0, updatedSession);
    }

    if (sessions.length > _maxChats) {
      sessions.removeRange(_maxChats, sessions.length);
    }

    await _saveSessions(sessions);
  }

  @override
  Future<void> deleteChat(String sessionId) async {
    final sessions = _loadSessions();
    sessions.removeWhere((s) => s.sessionId == sessionId);
    await _saveSessions(sessions);
  }

  @override
  Future<void> clearAll() async {
    await _sharedPreferences.remove(_historyKey);
  }

  List<ChatSessionDto> _loadSessions() {
    try {
      final raw = _sharedPreferences.getString(_historyKey);
      if (raw == null || raw.isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList
          .map((e) => ChatSessionDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveSessions(List<ChatSessionDto> sessions) async {
    final jsonList = sessions.map((s) => s.toJson()).toList();
    await _sharedPreferences.setString(_historyKey, jsonEncode(jsonList));
  }
}
