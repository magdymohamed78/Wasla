import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class SettingsSection extends StatelessWidget {
  final String label;
  final Widget child;
  final bool hasBackgroundCard;

  const SettingsSection({
    super.key,
    required this.label,
    required this.child,
    this.hasBackgroundCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimensions.spacingSm,
            right: AppDimensions.spacingSm,
            bottom: AppDimensions.spacingMd,
            top: AppDimensions.spacingMd,
          ),
          child: Text(
            label.toUpperCase(),
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ),
        if (hasBackgroundCard)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB), // Very faint grey card
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spacingSm,
            ),
            child: child,
          )
        else
          child,
      ],
    );
  }
}
