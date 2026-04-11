import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/company_summary.dart';
import 'company_summary_card.dart';

class CompanySectionCarousel extends StatelessWidget {
  final String title;
  final List<CompanySummary> companies;
  final bool showTrendIndicator;
  final ValueChanged<CompanySummary>? onCompanyTap;

  const CompanySectionCarousel({
    super.key,
    required this.title,
    required this.companies,
    this.showTrendIndicator = false,
    this.onCompanyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.heading3),
        const SizedBox(height: AppDimensions.spacingSm),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            itemCount: companies.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppDimensions.spacingSm),
            itemBuilder: (context, index) {
              final company = companies[index];
              return CompanySummaryCard(
                company: company,
                showTrendIndicator: showTrendIndicator,
                onTap: onCompanyTap == null
                    ? null
                    : () => onCompanyTap!(company),
              );
            },
          ),
        ),
      ],
    );
  }
}
