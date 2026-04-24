import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';

class DashboardMetricCard extends StatefulWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const DashboardMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  State<DashboardMetricCard> createState() => _DashboardMetricCardState();
}

class _DashboardMetricCardState extends State<DashboardMetricCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: _isPressed ? 0.97 : 1,
      curve: Curves.easeOut,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
          onTap: widget.onTap,
          onTapDown: widget.onTap == null
              ? null
              : (_) => setState(() => _isPressed = true),
          onTapCancel: widget.onTap == null
              ? null
              : () => setState(() => _isPressed = false),
          onTapUp: widget.onTap == null
              ? null
              : (_) => setState(() => _isPressed = false),
          child: Ink(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.surface,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.iconColor.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: AppDimensions.iconSizeMd,
                  ),
                ),
                const Spacer(),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    '${widget.value}',
                    style: AppTypography.heading2.copyWith(height: 1),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Text(
                  widget.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
