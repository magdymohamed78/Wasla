import '../../domain/entities/chat_message.dart';
import 'chart_data_dto.dart';

class ChatMessageDto {
  final String id;
  final String role;
  final String content;
  final String timestamp;
  final bool isError;
  final List<ChartDataDto>? charts;

  const ChatMessageDto({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.isError = false,
    this.charts,
  });

  factory ChatMessageDto.fromDomain(ChatMessage message) {
    return ChatMessageDto(
      id: message.id,
      role: message.role.name,
      content: message.content,
      timestamp: message.timestamp.toIso8601String(),
      isError: message.isError,
      charts: message.charts?.map((c) => ChartDataDto.fromDomain(c)).toList(),
    );
  }

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    final chartsRaw = json['charts'] as List<dynamic>?;

    return ChatMessageDto(
      id: json['id'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      content: json['content'] as String? ?? '',
      timestamp:
          json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
      isError: json['isError'] as bool? ?? false,
      charts: chartsRaw
          ?.map((e) => ChartDataDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'content': content,
      'timestamp': timestamp,
      'isError': isError,
      if (charts != null) 'charts': charts!.map((c) => c.toJson()).toList(),
    };
  }

  ChatMessage toDomain() {
    return ChatMessage(
      id: id,
      role: role == 'assistant'
          ? ChatMessageRole.assistant
          : ChatMessageRole.user,
      content: content,
      timestamp: DateTime.tryParse(timestamp) ?? DateTime.now(),
      isError: isError,
      charts: charts?.map((c) => c.toDomain()).toList(),
    );
  }
}
