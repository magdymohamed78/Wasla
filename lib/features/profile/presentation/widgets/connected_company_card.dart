import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/company_logo_widget.dart';
import '../../../home/domain/entities/customer_portal_content.dart';

class ConnectedCompanyCard extends StatelessWidget {
  final ConnectedCompany company;
  final VoidCallback? onTap;

  const ConnectedCompanyCard({super.key, required this.company, this.onTap});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final companyName = (company.companyName ?? '').trim().isEmpty
        ? localizations.companyDetailsUnknownCompany
        : company.companyName!.trim();
    final statusColor = _resolveStatusColor(company.status);

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
                        Row(
                          children: [
                            CompanyLogoWidget(logoUrl: company.companyLogoUrl),
                            const SizedBox(width: AppDimensions.spacingSm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    companyName,
                                    style: AppTypography.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (company.customerId != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: AppDimensions.spacingXs / 2,
                                      ),
                                      child: Text(
                                        '${localizations.profileCompanyCustomerId}: ${company.customerId}',
                                        style: AppTypography.bodySmall,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacingSm),
                            _StatusBadge(
                              label: _statusLabel(
                                localizations,
                                company.status,
                              ),
                              color: statusColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        Row(
                          children: [
                            if (company.requestedAt != null)
                              _DateChip(
                                label:
                                    '${localizations.profileCompanyRequestedAt}: ${_formatDate(context, company.requestedAt)}',
                              ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: statusColor,
                            ),
                          ],
                        ),
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

  String _formatDate(BuildContext context, DateTime? value) {
    if (value == null) return '-';
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(value.toLocal());
  }

  static Color _resolveStatusColor(String? status) {
    final normalized = (status ?? '').trim().toLowerCase();
    if (normalized == 'accepted') return const Color(0xFF2E7D32);
    if (normalized == 'pending') return AppColors.statusPending;
    if (normalized == 'rejected') return AppColors.statusDeclined;
    return AppColors.textSecondary;
  }

  static String _statusLabel(AppLocalizations localizations, String? status) {
    final normalized = (status ?? '').trim().toLowerCase();
    if (normalized == 'accepted') {
      return localizations.profileCompanyStatusAccepted;
    }
    if (normalized == 'pending') {
      return localizations.profileCompanyStatusPending;
    }
    if (normalized == 'rejected') {
      return localizations.profileCompanyStatusRejected;
    }
    return localizations.profileCompanyStatusUnknown;
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
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;

  const _DateChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: AppDimensions.iconSizeSm - 2,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimensions.spacingXs),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}
