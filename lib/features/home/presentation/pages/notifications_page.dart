import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(localizations.notificationsPageTitle),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Text(
            localizations.notificationsPagePlaceholderMessage,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
