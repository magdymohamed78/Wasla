import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/domain/entities/discovery_types.dart';
import '../../../home/domain/use_cases/customer_portal_use_cases.dart';
import '../cubit/customer_offers_cubit.dart';

class CustomerOffersPage extends StatelessWidget {
  const CustomerOffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerOffersCubit>(
      create: (context) => CustomerOffersCubit(
        getCustomerOffersUseCase: context.read<GetCustomerOffersUseCase>(),
      )..load(),
      child: const _CustomerOffersView(),
    );
  }
}

class _CustomerOffersView extends StatelessWidget {
  const _CustomerOffersView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<CustomerOffersCubit, CustomerOffersState>(
          builder: (context, state) {
            if (state.status == LoadStatus.loading ||
                state.status == LoadStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == LoadStatus.error) {
              return _RetryState(
                message: localizations.networkErrorServer,
                onRetry: context.read<CustomerOffersCubit>().load,
              );
            }

            if (state.status == LoadStatus.empty) {
              return const _EmptyState(message: 'No offers yet.');
            }

            return RefreshIndicator(
              onRefresh: context.read<CustomerOffersCubit>().load,
              child: ListView.separated(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                itemCount: state.items.length,
                separatorBuilder: (_, index) =>
                    const SizedBox(height: AppDimensions.spacingSm),
                itemBuilder: (context, index) {
                  final item = state.items[index];

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
                          item.status ?? 'Pending',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Text(
                          'Total: ${item.totalAmount.toStringAsFixed(2)}',
                          style: AppTypography.bodySmall,
                        ),
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
