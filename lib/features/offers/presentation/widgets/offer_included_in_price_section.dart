import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

/// Distinct visual container showing included-in-price text content (FR-015).
class OfferIncludedInPriceSection extends StatelessWidget {
  final String? includedInPrice;

  const OfferIncludedInPriceSection({super.key, this.includedInPrice});

  @override
  Widget build(BuildContext context) {
    if (includedInPrice == null || includedInPrice!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        border: Border.all(color: Colors.teal.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 20,
            color: Colors.teal.shade600,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              includedInPrice!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
