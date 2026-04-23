import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/offer_service_line_item.dart';

/// Card for a single service line item with dynamic detail fields.
///
/// Renders known service detail keys with i18n labels,
/// boolean fields as Yes/No, hides null fields. Additional costs listed below.
class OfferServiceLineItemCard extends StatelessWidget {
  final OfferServiceLineItem item;

  const OfferServiceLineItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final formatter = NumberFormat('#,##0.00');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table headers
          Row(
            children: [
              Expanded(
                child: Text(
                  l.serviceHeader,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                l.costHeader,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Values
          Row(
            children: [
              Expanded(
                child: Text(
                  item.serviceType ?? l.unknownService,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${formatter.format(item.totalLinePrice)} ${l.currencyEgp}',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.brandRed,
                ),
              ),
            ],
          ),
          // Service details
          if (item.serviceDetails != null &&
              item.serviceDetails!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildServiceDetails(context, item.serviceDetails!, l),
          ],
          // Additional costs
          if (item.additionalCosts.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Text(
              l.additionalCostsLabel,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            ...item.additionalCosts.map(
              (cost) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        cost.description ?? '-',
                        style: AppTypography.bodySmall,
                      ),
                    ),
                    Text(
                      '${formatter.format(cost.price)} ${l.currencyEgp}',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceDetails(
    BuildContext context,
    Map<String, dynamic> details,
    AppLocalizations l,
  ) {
    // Known keys with their localized labels
    final knownKeys = <String, String>{
      'cleaningType': l.cleaningTypeLabel,
      'durationHours': l.durationHoursLabel,
      'numberOfStaff': l.numberOfStaffLabel,
      'fillNailHoles': l.fillNailHolesLabel,
      'withHighPressureCleaner': l.highPressureCleanerLabel,
      'cleaningDate': l.cleaningDateLabel,
      'cleaningStartTime': l.cleaningStartTimeLabel,
      'deliveryDate': l.deliveryDateLabel,
      'deliveryTime': l.deliveryTimeLabel,
      'discount': l.discountLabel,
    };

    final entries = <MapEntry<String, String>>[];
    for (final key in knownKeys.keys) {
      final value = details[key];
      if (value == null) continue;

      String displayValue;
      if (value is bool) {
        displayValue = value ? l.yes : l.no;
      } else {
        displayValue = value.toString();
      }
      entries.add(MapEntry(knownKeys[key]!, displayValue));
    }

    if (entries.isEmpty) return const SizedBox.shrink();

    // Two-column layout for compact fields
    final rows = <Widget>[];
    for (var i = 0; i < entries.length; i += 2) {
      if (i + 1 < entries.length) {
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _DetailField(entry: entries[i])),
              const SizedBox(width: 12),
              Expanded(child: _DetailField(entry: entries[i + 1])),
            ],
          ),
        );
      } else {
        rows.add(_DetailField(entry: entries[i]));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final row in rows) ...[
          row,
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _DetailField extends StatelessWidget {
  final MapEntry<String, String> entry;

  const _DetailField({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.key.toUpperCase(),
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          entry.value,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
