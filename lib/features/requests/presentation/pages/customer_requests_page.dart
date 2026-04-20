import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/logo_preload_helper.dart';
import '../../../../core/widgets/load_more_footer.dart';
import '../../../home/domain/use_cases/customer_portal_use_cases.dart';
import '../../domain/entities/request_filter.dart';
import '../../domain/entities/request_status_counts.dart';
import '../cubit/customer_requests_cubit.dart';
import '../cubit/customer_requests_state.dart';
import '../widgets/request_card.dart';
import '../widgets/request_card_skeleton.dart';
import '../widgets/request_filter_tabs.dart';

class CustomerRequestsPage extends StatelessWidget {
  final int? ensureRequestId;
  final String? refreshToken;

  const CustomerRequestsPage({
    super.key,
    this.ensureRequestId,
    this.refreshToken,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerRequestsCubit>(
      create: (context) => CustomerRequestsCubit(
        getCustomerServiceRequestsUseCase: context
            .read<GetCustomerServiceRequestsUseCase>(),
        getCustomerServiceRequestDetailsUseCase: context
            .read<GetCustomerServiceRequestDetailsUseCase>(),
      ),
      child: _CustomerRequestsView(
        ensureRequestId: ensureRequestId,
        refreshToken: refreshToken,
      ),
    );
  }
}

class _CustomerRequestsView extends StatefulWidget {
  final int? ensureRequestId;
  final String? refreshToken;

  const _CustomerRequestsView({
    required this.ensureRequestId,
    required this.refreshToken,
  });

  @override
  State<_CustomerRequestsView> createState() => _CustomerRequestsViewState();
}

class _CustomerRequestsViewState extends State<_CustomerRequestsView> {
  @override
  void initState() {
    super.initState();
    _loadOnOpen();
  }

  @override
  void didUpdateWidget(covariant _CustomerRequestsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken ||
        oldWidget.ensureRequestId != widget.ensureRequestId) {
      debugPrint(
        '[CustomerRequestsPage] route refresh trigger '
        'oldRefresh=${oldWidget.refreshToken} '
        'newRefresh=${widget.refreshToken} '
        'oldEnsure=${oldWidget.ensureRequestId} '
        'newEnsure=${widget.ensureRequestId}',
      );
      _loadOnOpen();
    }
  }

  void _loadOnOpen() {
    debugPrint(
      '[CustomerRequestsPage] loading requests on open '
      'ensureRequestId=${widget.ensureRequestId} '
      'refreshToken=${widget.refreshToken}',
    );
    context.read<CustomerRequestsCubit>().onPageOpened(
      ensureRequestId: widget.ensureRequestId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).requestsPageTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<CustomerRequestsCubit, CustomerRequestsState>(
            builder: (context, state) {
              return RequestFilterTabs(
                activeFilter: state.activeFilter,
                counts: _buildCountsMap(state.globalCounts),
                onFilterChanged: (filter) {
                  context.read<CustomerRequestsCubit>().changeFilter(filter);
                },
              );
            },
          ),
          Expanded(
            child: BlocBuilder<CustomerRequestsCubit, CustomerRequestsState>(
              builder: (context, state) {
                return _buildBody(context, state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CustomerRequestsState state) {
    if (state.status == CustomerRequestsViewStatus.initial ||
        state.status == CustomerRequestsViewStatus.loading) {
      return const RequestCardSkeleton(count: 5);
    }

    if (state.status == CustomerRequestsViewStatus.error) {
      return _ErrorState(
        onBrowseCompanies: () => context.go(AppRouter.allCompanies),
        onRetry: () => context.read<CustomerRequestsCubit>().retry(),
      );
    }

    if (state.status == CustomerRequestsViewStatus.empty) {
      return _EmptyState(
        onBrowseCompanies: () => context.go(AppRouter.home),
        onRetry: () => context.read<CustomerRequestsCubit>().retry(),
      );
    }

    return _RequestList(state: state);
  }

  Map<RequestFilter, int> _buildCountsMap(RequestStatusCounts counts) {
    return {
      RequestFilter.all: counts.all,
      RequestFilter.pending: counts.pending,
      RequestFilter.offerSent: counts.offerSent,
      RequestFilter.declined: counts.declined,
      RequestFilter.expired: counts.expired,
    };
  }
}

class _RequestList extends StatefulWidget {
  final CustomerRequestsState state;

  const _RequestList({required this.state});

  @override
  State<_RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<_RequestList> {
  String _lastPreloadSignature = '';

  @override
  void initState() {
    super.initState();
    _precacheVisibleLogos();
  }

  @override
  void didUpdateWidget(covariant _RequestList oldWidget) {
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

  String _itemsSignature(CustomerRequestsState state) {
    return state.items
        .map(
          (item) =>
              '${item.serviceRequestId}:${item.companyLogoUrl?.trim() ?? ''}',
        )
        .join('|');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return RefreshIndicator(
      color: AppColors.brandRed,
      onRefresh: () => context.read<CustomerRequestsCubit>().refresh(),
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
              child: RequestCard(
                companyLogoUrl: item.companyLogoUrl,
                companyName: item.companyName ?? 'Company #${item.companyId}',
                referenceNumber: item.referenceNumber,
                statusLabel: item.rawStatus ?? '',
                statusColor: RequestFilter.resolveColor(item.normalizedFilter),
                serviceType: item.serviceType,
                preferredDateLabel: _labeledDate(
                  context,
                  item.preferredDate,
                  localizations.requestsDetailsPreferredDate,
                ),
                submissionDateLabel: _labeledDate(
                  context,
                  item.createdAt,
                  localizations.requestsDetailsSubmissionDate,
                ),
                onViewRequest: () {
                  context.push(
                    AppRouter.requestDetailsLocation(item.serviceRequestId),
                  );
                },
              ),
            );
          }

          return LoadMoreFooter(
            isLoadingMore: widget.state.isLoadingMore,
            hasReachedEnd: widget.state.hasReachedEnd,
            onLoadMore:
                () => context.read<CustomerRequestsCubit>().loadMore(),
            noMoreItemsLabel: localizations.noMoreItems,
          );
        },
      ),
    );
  }

  String? _formatDate(BuildContext context, DateTime? date) {
    if (date == null) return null;
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.yMMMd(locale).format(date);
  }

  String? _labeledDate(BuildContext context, DateTime? date, String label) {
    final formatted = _formatDate(context, date);
    if (formatted == null) return null;
    return '$label: $formatted';
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onBrowseCompanies;
  final VoidCallback onRetry;

  const _EmptyState({required this.onBrowseCompanies, required this.onRetry});

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
                Icons.inbox_outlined,
                size: AppDimensions.iconSizeLg,
                color: AppColors.brandRed.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              localizations.requestsEmptyTitle,
              style: AppTypography.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              localizations.requestsEmptyMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBrowseCompanies,
                child: Text(localizations.requestsEmptyBrowseCompanies),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                localizations.requestsRetry,
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
  final VoidCallback onBrowseCompanies;
  final VoidCallback onRetry;

  const _ErrorState({required this.onBrowseCompanies, required this.onRetry});

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
              localizations.requestsErrorTitle,
              style: AppTypography.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              localizations.requestsErrorMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBrowseCompanies,
                child: Text(localizations.requestsEmptyBrowseCompanies),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                localizations.requestsRetry,
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
