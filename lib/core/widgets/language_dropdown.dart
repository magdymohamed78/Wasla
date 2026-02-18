import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_dimensions.dart';

class LanguageDropdown extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const LanguageDropdown({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(
        Icons.language,
        color: AppColors.brandRed,
        size: AppDimensions.iconSizeMd,
      ),
      onSelected: onLocaleChanged,
      itemBuilder: (context) => [
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Row(
            children: [
              if (currentLocale.languageCode == 'en')
                const Icon(
                  Icons.check,
                  size: AppDimensions.iconSizeSm,
                  color: AppColors.brandRed,
                ),
              if (currentLocale.languageCode == 'en')
                const SizedBox(width: AppDimensions.spacingSm),
              Text(
                'English',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('ar'),
          child: Row(
            children: [
              if (currentLocale.languageCode == 'ar')
                const Icon(
                  Icons.check,
                  size: AppDimensions.iconSizeSm,
                  color: AppColors.brandRed,
                ),
              if (currentLocale.languageCode == 'ar')
                const SizedBox(width: AppDimensions.spacingSm),
              Text(
                'العربية',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
