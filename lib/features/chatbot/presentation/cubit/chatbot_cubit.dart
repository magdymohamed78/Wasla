import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_response.dart';
import '../../domain/use_cases/send_message_use_case.dart';
import '../../domain/repositories/chatbot_repository.dart';
import 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final SendMessageUseCase _sendMessageUseCase;
  final ChatbotRepository _repository;

  static const _uuid = Uuid();

  ChatbotCubit({
    required SendMessageUseCase sendMessageUseCase,
    required ChatbotRepository repository,
  }) : _sendMessageUseCase = sendMessageUseCase,
       _repository = repository,
       super(const ChatbotState());

  Future<void> loadSession() async {
    final storedSessionId = _repository.getStoredSessionId();
    final summaries = await _repository.getChatSummaries();

    List<ChatMessage> messages = [];
    if (storedSessionId != null && storedSessionId.isNotEmpty) {
      messages = await _repository.getChatMessages(storedSessionId);
    }

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        sessionId: storedSessionId,
        isSessionLoaded: true,
        chatSummaries: summaries,
        messages: messages,
      ),
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || !state.canSendMessage) return;

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      role: ChatMessageRole.user,
      content: text.trim(),
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...state.messages, userMessage];

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(messages: updatedMessages, isLoading: true, error: null),
    );

    try {
      final ChatResponse response = await _sendMessageUseCase(
        message: text.trim(),
        sessionId: state.sessionId,
      );

      final assistantMessage = ChatMessage(
        id: _uuid.v4(),
        role: ChatMessageRole.assistant,
        content: response.responseText,
        timestamp: DateTime.now(),
        charts: response.charts.isNotEmpty ? response.charts : null,
      );

      final newSessionId = response.sessionId.isNotEmpty
          ? response.sessionId
          : state.sessionId;

      final allMessages = [...updatedMessages, assistantMessage];

      final effectiveSessionId = newSessionId ?? state.sessionId ?? '';
      if (effectiveSessionId.isNotEmpty) {
        final existingTitle = _findTitleForSession(effectiveSessionId);
        final title = existingTitle.isNotEmpty
            ? existingTitle
            : _generateTitle(text.trim());

        await _repository.saveChat(
          sessionId: effectiveSessionId,
          title: title,
          messages: allMessages,
        );

        await _repository.saveSessionId(effectiveSessionId);
      }

      final summaries = await _repository.getChatSummaries();

      if (isClosed) {
        return;
      }

      emit(
        state.copyWith(
          messages: allMessages,
          isLoading: false,
          sessionId: newSessionId ?? state.sessionId,
          chatSummaries: summaries,
        ),
      );
    } catch (e) {
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        role: ChatMessageRole.assistant,
        content: e.toString().replaceAll('ChatbotException: ', ''),
        timestamp: DateTime.now(),
        isError: true,
      );

      await _persistCurrentChat([...updatedMessages, errorMessage]);

      final summaries = await _repository.getChatSummaries();

      if (isClosed) {
        return;
      }

      emit(
        state.copyWith(
          messages: [...updatedMessages, errorMessage],
          isLoading: false,
          error: e.toString(),
          chatSummaries: summaries,
        ),
      );
    }
  }

  Future<void> selectChat(String sessionId) async {
    final messages = await _repository.getChatMessages(sessionId);
    final summaries = await _repository.getChatSummaries();

    if (sessionId.isNotEmpty) {
      await _repository.saveSessionId(sessionId);
    } else {
      await _repository.clearSession();
    }

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        messages: messages,
        sessionId: sessionId.isNotEmpty ? sessionId : null,
        chatSummaries: summaries,
      ),
    );
  }

  Future<void> startNewConversation() async {
    await _persistCurrentChat(state.messages);
    await _repository.clearSession();
    final summaries = await _repository.getChatSummaries();

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        messages: [],
        sessionId: null,
        isLoading: false,
        error: null,
        chatSummaries: summaries,
      ),
    );
  }

  Future<void> deleteChat(String sessionId) async {
    await _repository.deleteChat(sessionId);
    final summaries = await _repository.getChatSummaries();

    if (isClosed) {
      return;
    }

    if (state.sessionId == sessionId) {
      await _repository.clearSession();

      if (isClosed) {
        return;
      }

      emit(
        state.copyWith(messages: [], sessionId: null, chatSummaries: summaries),
      );
    } else {
      emit(state.copyWith(chatSummaries: summaries));
    }
  }

  Future<void> refreshSummaries() async {
    final summaries = await _repository.getChatSummaries();
    if (isClosed) {
      return;
    }
    emit(state.copyWith(chatSummaries: summaries));
  }

  void sendSuggestedAction(String action) {
    sendMessage(action);
  }

  String _generateTitle(String firstMessage) {
    if (firstMessage.length <= 30) return firstMessage;
    return '${firstMessage.substring(0, 30)}...';
  }

  String _findTitleForSession(String? sessionId) {
    if (sessionId == null || sessionId.isEmpty) return '';
    final match = state.chatSummaries.where((s) => s.sessionId == sessionId);
    return match.isNotEmpty ? match.first.title : '';
  }

  Future<void> _persistCurrentChat(List<ChatMessage> messages) async {
    final currentSessionId = state.sessionId;
    if (currentSessionId == null ||
        currentSessionId.isEmpty ||
        messages.isEmpty) {
      return;
    }

    final existingTitle = _findTitleForSession(currentSessionId);
    final title = existingTitle.isNotEmpty
        ? existingTitle
        : _generateTitle(messages.first.content);

    await _repository.saveChat(
      sessionId: currentSessionId,
      title: title,
      messages: messages,
    );
  }
}
