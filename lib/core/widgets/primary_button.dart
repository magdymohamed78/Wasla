import 'package:flutter/material.dart';
import 'package:waslaapp/core/theme/app_colors.dart';
import 'package:waslaapp/core/theme/app_dimensions.dart';
import 'package:waslaapp/core/theme/app_typography.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon; // 👈 اختياري
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.background,
          elevation: 4,
          shadowColor: AppColors.brandRed.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) ...[
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.background,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(label, style: AppTypography.buttonLabel),
            if (!isLoading && icon != null) ...[
              const SizedBox(width: 10),
              Icon(icon, size: 22),
            ],
          ],
        ),
      ),
    );
  }
}
