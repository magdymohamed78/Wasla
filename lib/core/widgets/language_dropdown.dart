import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

class _LanguageMenuOption {
  final Locale locale;
  final String label;

  const _LanguageMenuOption({required this.locale, required this.label});
}

const List<_LanguageMenuOption> _languageMenuOptions = [
  _LanguageMenuOption(locale: Locale('en'), label: 'English'),
  _LanguageMenuOption(locale: Locale('ar'), label: 'العربية'),
  _LanguageMenuOption(locale: Locale('de'), label: 'Deutsch'),
  _LanguageMenuOption(locale: Locale('fr'), label: 'Français'),
  _LanguageMenuOption(locale: Locale('it'), label: 'Italiano'),
  _LanguageMenuOption(locale: Locale('es'), label: 'Español'),
];

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
      itemBuilder: (context) => _languageMenuOptions.map((option) {
        final isSelected =
            currentLocale.languageCode == option.locale.languageCode;

        return PopupMenuItem<Locale>(
          value: option.locale,
          child: Row(
            children: [
              if (isSelected)
                const Icon(
                  Icons.check,
                  size: AppDimensions.iconSizeSm,
                  color: AppColors.brandRed,
                ),
              if (isSelected) const SizedBox(width: AppDimensions.spacingSm),
              Text(option.label, style: AppTypography.bodyMedium),
            ],
          ),
        );
      }).toList(),
    );
  }
}
