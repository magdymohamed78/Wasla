import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/customer_portal_content.dart';

class ConnectedCompanyCard extends StatelessWidget {
  final ConnectedCompany company;

  const ConnectedCompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final companyName = (company.companyName ?? '').trim().isEmpty
        ? localizations.companyDetailsUnknownCompany
        : company.companyName!.trim();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CompanyLogo(url: company.companyLogoUrl),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                _StatusPill(status: company.status),
                const SizedBox(height: AppDimensions.spacingSm),
                _KeyValueRow(
                  label: localizations.profileCompanyCustomerId,
                  value: company.customerId?.toString() ?? '-',
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                _KeyValueRow(
                  label: localizations.profileCompanyRequestedAt,
                  value: _formatDate(context, company.requestedAt),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                _KeyValueRow(
                  label: localizations.profileCompanyRespondedAt,
                  value: _formatDate(context, company.respondedAt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime? value) {
    if (value == null) {
      return '-';
    }

    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(value.toLocal());
  }
}

class _CompanyLogo extends StatelessWidget {
  final String? url;

  const _CompanyLogo({this.url});

  @override
  Widget build(BuildContext context) {
    final hasUrl = (url ?? '').trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      child: Container(
        width: 56,
        height: 56,
        color: AppColors.buttonSecondary,
        child: hasUrl
            ? CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => const _LogoFallback(),
              )
            : const _LogoFallback(),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.business_rounded,
      color: AppColors.textSecondary,
      size: AppDimensions.iconSizeMd,
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String? status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final normalized = (status ?? '').trim().toLowerCase();

    Color foreground = AppColors.textSecondary;
    Color background = AppColors.buttonSecondary;
    String label = localizations.profileCompanyStatusUnknown;

    if (normalized == 'accepted') {
      foreground = const Color(0xFF2E7D32);
      background = const Color(0xFFE8F5E9);
      label = localizations.profileCompanyStatusAccepted;
    } else if (normalized == 'pending') {
      foreground = const Color(0xFFEF6C00);
      background = const Color(0xFFFFF3E0);
      label = localizations.profileCompanyStatusPending;
    } else if (normalized == 'rejected') {
      foreground = AppColors.error;
      background = const Color(0xFFFFEBEE);
      label = localizations.profileCompanyStatusRejected;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _KeyValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
