import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class CompanyReviewActionPanel extends StatelessWidget {
  final bool isEligibilityLoading;
  final bool canWriteReview;
  final bool showNotConnectedInfo;
  final bool isSubmitting;
  final String writeReviewLabel;
  final String submittingMessage;
  final String infoMessage;
  final String viewProfileLabel;
  final VoidCallback onWriteReview;
  final VoidCallback onViewProfile;

  const CompanyReviewActionPanel({
    super.key,
    required this.isEligibilityLoading,
    required this.canWriteReview,
    required this.showNotConnectedInfo,
    required this.isSubmitting,
    required this.writeReviewLabel,
    required this.submittingMessage,
    required this.infoMessage,
    required this.viewProfileLabel,
    required this.onWriteReview,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    if (isEligibilityLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingSm),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.85)),
        ),
        child: const LinearProgressIndicator(
          minHeight: 2,
          color: AppColors.brandRed,
          backgroundColor: AppColors.buttonSecondary,
        ),
      );
    }

    if (canWriteReview) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onWriteReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandRed,
                foregroundColor: AppColors.surface,
                disabledBackgroundColor: AppColors.brandRed.withValues(
                  alpha: 0.6,
                ),
                disabledForegroundColor: AppColors.surface.withValues(
                  alpha: 0.7,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusLg,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingSm,
                ),
              ),
              child: isSubmitting
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.surface.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingSm),
                        Text(
                          writeReviewLabel,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.surface.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      writeReviewLabel,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          if (isSubmitting) ...[
            const SizedBox(height: AppDimensions.spacingSm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSm,
                vertical: AppDimensions.paddingXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.brandRed.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusSm,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.hourglass_top_rounded,
                    size: AppDimensions.iconSizeSm,
                    color: AppColors.brandRed,
                  ),
                  const SizedBox(width: AppDimensions.spacingXs),
                  Flexible(
                    child: Text(
                      submittingMessage,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.brandRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }

    if (showNotConnectedInfo) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.buttonSecondary.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              infoMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onViewProfile,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.brandRed,
                  textStyle: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Text(viewProfileLabel),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
