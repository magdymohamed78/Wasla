import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/company_details.dart';

class CompanyDetailsHeaderSection extends StatelessWidget {
  final String companyName;
  final String unknownCompanyLabel;
  final String? companyLogoUrl;
  final double? averageRating;
  final int reviewCount;
  final String locationLine;
  final String noReviewsLabel;

  const CompanyDetailsHeaderSection({
    super.key,
    required this.companyName,
    required this.unknownCompanyLabel,
    required this.companyLogoUrl,
    required this.averageRating,
    required this.reviewCount,
    required this.locationLine,
    required this.noReviewsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final hasLogo = companyLogoUrl != null && companyLogoUrl!.isNotEmpty;
    final hasReviews = averageRating != null && reviewCount > 0;
    final displayName = companyName.trim().isEmpty
        ? unknownCompanyLabel
        : companyName.trim();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
              child: SizedBox(
                width: 72,
                height: 72,
                child: hasLogo
                    ? CachedNetworkImage(
                        imageUrl: companyLogoUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, _) =>
                            const _CompanyLogoPlaceholder(icon: Icons.image),
                        errorWidget: (_, _, _) =>
                            const _CompanyLogoPlaceholder(),
                      )
                    : const _CompanyLogoPlaceholder(),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: AppTypography.heading3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (locationLine.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      locationLine,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimensions.spacingSm),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB300),
                        size: AppDimensions.iconSizeMd,
                      ),
                      const SizedBox(width: AppDimensions.spacingXs),
                      Expanded(
                        child: Text(
                          hasReviews
                              ? '${averageRating!.toStringAsFixed(1)} ($reviewCount)'
                              : noReviewsLabel,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyContactSection extends StatelessWidget {
  final String title;
  final String contactEmail;
  final String phoneNumber;
  final String addressLine;
  final String locationLine;
  final String emptyMessage;

  const CompanyContactSection({
    super.key,
    required this.title,
    required this.contactEmail,
    required this.phoneNumber,
    required this.addressLine,
    required this.locationLine,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    if (contactEmail.isNotEmpty) {
      rows.add(_ContactRow(icon: Icons.email_rounded, value: contactEmail));
    }
    if (phoneNumber.isNotEmpty) {
      rows.add(_ContactRow(icon: Icons.phone_rounded, value: phoneNumber));
    }
    if (addressLine.isNotEmpty) {
      rows.add(_ContactRow(icon: Icons.home_rounded, value: addressLine));
    }
    if (locationLine.isNotEmpty) {
      rows.add(
        _ContactRow(icon: Icons.location_on_rounded, value: locationLine),
      );
    }

    return _SectionCard(
      title: title,
      child: rows.isEmpty
          ? Text(
              emptyMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          : Column(
              children: rows
                  .map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spacingSm,
                      ),
                      child: row,
                    ),
                  )
                  .toList(growable: false),
            ),
    );
  }
}

class CompanyServicesSection extends StatelessWidget {
  final String title;
  final List<CompanyServiceItem> services;
  final String emptyMessage;

  const CompanyServicesSection({
    super.key,
    required this.title,
    required this.services,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return _SectionCard(
        title: title,
        child: Text(
          emptyMessage,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return _SectionCard(
      title: title,
      child: Column(
        children: services
            .map(
              (service) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                child: _ServiceTile(service: service),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class CompanyReviewsSection extends StatelessWidget {
  final String title;
  final List<CompanyReviewItem> reviews;
  final String emptyMessage;
  final String anonymousReviewerLabel;
  final String noCommentLabel;
  final String loadMoreLabel;
  final String retryLabel;
  final bool hasMoreReviews;
  final bool isLoadingMoreReviews;
  final String? errorMessage;
  final VoidCallback onLoadMore;

  const CompanyReviewsSection({
    super.key,
    required this.title,
    required this.reviews,
    required this.emptyMessage,
    required this.anonymousReviewerLabel,
    required this.noCommentLabel,
    required this.loadMoreLabel,
    required this.retryLabel,
    required this.hasMoreReviews,
    required this.isLoadingMoreReviews,
    required this.errorMessage,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return _SectionCard(
        title: title,
        child: Text(
          emptyMessage,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return _SectionCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...reviews.map(
            (review) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
              child: _ReviewTile(
                review: review,
                anonymousReviewerLabel: anonymousReviewerLabel,
                noCommentLabel: noCommentLabel,
              ),
            ),
          ),
          if (errorMessage != null) ...[
            Text(
              errorMessage!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
          ],
          if (hasMoreReviews)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: isLoadingMoreReviews ? null : onLoadMore,
                icon: isLoadingMoreReviews
                    ? const SizedBox(
                        width: AppDimensions.iconSizeSm,
                        height: AppDimensions.iconSizeSm,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.expand_more_rounded),
                label: Text(errorMessage == null ? loadMoreLabel : retryLabel),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
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
          children: [
            Text(title, style: AppTypography.heading3),
            const SizedBox(height: AppDimensions.spacingSm),
            child,
          ],
        ),
      ),
    );
  }
}

class _CompanyLogoPlaceholder extends StatelessWidget {
  final IconData icon;

  const _CompanyLogoPlaceholder({this.icon = Icons.business_rounded});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.buttonSecondary,
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.textSecondary),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _ContactRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppDimensions.iconSizeSm,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(child: Text(value, style: AppTypography.bodyMedium)),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final CompanyServiceItem service;

  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final pricingLabel = _pricingLabel(service);
    final serviceName = service.name.trim().isEmpty
        ? localizations.companyDetailsUnnamedService
        : service.name.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            serviceName,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (service.description != null) ...[
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              service.description!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (pricingLabel != null) ...[
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              pricingLabel,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String? _pricingLabel(CompanyServiceItem service) {
    final suffix = service.pricingUnit == null
        ? ''
        : ' ${service.pricingUnit!}';

    if (service.indicativePriceFrom != null &&
        service.indicativePriceTo != null) {
      return '${_formatPrice(service.indicativePriceFrom!)} - ${_formatPrice(service.indicativePriceTo!)}$suffix';
    }

    if (service.price != null) {
      return '${_formatPrice(service.price!)}$suffix';
    }

    if (service.indicativePriceFrom != null) {
      return '${_formatPrice(service.indicativePriceFrom!)}$suffix';
    }

    if (service.indicativePriceTo != null) {
      return '${_formatPrice(service.indicativePriceTo!)}$suffix';
    }

    return null;
  }

  String _formatPrice(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }
}

class _ReviewTile extends StatelessWidget {
  final CompanyReviewItem review;
  final String anonymousReviewerLabel;
  final String noCommentLabel;

  const _ReviewTile({
    required this.review,
    required this.anonymousReviewerLabel,
    required this.noCommentLabel,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = review.customerName?.trim().isNotEmpty == true
        ? review.customerName!.trim()
        : anonymousReviewerLabel;
    final displayComment = review.comment?.trim().isNotEmpty == true
        ? review.comment!.trim()
        : noCommentLabel;
    final dateLabel = review.createdAt == null
        ? null
        : _formatDate(context, review.createdAt!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  displayName,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (review.rating != null) ...[
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFB300),
                  size: AppDimensions.iconSizeSm,
                ),
                const SizedBox(width: AppDimensions.spacingXs),
                Text(
                  review.rating!.toStringAsFixed(1),
                  style: AppTypography.bodyMedium,
                ),
              ],
            ],
          ),
          if (dateLabel != null) ...[
            const SizedBox(height: AppDimensions.spacingXs),
            Text(dateLabel, style: AppTypography.bodySmall),
          ],
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            displayComment,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final localDate = date.toLocal();
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(localDate);
  }
}
