import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/logo_preload_helper.dart';
import '../../../../core/widgets/load_more_footer.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../home/domain/repositories/customer_offers_repository.dart';
import '../../domain/entities/offer_filter.dart';
import '../cubit/customer_offers_cubit.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_card_skeleton.dart';
import '../widgets/offer_filter_tabs.dart';

class CustomerOffersPage extends StatelessWidget {
  final OfferFilter initialFilter;

  const CustomerOffersPage({super.key, this.initialFilter = OfferFilter.all});

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
  String _lastPreloadSignature = '';

  @override
  void initState() {
    super.initState();
    _precacheVisibleLogos();
  }

  @override
  void didUpdateWidget(covariant _OfferList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_itemsSignature(oldWidget.state) != _itemsSignature(widget.state)) {
      _precacheVisibleLogos();
    }
  }

  void _precacheVisibleLogos() {
    final logoUrls = widget.state.items
        .map((item) => item.companyLogoUrl)
        .toList(growable: false);
    final signature = _itemsSignature(widget.state);

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

  String _itemsSignature(CustomerOffersState state) {
    return state.items
        .map((item) => '${item.offerId}:${item.companyLogoUrl?.trim() ?? ''}')
        .join('|');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return RefreshIndicator(
      color: AppColors.brandRed,
      onRefresh: () => context.read<CustomerOffersCubit>().load(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
        ),
        itemCount: widget.state.items.length + 1,
        itemBuilder: (context, index) {
          if (index < widget.state.items.length) {
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
          }

          return LoadMoreFooter(
            isLoadingMore: widget.state.isLoadingMore,
            hasReachedEnd: widget.state.hasReachedEnd,
            onLoadMore: () => context.read<CustomerOffersCubit>().loadMore(),
            noMoreItemsLabel: localizations.noMoreItems,
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
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
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
