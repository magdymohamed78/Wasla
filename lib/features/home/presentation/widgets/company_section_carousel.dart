import 'package:flutter/material.dart';
import 'package:waslaapp/features/companies/presentation/widgets/company_summary_card.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/company_summary.dart';

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
              TextButton(onPressed: onViewAll, child: Text(viewAllLabel!)),
          ],
        ),
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
