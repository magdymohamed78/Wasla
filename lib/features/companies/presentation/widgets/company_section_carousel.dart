import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/company_summary.dart';
import 'company_summary_card.dart';

class CompanySectionCarousel extends StatelessWidget {
  final String title;
  final List<CompanySummary> companies;
  final bool showTrendIndicator;
  final ValueChanged<CompanySummary>? onCompanyTap;
  final String? viewAllLabel;
  final VoidCallback? onViewAll;

  const CompanySectionCarousel({
    super.key,
    required this.title,
    required this.companies,
    this.showTrendIndicator = false,
    this.onCompanyTap,
    this.viewAllLabel,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: AppTypography.heading3)),
            if (onViewAll != null && viewAllLabel != null)
              TextButton.icon(
                onPressed: onViewAll,
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: AppColors.brandRed,
                ),
                label: Text(
                  viewAllLabel!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.brandRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final company in companies) ...[
                CompanySummaryCard(
                  company: company,
                  showTrendIndicator: showTrendIndicator,
                  cardWidth: 280,
                  onTap: onCompanyTap == null
                      ? null
                      : () => onCompanyTap!(company),
                ),
                const SizedBox(width: AppDimensions.spacingSm),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
