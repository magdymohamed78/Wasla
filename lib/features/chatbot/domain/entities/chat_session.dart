class ChatSession {
  final String sessionId;
  final String title;
  final DateTime updatedAt;

  const ChatSession({
    required this.sessionId,
    required this.title,
    required this.updatedAt,
  });

  ChatSession copyWith({
    String? sessionId,
    String? title,
    DateTime? updatedAt,
  }) {
    return ChatSession(
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
