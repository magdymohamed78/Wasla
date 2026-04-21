import '../entities/chat_message.dart';
import '../entities/chat_response.dart';
import '../entities/chat_session.dart';

abstract class ChatbotRepository {
  Future<ChatResponse> sendMessage({
    required String message,
    String? sessionId,
  });

  String? getStoredSessionId();

  Future<void> saveSessionId(String sessionId);

  Future<void> clearSession();

  Future<List<ChatSession>> getChatSummaries();

  Future<List<ChatMessage>> getChatMessages(String sessionId);

  Future<void> saveChat({
    required String sessionId,
    required String title,
    required List<ChatMessage> messages,
  });

  Future<void> deleteChat(String sessionId);
}
