import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/company_summary.dart';
import 'company_summary_card.dart';

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
      highlightColor: AppColors.surface,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 116,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.borderRadiusLg),
                  topRight: Radius.circular(AppDimensions.borderRadiusLg),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 180,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusSm,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  Container(
                    height: 12,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusSm,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  Container(
                    height: 12,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusSm,
                      ),
                    ),
                  ),
                ],
              ),
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
