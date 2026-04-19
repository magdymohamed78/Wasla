import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../home/domain/repositories/customer_offers_repository.dart';
import '../../domain/entities/offer_filter.dart';
import '../cubit/customer_offers_cubit.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_card_skeleton.dart';
import '../widgets/offer_filter_tabs.dart';

class CustomerOffersPage extends StatelessWidget {
  final OfferFilter initialFilter;

  const CustomerOffersPage({
    super.key,
    this.initialFilter = OfferFilter.all,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerOffersCubit>(
      create: (context) => CustomerOffersCubit(
        repository: context.read<CustomerOffersRepository>(),
      )..load(initialFilter: initialFilter),
      child: const _CustomerOffersView(),
    );
  }
}

class _CustomerOffersView extends StatelessWidget {
  const _CustomerOffersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).offersPageTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<CustomerOffersCubit, CustomerOffersState>(
            builder: (context, state) {
              return OfferFilterTabs(
                activeFilter: state.activeFilter,
                counts: state.globalCounts,
                onFilterChanged: (filter) {
                  context.read<CustomerOffersCubit>().changeFilter(filter);
                },
              );
            },
          ),
          Expanded(
            child: BlocBuilder<CustomerOffersCubit, CustomerOffersState>(
              builder: (context, state) {
                return _buildBody(context, state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CustomerOffersState state) {
    if (state.status == CustomerOffersViewStatus.initial ||
        state.status == CustomerOffersViewStatus.loading) {
      return const OfferCardSkeleton(count: 5);
    }

    if (state.status == CustomerOffersViewStatus.error) {
      return _ErrorState(
        onRetry: () => context.read<CustomerOffersCubit>().retry(),
      );
    }

    if (state.status == CustomerOffersViewStatus.empty) {
      return _EmptyState(
        onExploreCompanies: () => context.go(AppRouter.home),
        onBackToRequests: () => context.go(AppRouter.customerRequests),
      );
    }

    return _OfferList(state: state);
  }
}

class _OfferList extends StatefulWidget {
  final CustomerOffersState state;

  const _OfferList({required this.state});

  @override
  State<_OfferList> createState() => _OfferListState();
}

class _OfferListState extends State<_OfferList> {
  final _scrollController = ScrollController();

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
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CustomerOffersCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.brandRed,
      onRefresh: () => context.read<CustomerOffersCubit>().load(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
        ),
        itemCount:
            widget.state.items.length + (widget.state.hasReachedEnd ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= widget.state.items.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingMd,
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.brandRed,
                  ),
                ),
              ),
            );
          }

          final item = widget.state.items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            child: OfferCard(
              offer: item,
              onTap: () {
                context.push(AppRouter.offerDetailsLocation(item.offerId));
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onExploreCompanies;
  final VoidCallback onBackToRequests;

  const _EmptyState({
    required this.onExploreCompanies,
    required this.onBackToRequests,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.brandRed.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_offer_outlined,
                size: AppDimensions.iconSizeLg,
                color: AppColors.brandRed.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              localizations.offersEmptyTitle,
              style: AppTypography.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              localizations.offersEmptyMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            PrimaryButton(
              label: localizations.offersExploreCompanies,
              onPressed: onExploreCompanies,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            TextButton.icon(
              onPressed: onBackToRequests,
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
              label: Text(
                localizations.offersBackToRequests,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: AppDimensions.iconSizeLg,
                color: AppColors.error.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              localizations.offersErrorTitle,
              style: AppTypography.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              localizations.offersErrorMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.borderRadiusMd),
                  ),
                ),
                child: Text(localizations.offersRetry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
