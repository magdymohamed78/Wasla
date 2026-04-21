import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';

class ChatbotState {
  static const Object _unset = Object();

  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final String? sessionId;
  final bool isSessionLoaded;
  final List<ChatSession> chatSummaries;

  const ChatbotState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.sessionId,
    this.isSessionLoaded = false,
    this.chatSummaries = const [],
  });

  bool get canSendMessage => !isLoading;

  bool get hasConversation => messages.isNotEmpty;

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    Object? error = _unset,
    Object? sessionId = _unset,
    bool? isSessionLoaded,
    List<ChatSession>? chatSummaries,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unset) ? this.error : error as String?,
      sessionId: identical(sessionId, _unset)
          ? this.sessionId
          : sessionId as String?,
      isSessionLoaded: isSessionLoaded ?? this.isSessionLoaded,
      chatSummaries: chatSummaries ?? this.chatSummaries,
    );
  }
}
