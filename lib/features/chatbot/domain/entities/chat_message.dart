import 'chart_data.dart';

enum ChatMessageRole { user, assistant }

class ChatMessage {
  final String id;
  final ChatMessageRole role;
  final String content;
  final DateTime timestamp;
  final List<ChartData>? charts;
  final List<String>? suggestedActions;
  final bool isError;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.charts,
    this.suggestedActions,
    this.isError = false,
  });

  ChatMessage copyWith({
    String? id,
    ChatMessageRole? role,
    String? content,
    DateTime? timestamp,
    List<ChartData>? charts,
    List<String>? suggestedActions,
    bool? isError,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      charts: charts ?? this.charts,
      suggestedActions: suggestedActions ?? this.suggestedActions,
      isError: isError ?? this.isError,
    );
  }
}
