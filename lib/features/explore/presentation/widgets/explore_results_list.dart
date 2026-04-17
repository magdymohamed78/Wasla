import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/company_summary.dart';
import '../../../companies/presentation/widgets/company_summary_card.dart';

class ExploreResultsList extends StatelessWidget {
  final PagingController<int, CompanySummary> pagingController;
  final VoidCallback onClearFilters;

  const ExploreResultsList({
    super.key,
    required this.pagingController,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return PagedListView<int, CompanySummary>(
      pagingController: pagingController,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingMd,
        0,
        AppDimensions.paddingMd,
        AppDimensions.paddingMd,
      ),
      builderDelegate: PagedChildBuilderDelegate<CompanySummary>(
        itemBuilder: (context, company, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
            child: CompanySummaryCard(
              company: company,
              cardWidth: double.infinity,
            ),
          );
        },
        firstPageProgressIndicatorBuilder: (context) =>
            const _ExploreSkeletonList(itemCount: 4),
        newPageProgressIndicatorBuilder: (context) => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
          child: _ExploreSkeletonList(itemCount: 1),
        ),
        noItemsFoundIndicatorBuilder: (context) {
          return _ExploreEmptyCard(
            title: localizations.exploreNoCompaniesFound,
            message: localizations.exploreTryAdjustingFilters,
            clearLabel: localizations.exploreClearFilters,
            onClearFilters: onClearFilters,
          );
        },
        firstPageErrorIndicatorBuilder: (context) {
          return _ExploreErrorCard(
            message: localizations.networkErrorServer,
            retryLabel: localizations.networkErrorRetry,
            onRetry: pagingController.refresh,
          );
        },
        newPageErrorIndicatorBuilder: (context) {
          return Center(
            child: TextButton.icon(
              onPressed: pagingController.retryLastFailedRequest,
              icon: const Icon(Icons.refresh),
              label: Text(localizations.networkErrorRetry),
            ),
          );
        },
      ),
    );
  }
}

class _ExploreSkeletonList extends StatelessWidget {
  final int itemCount;

  const _ExploreSkeletonList({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingMd,
        0,
        AppDimensions.paddingMd,
        AppDimensions.paddingMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          itemCount,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index == itemCount - 1 ? 0 : AppDimensions.spacingMd,
            ),
            child: const _ExploreSkeletonCard(),
          ),
          growable: false,
        ),
      ),
    );
  }
}

class _ExploreSkeletonCard extends StatelessWidget {
  const _ExploreSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.buttonSecondary,
      highlightColor: AppColors.cardShadow,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 160,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingSm),
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.divider,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 10,
                            width: 60,
                            decoration: BoxDecoration(
                              color: AppColors.divider,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.divider,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Wrap(
              spacing: AppDimensions.spacingXs,
              runSpacing: AppDimensions.spacingXs,
              children: [
                Container(
                  height: 24,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusRound,
                    ),
                  ),
                ),
                Container(
                  height: 24,
                  width: 65,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusRound,
                    ),
                  ),
                ),
                Container(
                  height: 24,
                  width: 55,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusRound,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreEmptyCard extends StatelessWidget {
  final String title;
  final String message;
  final String clearLabel;
  final VoidCallback onClearFilters;

  const _ExploreEmptyCard({
    required this.title,
    required this.message,
    required this.clearLabel,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXl),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTypography.heading3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              TextButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.filter_alt_off),
                label: Text(clearLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreErrorCard extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  const _ExploreErrorCard({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXl),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                message,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
