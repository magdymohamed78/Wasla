import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/locale_cubit/locale_cubit.dart';
import '../../../../core/localization/locale_cubit/locale_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class SettingsLanguageSection extends StatelessWidget {
  const SettingsLanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Column(
          children: [
            _LanguageRadioTile(
              label: 'English',
              isSelected: state.locale.languageCode == 'en',
              onTap: () =>
                  context.read<LocaleCubit>().changeLocale(const Locale('en')),
            ),
            Divider(
              color: AppColors.divider,
              height: 1,
              indent:
                  AppDimensions.paddingMd +
                  AppDimensions.iconSizeMd +
                  AppDimensions.spacingMd,
            ),
            _LanguageRadioTile(
              label: 'العربية',
              isSelected: state.locale.languageCode == 'ar',
              onTap: () =>
                  context.read<LocaleCubit>().changeLocale(const Locale('ar')),
            ),
          ],
        );
      },
    );
  }
}

class _LanguageRadioTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageRadioTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Radio<String>(
              value: label,
              groupValue: isSelected ? label : '',
              onChanged: (_) => onTap(),
              activeColor: AppColors.brandRed,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
