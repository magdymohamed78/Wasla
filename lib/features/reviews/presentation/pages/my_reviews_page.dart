import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/types/load_status.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../home/domain/entities/customer_review_item.dart';
import '../../../home/domain/repositories/customer_reviews_repository.dart';
import '../cubit/my_reviews_cubit.dart';
import '../cubit/my_reviews_state.dart';
import '../widgets/delete_review_confirmation_modal.dart';
import '../widgets/edit_review_modal.dart';
import '../widgets/my_review_card.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyReviewsCubit>(
      create: (context) => MyReviewsCubit(
        reviewsRepository: context.read<CustomerReviewsRepository>(),
      )..load(),
      child: const _MyReviewsView(),
    );
  }
}

class _MyReviewsView extends StatefulWidget {
  const _MyReviewsView();

  @override
  State<_MyReviewsView> createState() => _MyReviewsViewState();
}

enum _ReviewDateSort { newest, oldest }

class _MyReviewsViewState extends State<_MyReviewsView> {
  final ScrollController _scrollController = ScrollController();
  _ReviewDateSort _selectedDateSort = _ReviewDateSort.newest;

  Future<void> _refreshPage() {
    return context.read<MyReviewsCubit>().refresh();
  }

  List<CustomerReviewItem> _sortedReviews(List<CustomerReviewItem> items) {
    final sortedItems = List<CustomerReviewItem>.from(items);
    sortedItems.sort((a, b) {
      final dateA = _resolvedSortDate(a);
      final dateB = _resolvedSortDate(b);

      if (_selectedDateSort == _ReviewDateSort.newest) {
        return dateB.compareTo(dateA);
      }

      return dateA.compareTo(dateB);
    });
    return sortedItems;
  }

  DateTime _resolvedSortDate(CustomerReviewItem item) {
    return item.updatedAt ??
        item.createdAt ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _sortLabel(_ReviewDateSort sortType) {
    if (sortType == _ReviewDateSort.newest) {
      return 'Newest';
    }
    return 'Oldest';
  }

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
      context.read<MyReviewsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth >= 768
        ? AppDimensions.paddingXl
        : (screenWidth >= 540
              ? AppDimensions.paddingLg
              : AppDimensions.paddingMd);

    final sessionRole = context.select(
      (SessionCubit cubit) => cubit.state.role,
    );
    if (sessionRole != SessionRole.customer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        if (sessionRole == SessionRole.guest) {
          context.go(AppRouter.login);
          return;
        }
        context.go(AppRouter.home);
      });

      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.brandRed),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(localizations.myReviewsPageTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
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
          child: BlocBuilder<MyReviewsCubit, MyReviewsState>(
            builder: (context, state) {
              switch (state.status) {
                case LoadStatus.initial:
                case LoadStatus.loading:
                  return _MyReviewsSkeleton(
                    count: 5,
                    horizontalPadding: horizontalPadding,
                  );
                case LoadStatus.error:
                  return _MyReviewsErrorCard(
                    message: localizations.myReviewsLoadFailed,
                    retryLabel: localizations.networkErrorRetry,
                    onRetry: context.read<MyReviewsCubit>().load,
                    horizontalPadding: horizontalPadding,
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
                        _MyReviewsOverviewCard(
                          title: localizations.myReviewsPageTitle,
                          count: state.totalCount,
                          selectedSort: _selectedDateSort,
                          newestLabel: _sortLabel(_ReviewDateSort.newest),
                          oldestLabel: _sortLabel(_ReviewDateSort.oldest),
                          onSortChanged: (sortType) {
                            setState(() => _selectedDateSort = sortType);
                          },
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        _MyReviewsEmptyCard(
                          title: localizations.myReviewsEmptyTitle,
                          message: localizations.myReviewsEmptyMessage,
                        ),
                      ],
                    ),
                  );
                case LoadStatus.success:
                  final sortedItems = _sortedReviews(state.items);

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
                          (state.hasReachedEnd ? 0 : 1) +
                          1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimensions.spacingMd,
                            ),
                            child: _MyReviewsOverviewCard(
                              title: localizations.myReviewsPageTitle,
                              count: state.totalCount,
                              selectedSort: _selectedDateSort,
                              newestLabel: _sortLabel(_ReviewDateSort.newest),
                              oldestLabel: _sortLabel(_ReviewDateSort.oldest),
                              onSortChanged: (sortType) {
                                setState(() => _selectedDateSort = sortType);
                              },
                            ),
                          );
                        }

                        final reviewIndex = index - 1;
                        if (reviewIndex >= sortedItems.length) {
                          if (!state.isLoadingMore) {
                            return const SizedBox.shrink();
                          }
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
                          child: MyReviewCard(
                            review: review,
                            editLabel: localizations.myReviewsEditAction,
                            deleteLabel: localizations.myReviewsDeleteAction,
                            isMutating: state.isMutating,
                            onEdit: () => _onEditReview(review: review),
                            onDelete: () => _onDeleteReview(review: review),
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

  Future<void> _onEditReview({required CustomerReviewItem review}) async {
    final localizations = AppLocalizations.of(context);
    final payload = await EditReviewModal.show(context, review: review);
    if (payload == null || !mounted) {
      return;
    }

    final success = await context.read<MyReviewsCubit>().updateReview(
      reviewId: review.reviewId,
      companyId: review.companyId,
      rating: payload.rating,
      reviewText: payload.reviewText,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ToastUtils.showSuccess(context, localizations.myReviewsUpdatedSuccess);
    } else {
      final errorCode = context.read<MyReviewsCubit>().state.errorCode;
      if (errorCode == MyReviewsCubit.updateBadRequestError) {
        ToastUtils.showError(
          context,
          localizations.companyReviewsWriteErrorBadRequest,
        );
      } else {
        ToastUtils.showError(context, localizations.myReviewsLoadFailed);
      }
    }
  }

  Future<void> _onDeleteReview({required CustomerReviewItem review}) async {
    final localizations = AppLocalizations.of(context);
    final confirmed = await DeleteReviewConfirmationModal.show(context);
    if (confirmed != true || !mounted) {
      return;
    }

    final success = await context.read<MyReviewsCubit>().deleteReview(
      reviewId: review.reviewId,
      companyId: review.companyId,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ToastUtils.showSuccess(context, localizations.myReviewsDeletedSuccess);
    } else {
      ToastUtils.showError(context, localizations.myReviewsLoadFailed);
    }
  }
}

class _MyReviewsSkeleton extends StatelessWidget {
  final int count;
  final double horizontalPadding;

  const _MyReviewsSkeleton({
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
            height: 92,
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

class _MyReviewsErrorCard extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;
  final double horizontalPadding;

  const _MyReviewsErrorCard({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    required this.horizontalPadding,
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

class _MyReviewsEmptyCard extends StatelessWidget {
  final String title;
  final String message;

  const _MyReviewsEmptyCard({required this.title, required this.message});

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
              Icons.reviews_rounded,
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

class _MyReviewsOverviewCard extends StatelessWidget {
  final String title;
  final int count;
  final _ReviewDateSort selectedSort;
  final String newestLabel;
  final String oldestLabel;
  final ValueChanged<_ReviewDateSort> onSortChanged;

  const _MyReviewsOverviewCard({
    required this.title,
    required this.count,
    required this.selectedSort,
    required this.newestLabel,
    required this.oldestLabel,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
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
              child: DropdownButton<_ReviewDateSort>(
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
                  return [
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 18,
                          color: AppColors.brandRed,
                        ),
                        const SizedBox(width: AppDimensions.spacingXs),
                        Text(newestLabel),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.history_toggle_off_rounded,
                          size: 18,
                          color: AppColors.brandRed,
                        ),
                        const SizedBox(width: AppDimensions.spacingXs),
                        Text(oldestLabel),
                      ],
                    ),
                  ];
                },
                items: [
                  DropdownMenuItem<_ReviewDateSort>(
                    value: _ReviewDateSort.newest,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 18,
                          color: AppColors.brandRed,
                        ),
                        const SizedBox(width: AppDimensions.spacingXs),
                        Text(newestLabel),
                      ],
                    ),
                  ),
                  DropdownMenuItem<_ReviewDateSort>(
                    value: _ReviewDateSort.oldest,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.history_toggle_off_rounded,
                          size: 18,
                          color: AppColors.brandRed,
                        ),
                        const SizedBox(width: AppDimensions.spacingXs),
                        Text(oldestLabel),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
