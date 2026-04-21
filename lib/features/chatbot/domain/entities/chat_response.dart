import 'chart_data.dart';

class ChatResponse {
  final String responseText;
  final String sessionId;
  final int toolCallsMade;
  final String modelUsed;
  final List<ChartData> charts;

  const ChatResponse({
    required this.responseText,
    required this.sessionId,
    required this.toolCallsMade,
    required this.modelUsed,
    required this.charts,
  });
}
