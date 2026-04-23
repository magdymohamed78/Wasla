import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/offer_location.dart';

class OfferLocationCard extends StatelessWidget {
  final OfferLocation location;
  final bool isFirst;
  final bool isLast;
  final bool isConnected;

  const OfferLocationCard({
    super.key,
    required this.location,
    this.isFirst = true,
    this.isLast = true,
    this.isConnected = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isOrigin = location.locationType?.toLowerCase() == 'origin';
    final isDestination = location.locationType?.toLowerCase() == 'destination';

    final iconData = isOrigin
        ? Icons.location_on_outlined
        : isDestination
            ? Icons.flag_outlined
            : Icons.place_outlined;

    final iconColor = isOrigin
        ? AppColors.brandRed
        : isDestination
            ? Colors.blueGrey.shade700
            : AppColors.textSecondary;

    final label = isOrigin
        ? 'FROM (PICKUP)'
        : isDestination
            ? 'TO (DROP-OFF)'
            : location.locationType?.toUpperCase() ?? 'LOCATION';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left timeline column
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: iconColor, width: 1.5),
                  ),
                  child: Center(
                    child: Icon(iconData, size: 12, color: iconColor),
                  ),
                ),
                if (!isLast && isConnected)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: AppColors.brandRed.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right content column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location.displayTitle,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (location.formattedAddress.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    location.formattedAddress,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (location.buildingType != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${l.buildingTypeLabel}: ${location.buildingType}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (location.floor != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${l.floorLabel}: ${location.floor}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (location.hasLift != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${l.elevatorLabel}: ${location.hasLift! ? l.yes : l.no}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                // Add spacing before next card if not last
                if (!isLast) const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
