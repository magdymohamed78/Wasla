import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/discovery_types.dart';
import '../../../home/domain/use_cases/customer_portal_use_cases.dart';
import '../cubit/customer_requests_cubit.dart';

class CustomerRequestsPage extends StatelessWidget {
  const CustomerRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerRequestsCubit>(
      create: (context) => CustomerRequestsCubit(
        getCustomerServiceRequestsUseCase: context
            .read<GetCustomerServiceRequestsUseCase>(),
      )..load(),
      child: const _CustomerRequestsView(),
    );
  }
}

class _CustomerRequestsView extends StatelessWidget {
  const _CustomerRequestsView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<CustomerRequestsCubit, CustomerRequestsState>(
          builder: (context, state) {
            if (state.status == LoadStatus.loading ||
                state.status == LoadStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == LoadStatus.error) {
              return _RetryState(
                message: localizations.networkErrorServer,
                onRetry: context.read<CustomerRequestsCubit>().load,
              );
            }

            if (state.status == LoadStatus.empty) {
              return const _EmptyState(message: 'No requests yet.');
            }

            return RefreshIndicator(
              onRefresh: context.read<CustomerRequestsCubit>().load,
              child: ListView.separated(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                itemCount: state.items.length,
                separatorBuilder: (_, index) =>
                    const SizedBox(height: AppDimensions.spacingSm),
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  final subtitleParts = <String>[
                    if (item.serviceType != null) item.serviceType!,
                    if (item.status != null) item.status!,
                  ];

                  return Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusLg,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.companyName ?? 'Company #${item.companyId}',
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Text(
                          subtitleParts.join(' • '),
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (item.referenceNumber != null) ...[
                          const SizedBox(height: AppDimensions.spacingXs),
                          Text(
                            'Ref: ${item.referenceNumber}',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RetryState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _RetryState({required this.message, required this.onRetry});

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
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Text(
          message,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
