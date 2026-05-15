import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';

class _LanguageChoice {
  final Locale locale;
  final String label;
  final String shortLabel;

  const _LanguageChoice({
    required this.locale,
    required this.label,
    required this.shortLabel,
  });
}

const List<_LanguageChoice> _languageChoices = [
  _LanguageChoice(locale: Locale('en'), label: 'English', shortLabel: 'EN'),
  _LanguageChoice(locale: Locale('ar'), label: 'العربية', shortLabel: 'AR'),
  _LanguageChoice(locale: Locale('de'), label: 'Deutsch', shortLabel: 'DE'),
  _LanguageChoice(locale: Locale('fr'), label: 'Français', shortLabel: 'FR'),
  _LanguageChoice(locale: Locale('it'), label: 'Italiano', shortLabel: 'IT'),
  _LanguageChoice(locale: Locale('es'), label: 'Español', shortLabel: 'ES'),
];

class OnboardingHeader extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback? onSupportTap;

  const OnboardingHeader({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
    this.onSupportTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: AppDimensions.paddingMd,
        end: AppDimensions.paddingMd,
        top: AppDimensions.paddingMd,
        bottom: AppDimensions.paddingMd,
      ),
      child: Row(
        children: [
          _LanguageSelector(
            currentLocale: currentLocale,
            onLocaleChanged: onLocaleChanged,
          ),
          const Spacer(),
          _SupportButton(onTap: onSupportTap),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const _LanguageSelector({
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedChoice = _languageChoices.firstWhere(
      (choice) => choice.locale.languageCode == currentLocale.languageCode,
      orElse: () => _languageChoices.first,
    );

    return PopupMenuButton<Locale>(
      onSelected: onLocaleChanged,
      color: AppColors.surface,
      elevation: 10,
      offset: const Offset(0, AppDimensions.spacingSm),
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        side: BorderSide(color: AppColors.divider.withValues(alpha: 0.7)),
      ),
      itemBuilder: (context) => _languageChoices.map((choice) {
        final isSelected =
            currentLocale.languageCode == choice.locale.languageCode;

        return PopupMenuItem<Locale>(
          value: choice.locale,
          padding: EdgeInsets.zero,
          height: 52,
          child: _LanguageMenuItem(choice: choice, isSelected: isSelected),
        );
      }).toList(),
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: AppDimensions.paddingSm,
          vertical: AppDimensions.spacingSm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.75)),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.brandRed.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.language,
                color: AppColors.brandRed,
                size: AppDimensions.iconSizeSm,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Text(
              selectedChoice.shortLabel,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingXs),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
              size: AppDimensions.iconSizeSm,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageMenuItem extends StatelessWidget {
  final _LanguageChoice choice;
  final bool isSelected;

  const _LanguageMenuItem({required this.choice, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.spacingSm,
      ),
      color: isSelected
          ? AppColors.brandRed.withValues(alpha: 0.06)
          : AppColors.surface,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.brandRed : AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
            ),
            child: Text(
              choice.shortLabel,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected ? AppColors.surface : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Text(
              choice.label,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected ? AppColors.brandRed : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.brandRed,
              size: AppDimensions.iconSizeSm,
            )
          else
            const SizedBox(width: AppDimensions.iconSizeSm),
        ],
      ),
    );
  }
}

class _SupportButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _SupportButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.iconSizeXl,
        height: AppDimensions.iconSizeXl,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.support_agent_rounded,
          color: AppColors.brandRed,
          size: AppDimensions.iconSizeMd,
        ),
      ),
    );
  }
}
