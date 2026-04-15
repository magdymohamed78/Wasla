import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class SignatureBox extends StatelessWidget {
  final String? signatureText;
  final bool isRevealed;
  final bool isLocked;
  final String? errorMessage;
  final VoidCallback onTap;

  const SignatureBox({
    super.key,
    this.signatureText,
    required this.isRevealed,
    required this.isLocked,
    this.errorMessage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm),
      child: Material(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: isLocked ? null : onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isRevealed && signatureText != null) ...[
                  SelectableText(
                    signatureText!,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  _CopyButton(
                    signatureText: signatureText!,
                    localizations: localizations,
                  ),
                ] else ...[
                  Text(
                    '• • • • • • • •',
                    style: AppTypography.heading1.copyWith(
                      color: AppColors.brandRed,
                      letterSpacing: 4,
                      height: 1.0, // Removes extra vertical padding on font
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (isLocked && errorMessage != null) ...[
                  const SizedBox(height: AppDimensions.spacingMd),
                  Text(
                    errorMessage!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  final String signatureText;
  final AppLocalizations localizations;

  const _CopyButton({required this.signatureText, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: signatureText));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.settingsSignatureCopied),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSm,
          vertical: AppDimensions.spacingXs,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.copy_rounded,
              size: AppDimensions.iconSizeSm,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppDimensions.spacingXs),
            Text(
              localizations.settingsSignatureCopied,
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
