import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/types/load_status.dart';
import '../../../home/domain/use_cases/discovery_use_cases.dart';
import '../cubit/company_reviews_cubit.dart';
import '../widgets/company_details_sections.dart';

class CompanyReviewsPage extends StatelessWidget {
  final int companyId;

  const CompanyReviewsPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompanyReviewsCubit>(
      create: (context) => CompanyReviewsCubit(
        companyId: companyId,
        getCompanyReviews: context.read<GetCompanyReviewsUseCase>(),
      )..loadFirstPage(),
      child: const _CompanyReviewsView(),
    );
  }
}

class _CompanyReviewsView extends StatelessWidget {
  const _CompanyReviewsView();

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
            context.go('/home');
          },
        ),
        title: Text(localizations.companyReviewsPageTitle),
      ),
      body: SafeArea(
        child: BlocBuilder<CompanyReviewsCubit, CompanyReviewsState>(
          builder: (context, state) {
            switch (state.status) {
              case LoadStatus.initial:
              case LoadStatus.loading:
                return const _ReviewsSkeleton(count: 6);
              case LoadStatus.error:
                return _ReviewsErrorCard(
                  message: localizations.companyDetailsLoadFailed,
                  retryLabel: localizations.networkErrorRetry,
                  onRetry: context.read<CompanyReviewsCubit>().loadFirstPage,
                );
              case LoadStatus.empty:
                return _ReviewsEmptyCard(
                  message: localizations.companyDetailsNoReviewsYet,
                );
              case LoadStatus.success:
                return _ReviewsList(state: state);
            }
          },
        ),
      ),
    );
  }
}

class _ReviewsList extends StatefulWidget {
  final CompanyReviewsState state;

  const _ReviewsList({required this.state});

  @override
  State<_ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<_ReviewsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CompanyReviewsCubit>().loadMoreReviews();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final state = widget.state;

    return RefreshIndicator(
      onRefresh: context.read<CompanyReviewsCubit>().loadFirstPage,
      child: ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        children: [
          for (int i = 0; i < state.reviews.length; i++) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
              child: ReviewTile(
                review: state.reviews[i],
                anonymousReviewerLabel:
                    localizations.companyDetailsAnonymousReviewer,
                noCommentLabel: localizations.companyDetailsNoComment,
              ),
            ),
            if (i < state.reviews.length - 1)
              const Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.spacingMd),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.divider,
                ),
              ),
          ],
          if (state.isLoadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewsSkeleton extends StatelessWidget {
  final int count;

  const _ReviewsSkeleton({required this.count});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.buttonSecondary,
      highlightColor: AppColors.cardShadow,
      child: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        children: List.generate(count, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Container(
                      height: 12,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 12,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Container(
                  height: 10,
                  width: 200,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ReviewsEmptyCard extends StatelessWidget {
  final String message;

  const _ReviewsEmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: AppDimensions.iconSizeXl,
              color: AppColors.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewsErrorCard extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  const _ReviewsErrorCard({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
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
