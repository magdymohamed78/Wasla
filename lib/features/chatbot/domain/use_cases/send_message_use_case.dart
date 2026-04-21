import '../entities/chat_response.dart';
import '../repositories/chatbot_repository.dart';

class SendMessageUseCase {
  final ChatbotRepository _repository;

  const SendMessageUseCase(this._repository);

  Future<ChatResponse> call({required String message, String? sessionId}) {
    return _repository.sendMessage(message: message, sessionId: sessionId);
  }
}
