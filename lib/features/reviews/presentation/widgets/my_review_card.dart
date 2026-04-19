import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/customer_review_item.dart';

class MyReviewCard extends StatelessWidget {
  final CustomerReviewItem review;
  final String editLabel;
  final String deleteLabel;
  final bool isMutating;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MyReviewCard({
    super.key,
    required this.review,
    required this.editLabel,
    required this.deleteLabel,
    required this.isMutating,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final displayName = (review.companyName ?? '').trim().isEmpty
        ? localizations.companyDetailsUnknownCompany
        : review.companyName!.trim();

    final date = review.updatedAt ?? review.createdAt;
    final locale = Localizations.localeOf(context).toString();
    final dateLabel = date == null
        ? localizations.requestDetailsNotAvailable
        : DateFormat.yMMMd(locale).format(date);

    final text = review.reviewText?.trim();
    final ratingValue = review.rating.toDouble().clamp(0, 5).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.55)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CompanyLogo(url: review.companyLogoUrl),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: AppTypography.heading3.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    _MetaChip(
                      icon: Icons.schedule_rounded,
                      label: dateLabel,
                    ),
                  ],
                ),
              ),
              _RatingBadge(value: ratingValue),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Row(
            children: [
              RatingBarIndicator(
                rating: ratingValue,
                itemBuilder: (context, index) => const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFB300),
                ),
                itemCount: 5,
                itemSize: 20,
                unratedColor: AppColors.divider,
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Text(
                ratingValue.toStringAsFixed(1),
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (text != null && text.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingSm),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
              ),
              child: Text(
                text,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionIconButton(
                icon: Icons.edit_outlined,
                tooltip: editLabel,
                backgroundColor: AppColors.brandRed.withValues(alpha: 0.12),
                iconColor: AppColors.brandRed,
                onPressed: isMutating ? null : onEdit,
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              _ActionIconButton(
                icon: Icons.delete_outline_rounded,
                tooltip: deleteLabel,
                backgroundColor: AppColors.error.withValues(alpha: 0.12),
                iconColor: AppColors.error,
                onPressed: isMutating ? null : onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onPressed;

  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: onPressed == null
            ? AppColors.buttonSecondary.withValues(alpha: 0.6)
            : backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      ),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        splashRadius: 20,
        iconSize: 20,
        color: onPressed == null ? AppColors.textSecondary : iconColor,
        icon: Icon(icon),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({
    required this.icon,
    required this.label,
  });

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double value;

  const _RatingBadge({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXs,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB300).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFFFB300),
            size: 16,
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            value.toStringAsFixed(1),
            style: AppTypography.bodySmall.copyWith(
              color: const Color(0xFF9C6500),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyLogo extends StatelessWidget {
  final String? url;

  const _CompanyLogo({this.url});

  @override
  Widget build(BuildContext context) {
    const size = AppDimensions.logoSizeSmall + 4;

    if (url != null && url!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
        child: CachedNetworkImage(
          imageUrl: url!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => const _LogoPlaceholder(),
        ),
      );
    }

    return const _LogoPlaceholder();
  }
}

class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    const size = AppDimensions.logoSizeSmall + 4;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.buttonSecondary,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
      ),
      child: Icon(
        Icons.business_rounded,
        size: AppDimensions.logoSizeSmall * 0.5,
        color: AppColors.textSecondary,
      ),
    );
  }
}
