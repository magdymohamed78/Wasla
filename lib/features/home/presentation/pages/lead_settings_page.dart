import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class LeadSettingsPage extends StatelessWidget {
  const LeadSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(localizations.navigationSettings),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingLg),
          child: Text(
            'Lead settings page',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
