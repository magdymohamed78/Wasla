import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

/// Card displaying the offer total amount with optional
/// VAT Included and Insurance Covered badges.
class OfferTotalCard extends StatelessWidget {
  final double totalAmount;
  final bool? costsIncludeVAT;
  final String? insurance;

  const OfferTotalCard({
    super.key,
    required this.totalAmount,
    this.costsIncludeVAT,
    this.insurance,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final formatter = NumberFormat('#,##0.00');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),

      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.borderRadiusXl),
        ),
        color: AppColors.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.offerTotalLabel.toUpperCase(),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formatter.format(totalAmount),
                style: AppTypography.heading1.copyWith(
                  color: AppColors.brandRed,
                  fontWeight: FontWeight.w800,
                  fontSize: 36,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                l.currencyEgp,
                style: AppTypography.heading3.copyWith(
                  color: AppColors.brandRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (costsIncludeVAT == true)
                _Badge(
                  label: l.vatIncluded.toUpperCase(),
                  icon: Icons.check_circle_outline,
                ),
              if (insurance != null && insurance!.isNotEmpty)
                _Badge(
                  label: l.insuranceCovered.toUpperCase(),
                  icon: Icons.shield_outlined,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _Badge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.brandRed),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
