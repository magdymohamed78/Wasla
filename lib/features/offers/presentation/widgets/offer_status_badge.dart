import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/offer_filter.dart';

/// Reusable status badge that renders the offer status
/// with colors resolved from [OfferFilter.resolveColor].
class OfferStatusBadge extends StatelessWidget {
  final String? status;

  const OfferStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final label = status ?? 'Unknown';
    final filter = OfferFilter.fromQueryValue(status);
    final color = OfferFilter.resolveColor(filter);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
