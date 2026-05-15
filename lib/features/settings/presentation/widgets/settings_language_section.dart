import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/locale_cubit/locale_cubit.dart';
import '../../../../core/localization/locale_cubit/locale_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class _SettingsLanguageOption {
  final Locale locale;
  final String label;

  const _SettingsLanguageOption({required this.locale, required this.label});
}

const List<_SettingsLanguageOption> _settingsLanguageOptions = [
  _SettingsLanguageOption(locale: Locale('en'), label: 'English'),
  _SettingsLanguageOption(locale: Locale('ar'), label: 'العربية'),
  _SettingsLanguageOption(locale: Locale('de'), label: 'Deutsch'),
  _SettingsLanguageOption(locale: Locale('fr'), label: 'Français'),
  _SettingsLanguageOption(locale: Locale('it'), label: 'Italiano'),
  _SettingsLanguageOption(locale: Locale('es'), label: 'Español'),
];

class SettingsLanguageSection extends StatelessWidget {
  const SettingsLanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Column(
          children: [
            for (final option in _settingsLanguageOptions)
              _LanguageTile(
                icon: Icons.language_rounded,
                label: option.label,
                isSelected:
                    state.locale.languageCode == option.locale.languageCode,
                onTap: () =>
                    context.read<LocaleCubit>().changeLocale(option.locale),
                showDivider:
                    option.locale.languageCode !=
                    _settingsLanguageOptions.last.locale.languageCode,
              ),
          ],
        );
      },
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  const _LanguageTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMd,
              vertical: AppDimensions.paddingSm,
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.brandRed.withOpacity(0.1)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? AppColors.brandRed
                        : AppColors.textSecondary,
                    size: AppDimensions.iconSizeMd,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.brandRed
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.brandRed,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
            child: Divider(height: 1, thickness: 0.5),
          ),
      ],
    );
  }
}
