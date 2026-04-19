import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/session/session_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/types/load_status.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../home/domain/entities/company_details.dart';
import '../../../home/domain/repositories/customer_reviews_repository.dart';
import '../../../home/domain/use_cases/customer_profile_use_cases.dart';
import '../../../home/domain/use_cases/discovery_use_cases.dart';
import '../cubit/company_review_action_cubit.dart';
import '../cubit/company_review_action_state.dart';
import '../cubit/company_reviews_cubit.dart';
import '../widgets/company_review_action_panel.dart';
import '../widgets/write_review_modal.dart';

class CompanyReviewsPage extends StatelessWidget {
  final int companyId;

  const CompanyReviewsPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CompanyReviewsCubit>(
          create: (context) => CompanyReviewsCubit(
            companyId: companyId,
            getCompanyReviews: context.read<GetCompanyReviewsUseCase>(),
          )..loadFirstPage(),
        ),
        BlocProvider<CompanyReviewActionCubit>(
          create: (context) => CompanyReviewActionCubit(
            companyId: companyId,
            sessionCubit: context.read<SessionCubit>(),
            getCustomerProfileUseCase: context
                .read<GetCustomerProfileUseCase>(),
            reviewsRepository: context.read<CustomerReviewsRepository>(),
          )..loadEligibility(),
        ),
      ],
      child: const _CompanyReviewsView(),
    );
  }
}

enum _CompanyReviewsSort {
  newestFirst,
  oldestFirst,
  highestRating,
  lowestRating,
}

class _CompanyReviewsView extends StatefulWidget {
  const _CompanyReviewsView();

  @override
  State<_CompanyReviewsView> createState() => _CompanyReviewsViewState();
}

class _CompanyReviewsViewState extends State<_CompanyReviewsView> {
  final ScrollController _scrollController = ScrollController();
  _CompanyReviewsSort _selectedSort = _CompanyReviewsSort.newestFirst;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 220) {
      context.read<CompanyReviewsCubit>().loadMoreReviews();
    }
  }

  Future<void> _refreshPage() {
    return context.read<CompanyReviewsCubit>().loadFirstPage();
  }

  List<CompanyReviewItem> _sortedReviews(List<CompanyReviewItem> source) {
    final sortedItems = List<CompanyReviewItem>.from(source);

    sortedItems.sort((a, b) {
      switch (_selectedSort) {
        case _CompanyReviewsSort.newestFirst:
          return _sortDate(b).compareTo(_sortDate(a));
        case _CompanyReviewsSort.oldestFirst:
          return _sortDate(a).compareTo(_sortDate(b));
        case _CompanyReviewsSort.highestRating:
          return _compareRatings(a, b, ascending: false);
        case _CompanyReviewsSort.lowestRating:
          return _compareRatings(a, b, ascending: true);
      }
    });

    return sortedItems;
  }

  DateTime _sortDate(CompanyReviewItem review) {
    return review.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  int _compareRatings(
    CompanyReviewItem a,
    CompanyReviewItem b, {
    required bool ascending,
  }) {
    final ratingA = a.rating;
    final ratingB = b.rating;

    if (ratingA == null && ratingB == null) {
      return _sortDate(b).compareTo(_sortDate(a));
    }

    if (ratingA == null) {
      return 1;
    }

    if (ratingB == null) {
      return -1;
    }

    final diff = ascending
        ? ratingA.compareTo(ratingB)
        : ratingB.compareTo(ratingA);
    if (diff != 0) {
      return diff;
    }

    return _sortDate(b).compareTo(_sortDate(a));
  }

  String _sortLabel(_CompanyReviewsSort sort, AppLocalizations localizations) {
    switch (sort) {
      case _CompanyReviewsSort.newestFirst:
        return localizations.companyReviewsSortNewestFirst;
      case _CompanyReviewsSort.oldestFirst:
        return localizations.companyReviewsSortOldestFirst;
      case _CompanyReviewsSort.highestRating:
        return localizations.companyReviewsSortHighestRating;
      case _CompanyReviewsSort.lowestRating:
        return localizations.companyReviewsSortLowestRating;
    }
  }

  IconData _sortIcon(_CompanyReviewsSort sort) {
    switch (sort) {
      case _CompanyReviewsSort.newestFirst:
        return Icons.schedule_rounded;
      case _CompanyReviewsSort.oldestFirst:
        return Icons.history_toggle_off_rounded;
      case _CompanyReviewsSort.highestRating:
        return Icons.north_rounded;
      case _CompanyReviewsSort.lowestRating:
        return Icons.south_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final reviewActionState = context.watch<CompanyReviewActionCubit>().state;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth >= 768
        ? AppDimensions.paddingXl
        : (screenWidth >= 540
              ? AppDimensions.paddingLg
              : AppDimensions.paddingMd);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
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
        title: Text(localizations.companyReviewsPageTitle),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.surface.withValues(alpha: 0.55),
                AppColors.background,
              ],
            ),
          ),
          child: BlocBuilder<CompanyReviewsCubit, CompanyReviewsState>(
            builder: (context, state) {
              switch (state.status) {
                case LoadStatus.initial:
                case LoadStatus.loading:
                  return _ReviewsSkeleton(
                    count: 5,
                    horizontalPadding: horizontalPadding,
                  );
                case LoadStatus.error:
                  return _ReviewsErrorCard(
                    message: localizations.companyDetailsLoadFailed,
                    retryLabel: localizations.networkErrorRetry,
                    horizontalPadding: horizontalPadding,
                    onRetry: context.read<CompanyReviewsCubit>().loadFirstPage,
                  );
                case LoadStatus.empty:
                  return RefreshIndicator(
                    onRefresh: _refreshPage,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsetsDirectional.fromSTEB(
                        horizontalPadding,
                        AppDimensions.paddingMd,
                        horizontalPadding,
                        AppDimensions.paddingMd,
                      ),
                      children: [
                        _ReviewsOverviewCard(
                          title: localizations.companyReviewsPageTitle,
                          count: 0,
                          sortLabel: localizations.companyReviewsSortLabel,
                          selectedSort: _selectedSort,
                          onSortChanged: (sort) {
                            setState(() => _selectedSort = sort);
                          },
                          sortLabelBuilder: (sort) =>
                              _sortLabel(sort, localizations),
                          sortIconBuilder: _sortIcon,
                        ),
                        if (reviewActionState.isCustomerRole) ...[
                          const SizedBox(height: AppDimensions.spacingMd),
                          _buildReviewActionPanel(
                            context,
                            localizations,
                            reviewActionState,
                          ),
                        ],
                        const SizedBox(height: AppDimensions.spacingMd),
                        _ReviewsEmptyCard(
                          title: localizations.companyReviewsPageTitle,
                          message: localizations.companyDetailsNoReviewsYet,
                        ),
                      ],
                    ),
                  );
                case LoadStatus.success:
                  final sortedItems = _sortedReviews(state.reviews);

                  return RefreshIndicator(
                    onRefresh: _refreshPage,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsetsDirectional.fromSTEB(
                        horizontalPadding,
                        AppDimensions.paddingMd,
                        horizontalPadding,
                        AppDimensions.paddingMd,
                      ),
                      itemCount:
                          sortedItems.length +
                          (state.isLoadingMore ? 1 : 0) +
                          1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimensions.spacingMd,
                            ),
                            child: Column(
                              children: [
                                _ReviewsOverviewCard(
                                  title: localizations.companyReviewsPageTitle,
                                  count: state.reviews.length,
                                  sortLabel:
                                      localizations.companyReviewsSortLabel,
                                  selectedSort: _selectedSort,
                                  onSortChanged: (sort) {
                                    setState(() => _selectedSort = sort);
                                  },
                                  sortLabelBuilder: (sort) =>
                                      _sortLabel(sort, localizations),
                                  sortIconBuilder: _sortIcon,
                                ),
                                if (reviewActionState.isCustomerRole) ...[
                                  const SizedBox(
                                    height: AppDimensions.spacingMd,
                                  ),
                                  _buildReviewActionPanel(
                                    context,
                                    localizations,
                                    reviewActionState,
                                  ),
                                ],
                              ],
                            ),
                          );
                        }

                        final reviewIndex = index - 1;
                        if (reviewIndex >= sortedItems.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppDimensions.spacingMd,
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.brandRed,
                                ),
                              ),
                            ),
                          );
                        }

                        final review = sortedItems[reviewIndex];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.spacingSm,
                          ),
                          child: _CompanyReviewCard(
                            review: review,
                            anonymousReviewerLabel:
                                localizations.companyDetailsAnonymousReviewer,
                            noCommentLabel:
                                localizations.companyDetailsNoComment,
                            noDateLabel:
                                localizations.requestDetailsNotAvailable,
                          ),
                        );
                      },
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReviewActionPanel(
    BuildContext context,
    AppLocalizations localizations,
    CompanyReviewActionState reviewActionState,
  ) {
    return CompanyReviewActionPanel(
      isEligibilityLoading: reviewActionState.isEligibilityLoading,
      canWriteReview: reviewActionState.canWriteReview,
      showNotConnectedInfo: reviewActionState.shouldShowNotConnectedInfo,
      isSubmitting: reviewActionState.isSubmitting,
      writeReviewLabel: localizations.companyReviewsWriteReview,
      infoMessage: localizations.companyReviewsEligibilityInfo,
      viewProfileLabel: localizations.companyReviewsViewProfile,
      onWriteReview: _onWriteReviewTapped,
      onViewProfile: () => context.go(AppRouter.customerProfile),
    );
  }

  Future<void> _onWriteReviewTapped() async {
    final localizations = AppLocalizations.of(context);
    final payload = await WriteReviewModal.show(context);

    if (payload == null || !mounted) {
      return;
    }

    final submitResult = await context
        .read<CompanyReviewActionCubit>()
        .submitReview(rating: payload.rating, reviewText: payload.reviewText);

    if (!mounted) {
      return;
    }

    if (submitResult.success) {
      await context.read<CompanyReviewsCubit>().loadFirstPage();
      if (!mounted) {
        return;
      }
      ToastUtils.showSuccess(context, localizations.companyReviewsWriteSuccess);
      return;
    }

    ToastUtils.showError(
      context,
      _reviewSubmitErrorMessage(localizations, submitResult),
    );
  }

  String _reviewSubmitErrorMessage(
    AppLocalizations localizations,
    CompanyReviewSubmitResult submitResult,
  ) {
    if (submitResult.errorCode == CompanyReviewSubmitErrorCode.badRequest) {
      return localizations.companyReviewsWriteErrorBadRequest;
    }

    final problemDetail = submitResult.problemDetail?.trim();
    if (problemDetail != null && problemDetail.isNotEmpty) {
      return problemDetail;
    }

    switch (submitResult.errorCode) {
      case CompanyReviewSubmitErrorCode.badRequest:
        return localizations.companyReviewsWriteErrorBadRequest;
      case CompanyReviewSubmitErrorCode.unauthorized:
        return localizations.companyReviewsWriteErrorUnauthorized;
      case CompanyReviewSubmitErrorCode.forbidden:
        return localizations.companyReviewsWriteErrorForbidden;
      case CompanyReviewSubmitErrorCode.notFound:
        return localizations.companyReviewsWriteErrorNotFound;
      case CompanyReviewSubmitErrorCode.conflict:
        return localizations.companyReviewsWriteErrorConflict;
      case CompanyReviewSubmitErrorCode.network:
        return localizations.companyReviewsWriteErrorNetwork;
      case CompanyReviewSubmitErrorCode.server:
      case null:
        return localizations.companyReviewsWriteErrorServer;
    }
  }
}

class _ReviewsSkeleton extends StatelessWidget {
  final int count;
  final double horizontalPadding;

  const _ReviewsSkeleton({
    required this.count,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.buttonSecondary,
      highlightColor: AppColors.cardShadow,
      child: ListView(
        padding: EdgeInsetsDirectional.fromSTEB(
          horizontalPadding,
          AppDimensions.paddingMd,
          horizontalPadding,
          AppDimensions.paddingMd,
        ),
        children: [
          Container(
            height: 132,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          ...List<Widget>.generate(
            count,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: Container(
                height: 190,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusXl,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsEmptyCard extends StatelessWidget {
  final String title;
  final String message;

  const _ReviewsEmptyCard({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.brandRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusRound,
              ),
            ),
            child: Icon(
              Icons.rate_review_outlined,
              size: AppDimensions.iconSizeLg,
              color: AppColors.brandRed,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
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
        ],
      ),
    );
  }
}

class _ReviewsErrorCard extends StatelessWidget {
  final String message;
  final String retryLabel;
  final double horizontalPadding;
  final VoidCallback onRetry;

  const _ReviewsErrorCard({
    required this.message,
    required this.retryLabel,
    required this.horizontalPadding,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          horizontalPadding,
          AppDimensions.paddingLg,
          horizontalPadding,
          AppDimensions.paddingLg,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusRound,
                  ),
                ),
                child: const Icon(Icons.error_outline, color: AppColors.error),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                message,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandRed,
                  foregroundColor: AppColors.surface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewsOverviewCard extends StatelessWidget {
  final String title;
  final int count;
  final String sortLabel;
  final _CompanyReviewsSort selectedSort;
  final ValueChanged<_CompanyReviewsSort> onSortChanged;
  final String Function(_CompanyReviewsSort sort) sortLabelBuilder;
  final IconData Function(_CompanyReviewsSort sort) sortIconBuilder;

  const _ReviewsOverviewCard({
    required this.title,
    required this.count,
    required this.sortLabel,
    required this.selectedSort,
    required this.onSortChanged,
    required this.sortLabelBuilder,
    required this.sortIconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final allSorts = _CompanyReviewsSort.values;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.buttonSecondary.withValues(alpha: 0.55),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.55)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.brandRed.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusMd,
                  ),
                ),
                child: const Icon(
                  Icons.reviews_rounded,
                  color: AppColors.brandRed,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(title, style: AppTypography.bodyMedium)],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSm,
                  vertical: AppDimensions.paddingXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandRed,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusLg,
                  ),
                ),
                child: Text(
                  '$count',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            sortLabel,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSm,
              vertical: AppDimensions.spacingXs,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
              border: Border.all(
                color: AppColors.divider.withValues(alpha: 0.9),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<_CompanyReviewsSort>(
                value: selectedSort,
                isExpanded: true,
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMd,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                dropdownColor: AppColors.surface,
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                  }
                },
                selectedItemBuilder: (context) {
                  return allSorts
                      .map((sort) {
                        return Row(
                          children: [
                            Icon(
                              sortIconBuilder(sort),
                              size: 18,
                              color: AppColors.brandRed,
                            ),
                            const SizedBox(width: AppDimensions.spacingXs),
                            Flexible(child: Text(sortLabelBuilder(sort))),
                          ],
                        );
                      })
                      .toList(growable: false);
                },
                items: allSorts
                    .map((sort) {
                      return DropdownMenuItem<_CompanyReviewsSort>(
                        value: sort,
                        child: Row(
                          children: [
                            Icon(
                              sortIconBuilder(sort),
                              size: 18,
                              color: AppColors.brandRed,
                            ),
                            const SizedBox(width: AppDimensions.spacingXs),
                            Flexible(child: Text(sortLabelBuilder(sort))),
                          ],
                        ),
                      );
                    })
                    .toList(growable: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyReviewCard extends StatelessWidget {
  final CompanyReviewItem review;
  final String anonymousReviewerLabel;
  final String noCommentLabel;
  final String noDateLabel;

  const _CompanyReviewCard({
    required this.review,
    required this.anonymousReviewerLabel,
    required this.noCommentLabel,
    required this.noDateLabel,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = (review.customerName ?? '').trim().isEmpty
        ? anonymousReviewerLabel
        : review.customerName!.trim();
    final text = review.comment?.trim();
    final date = review.createdAt;
    final locale = Localizations.localeOf(context).toString();
    final dateLabel = date == null
        ? noDateLabel
        : DateFormat.yMMMd(locale).format(date.toLocal());
    final hasRating = review.rating != null;
    final ratingValue = (review.rating ?? 0).clamp(0, 5).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.55)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewAvatar(
                name: displayName,
                anonymousLabel: anonymousReviewerLabel,
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: AppTypography.heading3.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    _MetaChip(icon: Icons.schedule_rounded, label: dateLabel),
                  ],
                ),
              ),
              if (hasRating) _RatingBadge(value: ratingValue),
            ],
          ),
          if (hasRating) ...[
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                RatingBarIndicator(
                  rating: ratingValue,
                  itemBuilder: (context, index) =>
                      const Icon(Icons.star_rounded, color: Color(0xFFFFB300)),
                  itemCount: 5,
                  itemSize: 20,
                  unratedColor: AppColors.divider,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  ratingValue.toStringAsFixed(1),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppDimensions.spacingMd),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingSm),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
            ),
            child: Text(
              (text != null && text.isNotEmpty) ? text : noCommentLabel,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewAvatar extends StatelessWidget {
  final String name;
  final String anonymousLabel;

  const _ReviewAvatar({required this.name, required this.anonymousLabel});

  @override
  Widget build(BuildContext context) {
    final isAnonymous = name == anonymousLabel;
    final trimmedName = name.trim();
    final initial = isAnonymous || trimmedName.isEmpty
        ? '?'
        : trimmedName[0].toUpperCase();

    final bgColor = isAnonymous
        ? AppColors.buttonSecondary
        : AppColors.brandRed.withValues(alpha: 0.12);
    final textColor = isAnonymous
        ? AppColors.textSecondary
        : AppColors.brandRed;

    return CircleAvatar(
      radius: 22,
      backgroundColor: bgColor,
      child: Text(
        initial,
        style: AppTypography.bodyMedium.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXs,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.buttonSecondary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double value;

  const _RatingBadge({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: AppDimensions.paddingXs,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB300).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 16),
          const SizedBox(width: 4),
          Text(
            value.toStringAsFixed(1),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
