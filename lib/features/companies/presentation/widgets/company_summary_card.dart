import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

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
  final VoidCallback? onTap;

  const CompanySummaryCard({
    super.key,
    required this.company,
    this.showTrendIndicator = false,
    this.cardWidth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final hasLogo =
        company.companyLogoUrl != null &&
        company.companyLogoUrl!.trim().isNotEmpty;
    final hasReviews =
        company.averageRating != null && (company.reviewCount ?? 0) > 0;
    final displayName = company.companyName.trim().isEmpty
        ? localizations.companyDetailsUnknownCompany
        : company.companyName.trim();
    final locationText = _locationText();
    final cardSemanticLabel = _buildCardSemanticLabel(
      companyName: displayName,
      locationText: locationText,
      hasReviews: hasReviews,
      rating: company.averageRating,
      reviewCount: company.reviewCount,
      noReviewsLabel: localizations.homeNoReviewsYet,
    );

    return Semantics(
      button: true,
      label: cardSemanticLabel,
      child: SizedBox(
        width: cardWidth ?? 250,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : (cardWidth ?? 250);
            final hasBoundedHeight = constraints.maxHeight.isFinite;
            final maxHeight = constraints.maxHeight;
            final isCompactWidth = maxWidth <= 190;
            final isCompactHeight = hasBoundedHeight && maxHeight <= 230;
            final isCompact = isCompactWidth || isCompactHeight;
            final contentPadding = hasBoundedHeight && maxHeight <= 220
                ? AppDimensions.paddingXs
                : AppDimensions.paddingSm;
            final sectionSpacing = isCompact
                ? AppDimensions.spacingXs
                : AppDimensions.spacingSm;

            final maxVisibleServices = isCompact ? 1 : 2;
            final visibleServices = company.serviceTypes
                .take(maxVisibleServices)
                .toList(growable: false);
            final canShowLocation =
                locationText != null && (!hasBoundedHeight || maxHeight > 170);
            final canShowServices =
                visibleServices.isNotEmpty &&
                (!hasBoundedHeight || maxHeight > 210);

            final imageAspectRatio = isCompact ? 1.85 : 1.65;
            final idealImageHeight = maxWidth / imageAspectRatio;
            final cappedImageHeight = hasBoundedHeight
                ? maxHeight * (isCompact ? 0.34 : 0.4)
                : idealImageHeight;
            var imageHeight = idealImageHeight > cappedImageHeight
                ? cappedImageHeight
                : idealImageHeight;
            if (imageHeight < 56 && cappedImageHeight >= 56) {
              imageHeight = 56;
            }

            final chipsAvailableWidth = (maxWidth - (contentPadding * 2))
                .clamp(0.0, double.infinity)
                .toDouble();
            final rawServiceChipMaxWidth = maxVisibleServices == 1
                ? chipsAvailableWidth
                : (chipsAvailableWidth - AppDimensions.spacingXs) / 2;
            final serviceChipMaxWidth = rawServiceChipMaxWidth > 0
                ? rawServiceChipMaxWidth
                : chipsAvailableWidth;

            final content = Padding(
              padding: EdgeInsets.all(contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: hasBoundedHeight
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          maxLines: isCompact ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (showTrendIndicator &&
                          company.trendDirection != null) ...[
                        const SizedBox(width: AppDimensions.spacingXs),
                        _TrendBadge(
                          direction: company.trendDirection!,
                          delta: company.improvementDelta,
                        ),
                      ],
                    ],
                  ),
                  if (canShowLocation) ...[
                    SizedBox(height: AppDimensions.spacingXs),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: AppDimensions.iconSizeSm,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimensions.spacingXs),
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
                      ],
                    ),
                  ],
                  SizedBox(height: sectionSpacing),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: AppDimensions.iconSizeSm,
                        color: Color(0xFFFFB300),
                      ),
                      const SizedBox(width: AppDimensions.spacingXs),
                      Expanded(
                        child: Text(
                          hasReviews
                              ? '${company.averageRating!.toStringAsFixed(1)} (${company.reviewCount})'
                              : localizations.homeNoReviewsYet,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (canShowServices) ...[
                    SizedBox(height: sectionSpacing),
                    if (hasBoundedHeight)
                      Flexible(
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            spacing: AppDimensions.spacingXs,
                            runSpacing: AppDimensions.spacingXs,
                            children: visibleServices
                                .map(
                                  (service) => _ServiceTag(
                                    label: service,
                                    maxWidth: serviceChipMaxWidth,
                                  ),
                                )
                                .toList(growable: false),
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: AppDimensions.spacingXs,
                        runSpacing: AppDimensions.spacingXs,
                        children: visibleServices
                            .map(
                              (service) => _ServiceTag(
                                label: service,
                                maxWidth: serviceChipMaxWidth,
                              ),
                            )
                            .toList(growable: false),
                      ),
                  ],
                ],
              ),
            );

            return Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusLg,
                ),
                onTap:
                    onTap ??
                    () => context.push(
                      AppRouter.companyLocation(company.companyId),
                    ),
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusLg,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: hasBoundedHeight
                        ? MainAxisSize.max
                        : MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(
                            AppDimensions.borderRadiusLg,
                          ),
                          topRight: Radius.circular(
                            AppDimensions.borderRadiusLg,
                          ),
                        ),
                        child: SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: hasLogo
                              ? CachedNetworkImage(
                                  imageUrl: company.companyLogoUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (_, _) =>
                                      const _LogoLoadingPlaceholder(),
                                  errorWidget: (_, _, _) =>
                                      const _LogoPlaceholder(),
                                )
                              : const _LogoPlaceholder(),
                        ),
                      ),
                      if (hasBoundedHeight)
                        Expanded(child: content)
                      else
                        content,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _buildCardSemanticLabel({
    required String companyName,
    required String? locationText,
    required bool hasReviews,
    required double? rating,
    required int? reviewCount,
    required String noReviewsLabel,
  }) {
    final segments = <String>[companyName];
    if (locationText != null && locationText.isNotEmpty) {
      segments.add(locationText);
    }

    if (hasReviews && rating != null) {
      segments.add('${rating.toStringAsFixed(1)} (${reviewCount ?? 0})');
    } else {
      segments.add(noReviewsLabel);
    }

    return segments.join(' • ');
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

class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.buttonSecondary,
      alignment: Alignment.center,
      child: Icon(
        Icons.business_rounded,
        size: AppDimensions.iconSizeLg,
        color: AppColors.textSecondary.withValues(alpha: 0.4),
      ),
    );
  }
}

class _LogoLoadingPlaceholder extends StatelessWidget {
  const _LogoLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.buttonSecondary.withValues(alpha: 0.5),
      highlightColor: AppColors.surface,
      child: const ColoredBox(color: AppColors.surface),
    );
  }
}

class _ServiceTag extends StatelessWidget {
  final String label;
  final double maxWidth;

  const _ServiceTag({required this.label, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
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
          softWrap: false,
          style: AppTypography.bodySmall,
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
