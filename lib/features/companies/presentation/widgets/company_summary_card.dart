import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/company_summary.dart';
import '../../../home/domain/entities/discovery_types.dart';

class CompanySummaryCard extends StatelessWidget {
  final CompanySummary company;
  final bool showTrendIndicator;
  final double? cardWidth;
  final int? maxServiceTags;
  final VoidCallback? onTap;

  const CompanySummaryCard({
    super.key,
    required this.company,
    this.showTrendIndicator = false,
    this.cardWidth,
    this.maxServiceTags,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final displayName = company.companyName.trim().isEmpty
        ? localizations.companyDetailsUnknownCompany
        : company.companyName.trim();
    final hasReviews =
        company.averageRating != null && (company.reviewCount ?? 0) > 0;
    final locationText = _locationText();

    final allServices = company.serviceTypes;
    final truncated =
        maxServiceTags != null && allServices.length > maxServiceTags!;
    final visibleServices = truncated
        ? allServices.sublist(0, maxServiceTags!)
        : allServices;
    final remainingCount = truncated ? allServices.length - maxServiceTags! : 0;

    return SizedBox(
      width: cardWidth,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
          onTap:
              onTap ??
              () => context.push(AppRouter.companyLocation(company.companyId)),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CompanyLogo(url: company.companyLogoUrl),
                      const SizedBox(width: AppDimensions.spacingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    displayName,
                                    style: AppTypography.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (showTrendIndicator &&
                                    company.trendDirection != null) ...[
                                  const SizedBox(
                                    width: AppDimensions.spacingXs,
                                  ),
                                  Flexible(
                                    child: _TrendBadge(
                                      direction: company.trendDirection!,
                                      delta: company.improvementDelta,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: AppDimensions.spacingXs),
                            Row(
                              children: [
                                if (locationText != null) ...[
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: AppDimensions.iconSizeSm,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(
                                    width: AppDimensions.spacingXs,
                                  ),
                                  Expanded(
                                    child: Text(
                                      locationText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ] else
                                  const Spacer(),
                                const SizedBox(width: AppDimensions.spacingSm),
                                const Icon(
                                  Icons.star_rounded,
                                  size: AppDimensions.iconSizeSm,
                                  color: Color(0xFFFFB300),
                                ),
                                const SizedBox(width: AppDimensions.spacingXs),
                                Text(
                                  hasReviews
                                      ? '${company.averageRating!.toStringAsFixed(1)} (${company.reviewCount})'
                                      : localizations.homeNoReviewsYet,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (allServices.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.spacingSm),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.divider,
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                    Wrap(
                      spacing: AppDimensions.spacingXs,
                      runSpacing: AppDimensions.spacingXs,
                      children: [
                        ...visibleServices.map((s) => _ServiceTag(label: s)),
                        if (remainingCount > 0) _MoreTag(count: remainingCount),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _locationText() {
    final city = company.city?.trim();
    final country = company.country?.trim();

    if (city != null &&
        city.isNotEmpty &&
        country != null &&
        country.isNotEmpty) {
      return '$city, $country';
    }
    if (city != null && city.isNotEmpty) {
      return city;
    }
    if (country != null && country.isNotEmpty) {
      return country;
    }
    return null;
  }
}

class _CompanyLogo extends StatelessWidget {
  final String? url;

  const _CompanyLogo({this.url});

  @override
  Widget build(BuildContext context) {
    const size = 56.0;

    if (url != null && url!.trim().isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        child: CachedNetworkImage(
          imageUrl: url!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => _PlaceholderLogo(size: size),
        ),
      );
    }

    return _PlaceholderLogo(size: size);
  }
}

class _PlaceholderLogo extends StatelessWidget {
  final double size;

  const _PlaceholderLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.buttonSecondary,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      ),
      child: Icon(
        Icons.business_rounded,
        size: size * 0.45,
        color: AppColors.textSecondary.withValues(alpha: 0.5),
      ),
    );
  }
}

class _ServiceTag extends StatelessWidget {
  final String label;

  const _ServiceTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXs,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.buttonSecondary,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodySmall,
      ),
    );
  }
}

class _MoreTag extends StatelessWidget {
  final int count;

  const _MoreTag({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXs,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.brandRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
      ),
      child: Text(
        '+$count',
        maxLines: 1,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.brandRed,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final TrendDirection direction;
  final double? delta;

  const _TrendBadge({required this.direction, this.delta});

  @override
  Widget build(BuildContext context) {
    final icon = switch (direction) {
      TrendDirection.improving => Icons.trending_up_rounded,
      TrendDirection.declining => Icons.trending_down_rounded,
      TrendDirection.neutral => Icons.trending_flat_rounded,
    };

    final color = switch (direction) {
      TrendDirection.improving => const Color(0xFF2E7D32),
      TrendDirection.declining => const Color(0xFFC62828),
      TrendDirection.neutral => AppColors.textSecondary,
    };

    final label = delta == null
        ? ''
        : '${delta! > 0 ? '+' : ''}${delta!.toStringAsFixed(1)}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXs,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconSizeSm, color: color),
          if (label.isNotEmpty) ...[
            const SizedBox(width: AppDimensions.spacingXs),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
