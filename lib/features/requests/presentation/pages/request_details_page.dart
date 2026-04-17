import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/types/load_status.dart';
import '../../../home/domain/use_cases/customer_portal_use_cases.dart';
import '../../domain/entities/request_details_compact.dart';
import '../../domain/entities/request_filter.dart';
import '../cubit/request_details_cubit.dart';
import '../cubit/request_details_state.dart';
import '../widgets/request_card_skeleton.dart';

class RequestDetailsPage extends StatelessWidget {
  final int serviceRequestId;

  const RequestDetailsPage({super.key, required this.serviceRequestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestDetailsCubit>(
      create: (context) => RequestDetailsCubit(
        serviceRequestId: serviceRequestId,
        getDetailsUseCase: context
            .read<GetCustomerServiceRequestDetailsUseCase>(),
      )..load(),
      child: const _RequestDetailsView(),
    );
  }
}

class _RequestDetailsView extends StatelessWidget {
  const _RequestDetailsView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: BlocBuilder<RequestDetailsCubit, RequestDetailsState>(
          builder: (context, state) {
            final details = state.details;
            if (details == null) {
              return Text(
                localizations.requestsDetailsTitle,
                style: AppTypography.heading3,
              );
            }
            final ref =
                details.referenceNumber ?? localizations.requestsDetailsTitle;
            final statusColor = RequestFilter.resolveColor(
              details.normalizedFilter,
            );
            return Row(
              children: [
                Flexible(
                  child: Text(
                    ref,
                    style: AppTypography.heading3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    details.rawStatus ?? '',
                    style: AppTypography.bodySmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: BlocBuilder<RequestDetailsCubit, RequestDetailsState>(
        builder: (context, state) {
          if (state.status == LoadStatus.initial ||
              state.status == LoadStatus.loading) {
            return const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
                vertical: AppDimensions.paddingLg,
              ),
              child: RequestCardSkeleton(count: 1),
            );
          }

          if (state.status == LoadStatus.error) {
            return _buildErrorState(context, state);
          }

          final details = state.details;
          if (details == null) {
            return _buildErrorState(context, state);
          }

          return _DetailsContent(details: details);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, RequestDetailsState state) {
    final localizations = AppLocalizations.of(context);
    final message = state.errorCode == RequestDetailsState.notFoundError
        ? localizations.requestsDetailsNotFound
        : state.errorCode == RequestDetailsState.accessDeniedError
        ? localizations.requestsDetailsAccessDenied
        : localizations.requestsErrorMessage;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              state.errorCode == RequestDetailsState.notFoundError
                  ? Icons.search_off
                  : Icons.error_outline,
              size: AppDimensions.iconSizeXl,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            TextButton(
              onPressed: () => context.read<RequestDetailsCubit>().load(),
              child: Text(localizations.requestsRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final RequestDetailsCompact details;

  const _DetailsContent({required this.details});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(
              label: localizations.requestsDetailsReference,
              value: details.referenceNumber ?? '-',
            ),
            const _DetailDivider(),
            _DetailRow(
              label: localizations.requestsDetailsCompany,
              value: details.companyName ?? 'Company #${details.companyId}',
            ),
            const _DetailDivider(),
            _DetailRow(
              label: localizations.requestsDetailsStatus,
              value: details.rawStatus ?? '-',
              valueColor: RequestFilter.resolveColor(details.normalizedFilter),
            ),
            const _DetailDivider(),
            _DetailRow(
              label: localizations.requestsDetailsServiceType,
              value: details.serviceType ?? '-',
            ),
            const _DetailDivider(),
            _DetailRow(
              label: localizations.requestsDetailsPreferredDate,
              value: details.preferredDate != null
                  ? DateFormat.yMMMd(locale).format(details.preferredDate!)
                  : localizations.requestsDateNotAvailable,
            ),
            const _DetailDivider(),
            _DetailRow(
              label: localizations.requestsDetailsSubmissionDate,
              value: details.createdAt != null
                  ? DateFormat.yMMMd(locale).format(details.createdAt!)
                  : localizations.requestsDateNotAvailable,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.divider, height: 1);
  }
}
