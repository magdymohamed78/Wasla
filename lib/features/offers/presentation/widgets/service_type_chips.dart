import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Displays service types as a wrapping row of chips.
///
/// Splits [serviceTypeOverall] by comma or semicolon
/// and renders each as a styled chip.
class ServiceTypeChips extends StatelessWidget {
  final String? serviceTypeOverall;

  const ServiceTypeChips({super.key, this.serviceTypeOverall});

  @override
  Widget build(BuildContext context) {
    if (serviceTypeOverall == null || serviceTypeOverall!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final types = serviceTypeOverall!
        .split(RegExp(r'[,;]'))
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    if (types.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: types.map((type) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.brandRed.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            type,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.brandRed,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
