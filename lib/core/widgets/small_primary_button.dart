import 'package:flutter/material.dart';
import 'package:waslaapp/core/theme/app_colors.dart';
import 'package:waslaapp/core/theme/app_dimensions.dart';
import 'package:waslaapp/core/theme/app_typography.dart';

class SmallPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SmallPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimensions.smallbuttonMinWidth,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.background,
          elevation: 4,
          shadowColor: AppColors.brandRed.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.buttonLabel,
              ),
              if (icon != null) ...[
                const SizedBox(width: 10),
                Icon(
                  icon,
                  size: 22,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
