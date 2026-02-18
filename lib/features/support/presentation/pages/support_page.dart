import 'package:flutter/material.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.supportPageTitle,
          style: AppTypography.heading3,
        ),
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              localizations.supportPageDescription,
              style: AppTypography.bodyLarge,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Container(
              padding: EdgeInsetsDirectional.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    color: AppColors.brandRed,
                    size: AppDimensions.iconSizeMd,
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Text(
                    'support@wasla.com',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.brandRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}