import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class SuggestedActionsRow extends StatelessWidget {
  final List<String> actions;
  final ValueChanged<String> onActionTap;

  const SuggestedActionsRow({
    super.key,
    required this.actions,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.spacingXs,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: actions.map((action) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(
                  end: AppDimensions.spacingSm,
                ),
                child: ActionChip(
                  label: Text(
                    action,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.brandRed,
                    ),
                  ),
                  side: const BorderSide(color: AppColors.brandRed),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusXl,
                    ),
                  ),
                  backgroundColor: AppColors.surface,
                  onPressed: () => onActionTap(action),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
