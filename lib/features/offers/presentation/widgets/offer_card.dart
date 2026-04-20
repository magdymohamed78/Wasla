import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/company_logo_widget.dart';
import '../../domain/entities/offer_filter.dart';
import '../../domain/entities/offer_summary_item.dart';

class OfferCard extends StatelessWidget {
  final OfferSummaryItem offer;
  final VoidCallback onTap;

  const OfferCard({super.key, required this.offer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = OfferFilter.resolveColor(offer.normalizedFilter);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: statusColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeaderRow(offer: offer, statusColor: statusColor),
                        if (offer.serviceTypeOverall != null &&
                            offer.serviceTypeOverall!.isNotEmpty) ...[
                          const SizedBox(height: AppDimensions.spacingXs),
                          _ServiceTypeChip(label: offer.serviceTypeOverall!),
                        ],
                        const SizedBox(height: AppDimensions.spacingMd),
                        const Divider(color: AppColors.divider, height: 1),
                        const SizedBox(height: AppDimensions.spacingSm),
                        _BottomRow(offer: offer),
                      ],
                    ),
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

class _HeaderRow extends StatelessWidget {
  final OfferSummaryItem offer;
  final Color statusColor;

  const _HeaderRow({required this.offer, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompanyLogoWidget(logoUrl: offer.companyLogoUrl),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offer.companyName ?? 'Company #${offer.companyId}',
                style: AppTypography.heading3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (offer.offerNumber != null) ...[
                const SizedBox(height: 2),
                Text(
                  offer.offerNumber!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        _StatusBadge(label: offer.status ?? '', color: statusColor),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: AppDimensions.spacingXs + 1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ServiceTypeChip extends StatelessWidget {
  final String label;

  const _ServiceTypeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: AppDimensions.spacingXs + 1,
      ),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _BottomRow extends StatelessWidget {
  final OfferSummaryItem offer;

  const _BottomRow({required this.offer});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final dateLabel = offer.isAccepted
        ? localizations.offersAcceptDate
        : localizations.offersIssueDate;
    final dateValue = _formatDate(context, offer.displayDate);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.offersTotalAmount,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              if (offer.hasDiscount) ...[
                Text(
                  '\$${(offer.totalAmount + offer.discountAmount).toStringAsFixed(2)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 1),
              ],
              Text(
                '\$${offer.totalAmount.toStringAsFixed(2)}',
                style: AppTypography.heading3.copyWith(
                  color: offer.hasDiscount ? AppColors.brandRed : null,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              dateLabel,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppDimensions.iconSizeSm - 2,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.spacingXs),
                Text(dateValue, style: AppTypography.bodyMedium),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) {
      return AppLocalizations.of(context).requestDetailsNotAvailable;
    }
    return DateFormat(
      'd/M/yyyy',
      Localizations.localeOf(context).languageCode,
    ).format(date);
  }
}
