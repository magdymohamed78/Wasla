import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/chat_session.dart';

class ChatHistoryDrawer extends StatelessWidget {
  final List<ChatSession> chatSummaries;
  final String? activeSessionId;
  final VoidCallback onNewChat;
  final ValueChanged<String> onSelectChat;
  final ValueChanged<String> onDeleteChat;

  const ChatHistoryDrawer({
    super.key,
    required this.chatSummaries,
    this.activeSessionId,
    required this.onNewChat,
    required this.onSelectChat,
    required this.onDeleteChat,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingMd,
                AppDimensions.paddingMd,
                AppDimensions.paddingSm,
                AppDimensions.spacingSm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      localizations.chatbotHistoryTitle,
                      style: AppTypography.heading3,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onNewChat();
                  },
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text(localizations.chatbotNewChat),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMd,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            const Divider(height: 1, color: AppColors.divider),
            Expanded(
              child: chatSummaries.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingXl,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: AppDimensions.iconSizeXl,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingMd),
                            Text(
                              localizations.chatbotNoHistory,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingSm,
                      ),
                      itemCount: chatSummaries.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 2),
                      itemBuilder: (context, index) {
                        final session = chatSummaries[index];
                        final isActive = session.sessionId == activeSessionId;
                        return _ChatHistoryItem(
                          session: session,
                          isActive: isActive,
                          onTap: () {
                            Navigator.of(context).pop();
                            onSelectChat(session.sessionId);
                          },
                          onDelete: () => onDeleteChat(session.sessionId),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHistoryItem extends StatelessWidget {
  final ChatSession session;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ChatHistoryItem({
    required this.session,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.spacingSm,
        ),
        color: isActive
            ? AppColors.brandRed.withValues(alpha: 0.08)
            : Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isActive
                          ? AppColors.brandRed
                          : AppColors.textPrimary,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(session.updatedAt),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              color: AppColors.textSecondary,
              onPressed: () => _confirmDelete(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            localizations.chatbotDeleteChat,
            style: AppTypography.heading3,
          ),
          content: Text(
            localizations.chatbotDeleteConfirm,
            style: AppTypography.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                MaterialLocalizations.of(context).cancelButtonLabel,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onDelete();
              },
              child: Text(
                localizations.chatbotNewConversation,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
