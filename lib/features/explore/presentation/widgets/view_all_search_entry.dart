import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class ViewAllSearchEntry extends StatelessWidget {
  final String hintText;
  final VoidCallback onTap;

  const ViewAllSearchEntry({
    super.key,
    required this.hintText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: AppColors.surface.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: AppColors.textSecondary),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  hintText,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Icon(Icons.tune_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
