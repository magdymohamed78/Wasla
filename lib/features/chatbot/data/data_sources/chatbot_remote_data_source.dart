import 'package:dio/dio.dart';
import '../models/chat_response_dto.dart';

abstract class ChatbotRemoteDataSource {
  Future<ChatResponseDto> sendMessage({
    required String message,
    String? sessionId,
  });
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  static const String _endpoint = '/api/chat';
  final Dio _dio;

  ChatbotRemoteDataSourceImpl(this._dio);

  @override
  Future<ChatResponseDto> sendMessage({
    required String message,
    String? sessionId,
  }) async {
    final data = <String, dynamic>{
      'message': message,
      if (sessionId != null && sessionId.isNotEmpty) 'session_id': sessionId,
    };

    final response = await _dio.post<dynamic>(_endpoint, data: data);

    return ChatResponseDto.fromJson(response.data as Map<String, dynamic>);
  }
}
