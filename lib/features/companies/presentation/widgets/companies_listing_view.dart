import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/logo_preload_helper.dart';
import '../../../home/domain/entities/company_summary.dart';
import '../../../home/domain/entities/explore_pagination.dart';
import 'company_summary_card.dart';
import '../../../explore/presentation/widgets/view_all_search_entry.dart';

typedef CompaniesPageLoader =
    Future<DiscoveryPage<CompanySummary>> Function(int pageIndex);

class CompaniesListingView extends StatefulWidget {
  final String title;
  final CompaniesPageLoader loadPage;
  final bool showTrendIndicator;

  const CompaniesListingView({
    super.key,
    required this.title,
    required this.loadPage,
    this.showTrendIndicator = false,
  });

  @override
  State<CompaniesListingView> createState() => _CompaniesListingViewState();
}

class _CompaniesListingViewState extends State<CompaniesListingView> {
  late final PagingController<int, CompanySummary> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, CompanySummary>(firstPageKey: 1)
      ..addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageIndex) async {
    try {
      final page = await widget.loadPage(pageIndex);
      if (!mounted) {
        return;
      }

      _precachePageLogos(page.items);

      if (page.hasReachedEnd || page.items.isEmpty) {
        _pagingController.appendLastPage(page.items);
      } else {
        _pagingController.appendPage(page.items, page.pageIndex + 1);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      _pagingController.error = error;
    }
  }

  void _precachePageLogos(List<CompanySummary> companies) {
    if (companies.isEmpty) {
      return;
    }

    final logoUrls = companies
        .map((company) => company.companyLogoUrl)
        .toList(growable: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      precacheCompanyLogos(context, logoUrls, maxCount: 10);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
              return;
            }

            context.go(AppRouter.home);
          },
        ),
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingMd,
                AppDimensions.paddingSm,
                AppDimensions.paddingMd,
                AppDimensions.paddingSm,
              ),
              child: ViewAllSearchEntry(
                hintText: localizations.homeSearchForServicesOrCompanies,
                onTap: () => context.push(AppRouter.explore),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => _pagingController.refresh(),
                child: PagedListView<int, CompanySummary>(
                  pagingController: _pagingController,
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.paddingMd,
                    0,
                    AppDimensions.paddingMd,
                    AppDimensions.paddingMd,
                  ),
                  builderDelegate: PagedChildBuilderDelegate<CompanySummary>(
                    itemBuilder: (context, company, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.spacingMd,
                        ),
                        child: CompanySummaryCard(
                          company: company,
                          showTrendIndicator: widget.showTrendIndicator,
                          cardWidth: double.infinity,
                        ),
                      );
                    },
                    firstPageProgressIndicatorBuilder: (context) {
                      return const _ListingSkeleton(count: 4);
                    },
                    newPageProgressIndicatorBuilder: (context) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimensions.spacingMd,
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    noItemsFoundIndicatorBuilder: (context) {
                      return _ListingEmptyState(
                        title: widget.title,
                        message: localizations.exploreNoCompaniesFound,
                      );
                    },
                    firstPageErrorIndicatorBuilder: (context) {
                      return _ListingErrorState(
                        message: localizations.networkErrorServer,
                        retryLabel: localizations.networkErrorRetry,
                        onRetry: _pagingController.refresh,
                      );
                    },
                    newPageErrorIndicatorBuilder: (context) {
                      return Center(
                        child: TextButton.icon(
                          onPressed: _pagingController.retryLastFailedRequest,
                          icon: const Icon(Icons.refresh),
                          label: Text(localizations.networkErrorRetry),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingSkeleton extends StatelessWidget {
  final int count;

  const _ListingSkeleton({required this.count});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.buttonSecondary,
      highlightColor: AppColors.cardShadow,
      child: Column(
        children: List.generate(count, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusXl,
                ),
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
        }),
      ),
    );
  }
}

class _ListingEmptyState extends StatelessWidget {
  final String title;
  final String message;

  const _ListingEmptyState({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
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
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingErrorState extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  const _ListingErrorState({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppDimensions.spacingSm),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}
