import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';

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
    final languageText = currentLocale.languageCode == 'ar' ? 'AR' : 'EN';
    
    return GestureDetector(
      onTap: () => _showLanguageDialog(context),
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: AppDimensions.paddingSm,
          vertical: AppDimensions.spacingXs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.language,
              color: AppColors.brandRed,
              size: AppDimensions.iconSizeMd,
            ),
            const SizedBox(width: AppDimensions.spacingXs),
            Text(
              languageText,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          ),
          contentPadding: EdgeInsetsDirectional.symmetric(
            vertical: AppDimensions.paddingMd,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LanguageOption(
                label: 'English',
                isSelected: currentLocale.languageCode == 'en',
                onTap: () {
                  onLocaleChanged(const Locale('en'));
                  Navigator.of(dialogContext).pop();
                },
              ),
              const Divider(height: AppDimensions.spacingSm),
              _LanguageOption(
                label: 'العربية',
                isSelected: currentLocale.languageCode == 'ar',
                onTap: () {
                  onLocaleChanged(const Locale('ar'));
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        child: Row(
          children: [
            if (isSelected)
              const Icon(
                Icons.check,
                color: AppColors.brandRed,
                size: AppDimensions.iconSizeMd,
              )
            else
              const SizedBox(width: AppDimensions.iconSizeMd),
            SizedBox(width: isSelected ? AppDimensions.spacingSm : 0),
            Text(
              label,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.brandRed : AppColors.textPrimary,
              ),
            ),
          ],
        ),
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
