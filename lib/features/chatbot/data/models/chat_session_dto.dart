import '../../domain/entities/chat_session.dart';
import 'chat_message_dto.dart';

class ChatSessionDto {
  final String sessionId;
  final String title;
  final String updatedAt;
  final List<ChatMessageDto> messages;

  const ChatSessionDto({
    required this.sessionId,
    required this.title,
    required this.updatedAt,
    required this.messages,
  });

  factory ChatSessionDto.fromJson(Map<String, dynamic> json) {
    final messagesRaw = json['messages'] as List<dynamic>? ?? [];

    return ChatSessionDto(
      sessionId: json['session_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      updatedAt:
          json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
      messages: messagesRaw
          .map((e) => ChatMessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'title': title,
      'updated_at': updatedAt,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }

  ChatSession toSummary() {
    return ChatSession(
      sessionId: sessionId,
      title: title,
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }
}
