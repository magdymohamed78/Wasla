import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

/// Card showing the discount / savings amount.
/// Only rendered when [discountAmount] > 0.
class OfferSavingsCard extends StatelessWidget {
  final double discountAmount;

  const OfferSavingsCard({super.key, required this.discountAmount});

  @override
  Widget build(BuildContext context) {
    if (discountAmount <= 0) return const SizedBox.shrink();

    final l = AppLocalizations.of(context);
    final formatter = NumberFormat('#,##0.00');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.brandRed,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.offerSavingsLabel.toUpperCase(),
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            '-${formatter.format(discountAmount)} ${l.currencyEgp}',
            style: AppTypography.heading1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          const Icon(
            Icons.local_activity,
            color: Colors.white24,
            size: AppDimensions.iconSizeMd,
          ),
        ],
      ),
    );
  }
}
