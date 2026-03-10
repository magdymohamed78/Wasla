import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

class ToastUtils {
  ToastUtils._();

  static void showSuccess(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: const Color(
        0xFF2E7D32,
      ), // visually distinct success color
      icon: Icons.check_circle_outline_rounded,
      action: action,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
      action: action,
    );
  }

  static void _showToast({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppDimensions.paddingMd),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.paddingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
          ),
          backgroundColor: backgroundColor,
          elevation: 6,
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: AppDimensions.iconSizeMd),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          action: action,
          duration: const Duration(seconds: 4),
        ),
      );
  }
}
