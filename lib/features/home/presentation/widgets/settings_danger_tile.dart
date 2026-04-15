import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class SettingsDangerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isLoading;

  const SettingsDangerTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.error, size: AppDimensions.iconSizeMd),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
