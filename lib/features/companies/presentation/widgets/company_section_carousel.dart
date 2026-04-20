import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/logo_preload_helper.dart';
import '../../../home/domain/entities/company_summary.dart';
import 'company_summary_card.dart';

class CompanySectionCarousel extends StatefulWidget {
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
  State<CompanySectionCarousel> createState() => _CompanySectionCarouselState();
}

class _CompanySectionCarouselState extends State<CompanySectionCarousel> {
  String _lastPreloadSignature = '';

  @override
  void initState() {
    super.initState();
    _schedulePreload();
  }

  @override
  void didUpdateWidget(covariant CompanySectionCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_logoSignature(oldWidget.companies) !=
        _logoSignature(widget.companies)) {
      _schedulePreload();
    }
  }

  void _schedulePreload() {
    final logoUrls = widget.companies
        .map((company) => company.companyLogoUrl)
        .toList(growable: false);
    final signature = _logoSignature(widget.companies);

    if (signature.isEmpty || signature == _lastPreloadSignature) {
      return;
    }

    _lastPreloadSignature = signature;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      precacheCompanyLogos(context, logoUrls, maxCount: 5);
    });
  }

  String _logoSignature(List<CompanySummary> companies) {
    return companies
        .map((company) => company.companyLogoUrl?.trim() ?? '')
        .join('|');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(widget.title, style: AppTypography.heading3)),
            if (widget.onViewAll != null && widget.viewAllLabel != null)
              TextButton.icon(
                onPressed: widget.onViewAll,
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: AppColors.brandRed,
                ),
                label: Text(
                  widget.viewAllLabel!,
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
              for (final company in widget.companies) ...[
                CompanySummaryCard(
                  company: company,
                  showTrendIndicator: widget.showTrendIndicator,
                  cardWidth: 280,
                  onTap: widget.onCompanyTap == null
                      ? null
                      : () => widget.onCompanyTap!(company),
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
