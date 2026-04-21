import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/chat_message.dart';
import 'chat_chart_widget.dart';
import 'markdown_message_content.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatMessageRole.user;
    final hasCharts = message.charts != null && message.charts!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.spacingXs,
      ),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: isUser
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
                vertical: AppDimensions.paddingSm,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppColors.brandRed : AppColors.surface,
                borderRadius: _buildBorderRadius(isUser, context),
                boxShadow: isUser
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.isError) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 16,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: AppDimensions.spacingXs),
                        Flexible(
                          child: Text(
                            message.content,
                            style: AppTypography.bodySmall.copyWith(
                              color: isUser ? Colors.white : AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (isUser) ...[
                    Text(
                      message.content,
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ] else ...[
                    MarkdownMessageContent(content: message.content),
                  ],
                ],
              ),
            ),
          ),
          if (hasCharts) ...[
            const SizedBox(height: AppDimensions.spacingSm),
            ...message.charts!.map(
              (chart) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingXs),
                child: ChatChartWidget(chartData: chart),
              ),
            ),
          ],
        ],
      ),
    );
  }

  BorderRadius _buildBorderRadius(bool isUser, BuildContext context) {
    const xl = Radius.circular(AppDimensions.borderRadiusXl);
    const small = Radius.circular(4);

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    if (isUser) {
      if (isRtl) {
        return const BorderRadius.only(
          topLeft: xl,
          topRight: xl,
          bottomLeft: small,
          bottomRight: xl,
        );
      }
      return const BorderRadius.only(
        topLeft: xl,
        topRight: xl,
        bottomLeft: xl,
        bottomRight: small,
      );
    }

    if (isRtl) {
      return const BorderRadius.only(
        topLeft: xl,
        topRight: xl,
        bottomLeft: xl,
        bottomRight: small,
      );
    }
    return const BorderRadius.only(
      topLeft: xl,
      topRight: xl,
      bottomLeft: small,
      bottomRight: xl,
    );
  }
}
