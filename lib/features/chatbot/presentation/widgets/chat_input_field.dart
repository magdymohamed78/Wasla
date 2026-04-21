import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class ChatInputField extends StatefulWidget {
  final ValueChanged<String> onSubmitted;
  final bool isLoading;

  const ChatInputField({
    super.key,
    required this.onSubmitted,
    this.isLoading = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isLoading) return;
    widget.onSubmitted(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final hasText = _controller.text.trim().isNotEmpty;
    final canSend = hasText && !widget.isLoading;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.spacingSm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 120),
          decoration: BoxDecoration(
            color: widget.isLoading
                ? AppColors.buttonSecondary.withValues(alpha: 0.4)
                : AppColors.buttonSecondary.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXxl),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  readOnly: widget.isLoading,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSubmit(),
                  style: AppTypography.bodyMedium.copyWith(
                    color: widget.isLoading
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.isLoading
                        ? localizations.chatbotHint
                        : localizations.chatbotHint,
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                      left: AppDimensions.paddingMd,
                      right: AppDimensions.spacingXs,
                      top: AppDimensions.paddingSm + 2,
                      bottom: AppDimensions.paddingSm + 2,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: AppDimensions.spacingSm,
                  bottom: AppDimensions.spacingSm,
                ),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Material(
                    color: canSend ? AppColors.brandRed : AppColors.divider,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusRound,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusRound,
                      ),
                      onTap: canSend ? _handleSubmit : null,
                      child: Icon(
                        Icons.send_rounded,
                        color: canSend ? Colors.white : AppColors.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
