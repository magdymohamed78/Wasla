import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      ),
      title: Text(localizations.settingsLogoutAllConfirmTitle),
      content: Text(localizations.settingsLogoutAllConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(localizations.settingsLogoutAllCancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandRed,
            foregroundColor: AppColors.surface,
          ),
          child: Text(localizations.settingsLogoutAllConfirm),
        ),
      ],
    );
  }

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const LogoutConfirmationDialog(),
    );
  }
}
