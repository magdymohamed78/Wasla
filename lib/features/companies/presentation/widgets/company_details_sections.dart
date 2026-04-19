import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/company_details.dart';

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

    return _SectionCard(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
            child: SizedBox(
              width: 80,
              height: 80,
              child: hasLogo
                  ? CachedNetworkImage(
                      imageUrl: companyLogoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          const _CompanyLogoPlaceholder(icon: Icons.image),
                      errorWidget: (_, _, _) => const _CompanyLogoPlaceholder(),
                    )
                  : const _CompanyLogoPlaceholder(),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            displayName,
            style: AppTypography.heading3,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (locationLine.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingXs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: AppDimensions.iconSizeSm,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.spacingXs),
                Flexible(
                  child: Text(
                    locationLine,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppDimensions.spacingXs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFB300),
                size: AppDimensions.iconSizeMd,
              ),
              const SizedBox(width: AppDimensions.spacingXs),
              Text(
                hasReviews
                    ? '${averageRating!.toStringAsFixed(1)} ($reviewCount)'
                    : noReviewsLabel,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
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
    final items = <_ContactItem>[];

    if (contactEmail.isNotEmpty) {
      items.add(_ContactItem(icon: Icons.email_rounded, value: contactEmail));
    }
    if (phoneNumber.isNotEmpty) {
      items.add(_ContactItem(icon: Icons.phone_rounded, value: phoneNumber));
    }
    if (addressLine.isNotEmpty) {
      items.add(_ContactItem(icon: Icons.home_rounded, value: addressLine));
    }
    if (locationLine.isNotEmpty) {
      items.add(
        _ContactItem(icon: Icons.location_on_rounded, value: locationLine),
      );
    }

    return _SectionCard(
      title: title,
      child: items.isEmpty
          ? Text(
              emptyMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          : Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  _ContactRow(item: items[i]),
                  if (i < items.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.divider,
                    ),
                ],
              ],
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
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
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
  final String viewAllLabel;
  final Widget? headerAction;
  final Widget? actionContent;
  final int? maxReviews;
  final VoidCallback? onViewAll;

  const CompanyReviewsSection({
    super.key,
    required this.title,
    required this.reviews,
    required this.emptyMessage,
    required this.anonymousReviewerLabel,
    required this.noCommentLabel,
    required this.viewAllLabel,
    this.headerAction,
    this.actionContent,
    this.maxReviews,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final displayReviews = maxReviews != null && reviews.length > maxReviews!
        ? reviews.sublist(0, maxReviews!)
        : reviews;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(title, style: AppTypography.heading3)),
              if (headerAction != null) ...[
                const SizedBox(width: AppDimensions.spacingSm),
                headerAction!,
              ],
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          if (actionContent != null) ...[
            actionContent!,
            const SizedBox(height: AppDimensions.spacingMd),
          ],
          if (displayReviews.isEmpty)
            Text(
              emptyMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else
            ...displayReviews.map(
              (review) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                child: _ReviewTile(
                  review: review,
                  anonymousReviewerLabel: anonymousReviewerLabel,
                  noCommentLabel: noCommentLabel,
                ),
              ),
            ),
          if (onViewAll != null && displayReviews.isNotEmpty)
            Center(
              child: TextButton.icon(
                onPressed: onViewAll,
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: AppColors.brandRed,
                ),
                label: Text(
                  viewAllLabel,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.brandRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _SectionCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          children: [
            if (title != null) ...[
              Text(title!, style: AppTypography.heading3),
              const SizedBox(height: AppDimensions.spacingMd),
            ],
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
      child: Icon(icon, color: AppColors.textSecondary, size: 36),
    );
  }
}

class _ContactItem {
  final IconData icon;
  final String value;

  const _ContactItem({required this.icon, required this.value});
}

class _ContactRow extends StatelessWidget {
  final _ContactItem item;

  const _ContactRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.brandRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
            ),
            child: Icon(
              item.icon,
              size: AppDimensions.iconSizeSm,
              color: AppColors.brandRed,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Center(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(item.value, style: AppTypography.bodyMedium),
              ),
            ),
          ),
        ],
      ),
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

class ReviewTile extends StatelessWidget {
  final CompanyReviewItem review;
  final String anonymousReviewerLabel;
  final String noCommentLabel;

  const ReviewTile({
    super.key,
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
    final initial = _avatarInitial(displayName, anonymousReviewerLabel);

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
              _ReviewAvatar(initial: initial, isAnonymous: initial == '?'),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (dateLabel != null)
                      Text(dateLabel, style: AppTypography.bodySmall),
                  ],
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
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
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

  String _avatarInitial(String displayName, String anonymousLabel) {
    if (displayName == anonymousLabel) return '?';
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed[0].toUpperCase();
  }

  String _formatDate(BuildContext context, DateTime date) {
    final localDate = date.toLocal();
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(localDate);
  }
}

class _ReviewTile extends ReviewTile {
  const _ReviewTile({
    required super.review,
    required super.anonymousReviewerLabel,
    required super.noCommentLabel,
  });
}

class _ReviewAvatar extends StatelessWidget {
  final String initial;
  final bool isAnonymous;

  const _ReviewAvatar({required this.initial, this.isAnonymous = false});

  @override
  Widget build(BuildContext context) {
    final bgColor = isAnonymous
        ? AppColors.buttonSecondary
        : AppColors.brandRed.withValues(alpha: 0.1);
    final textColor = isAnonymous
        ? AppColors.textSecondary
        : AppColors.brandRed;

    return CircleAvatar(
      radius: 18,
      backgroundColor: bgColor,
      child: Text(
        initial,
        style: AppTypography.bodyMedium.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
