import 'package:flutter/material.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/offer_filter.dart';
import '../../domain/entities/offer_status_counts.dart';

class OfferFilterTabs extends StatelessWidget {
  final OfferFilter activeFilter;
  final OfferStatusCounts counts;
  final ValueChanged<OfferFilter> onFilterChanged;

  const OfferFilterTabs({
    super.key,
    required this.activeFilter,
    required this.counts,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final filters = [
      (filter: OfferFilter.all, label: localizations.offersFilterAll),
      (
        filter: OfferFilter.pending,
        label: localizations.offersFilterPending,
      ),
      (
        filter: OfferFilter.accepted,
        label: localizations.offersFilterAccepted,
      ),
      (
        filter: OfferFilter.rejected,
        label: localizations.offersFilterRejected,
      ),
      (
        filter: OfferFilter.canceled,
        label: localizations.offersFilterCanceled,
      ),
    ];

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingLg),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
          ),
          itemCount: filters.length,
          separatorBuilder: (context, index) =>
              const SizedBox(width: AppDimensions.spacingSm),
          itemBuilder: (context, index) {
            final entry = filters[index];
            final isActive = entry.filter == activeFilter;
            final count = counts.countForFilter(entry.filter);

            return _AnimatedFilterChip(
              label: entry.label,
              count: count,
              isActive: isActive,
              activeColor: OfferFilter.resolveColor(entry.filter),
              onTap: () => onFilterChanged(entry.filter),
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedFilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _AnimatedFilterChip({
    required this.label,
    required this.count,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSm,
          vertical: AppDimensions.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isActive ? activeColor : AppColors.background,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
          border: isActive
              ? null
              : Border.all(color: AppColors.divider, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: AppTypography.bodyMedium.copyWith(
                color: isActive ? AppColors.surface : AppColors.textPrimary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(label),
            ),
            const SizedBox(width: AppDimensions.spacingXs),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXs + 1,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.surface.withValues(alpha: 0.25)
                    : activeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusRound,
                ),
              ),
              child: Text(
                '$count',
                style: AppTypography.bodySmall.copyWith(
                  color: isActive
                      ? AppColors.surface
                      : (count > 0 ? activeColor : AppColors.textSecondary),
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
