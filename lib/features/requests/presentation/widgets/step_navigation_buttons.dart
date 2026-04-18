import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class StepNavigationButtons extends StatelessWidget {
  final bool showBack;
  final bool showExit;
  final bool isLastStep;
  final bool isSubmitting;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback? onExit;

  const StepNavigationButtons({
    super.key,
    this.showBack = false,
    this.showExit = false,
    this.isLastStep = false,
    this.isSubmitting = false,
    required this.onBack,
    required this.onNext,
    this.onExit,
  }) : assert(!showExit || onExit != null);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    if (isLastStep) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.spacingMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: AppColors.background,
                  disabledBackgroundColor: AppColors.brandRed.withValues(
                    alpha: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.background,
                        ),
                      )
                    : Text(
                        localizations.newRequestButtonSubmit,
                        style: AppTypography.buttonLabel,
                      ),
              ),
            ),
            if (showBack) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: OutlinedButton(
                  onPressed: isSubmitting ? null : onBack,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.brandRed,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMd,
                      ),
                    ),
                  ),
                  child: Text(
                    localizations.newRequestButtonBack,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.brandRed,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.spacingMd,
      ),
      child: Row(
        children: [
          if (showBack || showExit)
            Expanded(
              child: SizedBox(
                height: AppDimensions.buttonHeight,
                child: OutlinedButton(
                  onPressed: isSubmitting ? null : (showBack ? onBack : onExit),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.brandRed,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMd,
                      ),
                    ),
                  ),
                  child: Text(
                    showBack
                        ? localizations.newRequestButtonBack
                        : localizations.restrictionCancel,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.brandRed,
                    ),
                  ),
                ),
              ),
            ),
          if (showBack || showExit)
            const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: SizedBox(
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: AppColors.background,
                  disabledBackgroundColor: AppColors.brandRed.withValues(
                    alpha: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.background,
                        ),
                      )
                    : Text(
                        localizations.newRequestButtonNext,
                        style: AppTypography.buttonLabel,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
