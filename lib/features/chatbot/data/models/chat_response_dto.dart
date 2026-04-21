import '../../domain/entities/chat_response.dart';
import '../utils/chart_table_extractor.dart';
import 'chart_data_dto.dart';

class ChatResponseDto {
  final String responseText;
  final String sessionId;
  final int toolCallsMade;
  final String modelUsed;
  final List<ChartDataDto> charts;

  const ChatResponseDto({
    required this.responseText,
    required this.sessionId,
    required this.toolCallsMade,
    required this.modelUsed,
    required this.charts,
  });

  factory ChatResponseDto.fromJson(Map<String, dynamic> json) {
    final chartsRaw = json['charts'] as List<dynamic>? ?? [];
    final responseText = json['response'] as String? ?? '';

    final chartDtos = chartsRaw
        .map((e) => ChartDataDto.fromJson(e as Map<String, dynamic>))
        .toList();

    if (chartDtos.isEmpty && responseText.contains('|')) {
      final extracted = ChartTableExtractor.extractChartsFromMarkdown(
        responseText,
      );
      chartDtos.addAll(extracted.map((c) => ChartDataDto.fromDomain(c)));
    }

    return ChatResponseDto(
      responseText: responseText,
      sessionId: json['session_id'] as String? ?? '',
      toolCallsMade: json['tool_calls_made'] as int? ?? 0,
      modelUsed: json['model_used'] as String? ?? '',
      charts: chartDtos,
    );
  }

  ChatResponse toDomain() {
    return ChatResponse(
      responseText: responseText,
      sessionId: sessionId,
      toolCallsMade: toolCallsMade,
      modelUsed: modelUsed,
      charts: charts.map((c) => c.toDomain()).toList(),
    );
  }
}
