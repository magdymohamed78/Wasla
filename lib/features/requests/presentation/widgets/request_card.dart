import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/company_logo_widget.dart';

class RequestCard extends StatelessWidget {
  final String? companyLogoUrl;
  final String companyName;
  final String? referenceNumber;
  final String statusLabel;
  final Color statusColor;
  final String? serviceType;
  final String? preferredDateLabel;
  final String? submissionDateLabel;
  final VoidCallback onViewRequest;

  const RequestCard({
    super.key,
    this.companyLogoUrl,
    required this.companyName,
    this.referenceNumber,
    required this.statusLabel,
    this.statusColor = AppColors.brandRed,
    this.serviceType,
    this.preferredDateLabel,
    this.submissionDateLabel,
    required this.onViewRequest,
  });

  bool get _hasDates =>
      preferredDateLabel != null || submissionDateLabel != null;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
      child: InkWell(
        onTap: onViewRequest,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CompanyLogoWidget(logoUrl: companyLogoUrl),
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
                                  if (referenceNumber != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: AppDimensions.spacingXs / 2,
                                      ),
                                      child: Text(
                                        'Ref: $referenceNumber',
                                        style: AppTypography.bodySmall,
                                      ),
                                    ),
                                  if (serviceType != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: AppDimensions.spacingXs,
                                      ),
                                      child: _ChipBadge(
                                        label: serviceType!,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacingSm),
                            Spacer(),
                            _ChipBadge(label: statusLabel, color: statusColor),
                          ],
                        ),
                        if (_hasDates) ...[
                          const SizedBox(height: AppDimensions.spacingMd),
                          const Divider(height: 1, color: AppColors.divider),
                          const SizedBox(height: AppDimensions.spacingSm),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (preferredDateLabel != null)
                                      _DateChip(label: preferredDateLabel!),
                                    if (preferredDateLabel != null &&
                                        submissionDateLabel != null)
                                      const SizedBox(
                                        height: AppDimensions.spacingXs,
                                      ),
                                    if (submissionDateLabel != null)
                                      _DateChip(label: submissionDateLabel!),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: statusColor,
                              ),
                            ],
                          ),
                        ],
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

class _ChipBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _ChipBadge({required this.label, required this.color});

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
        Flexible(
          child: Text(
            label,
            style: AppTypography.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
