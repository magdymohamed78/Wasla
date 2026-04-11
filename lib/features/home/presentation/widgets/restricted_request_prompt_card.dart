import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';

class RestrictedRequestPromptCard extends StatelessWidget {
  final String message;
  final String continueLabel;
  final String cancelLabel;
  final VoidCallback onContinue;
  final VoidCallback onCancel;

  const RestrictedRequestPromptCard({
    super.key,
    required this.message,
    required this.continueLabel,
    required this.cancelLabel,
    required this.onContinue,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        border: Border.all(color: AppColors.brandRed.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.brandRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusRound,
                ),
                border: Border.all(
                  color: AppColors.brandRed.withValues(alpha: 0.18),
                ),
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: AppColors.brandRed,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          PrimaryButton(label: continueLabel, onPressed: onContinue),
          const SizedBox(height: AppDimensions.spacingSm),
          SecondaryButton(label: cancelLabel, onPressed: onCancel),
        ],
      ),
    );
  }
}
