import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/types/load_status.dart';
import '../../../../core/widgets/company_logo_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../home/domain/use_cases/get_customer_service_request_details_use_case.dart';
import '../../domain/entities/request_filter.dart';
import '../../domain/entities/service_request_details.dart';
import '../cubit/request_details_cubit.dart';
import '../cubit/request_details_state.dart';
import '../widgets/request_details_skeleton.dart';

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
                _StatusBadge(
                  label: details.rawStatus ?? '',
                  color: statusColor,
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
            return const RequestDetailsSkeleton();
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
  final ServiceRequestDetails details;

  const _DetailsContent({required this.details});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CompanySection(details: details),
          const SizedBox(height: AppDimensions.spacingMd),
          _LocationsCard(details: details),
          const SizedBox(height: AppDimensions.spacingMd),
          _DateTimeCard(
            icon: Icons.calendar_today_outlined,
            label: localizations.requestDetailsPreferredDate,
            value: _formatDate(context, details.preferredDate),
          ),
          if (details.preferredTimeSlot != null &&
              details.preferredTimeSlot!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingMd),
            _DateTimeCard(
              icon: Icons.access_time,
              label: localizations.requestDetailsTimeSlot,
              value: details.preferredTimeSlot!,
            ),
          ],
          if (details.hasNotes) ...[
            const SizedBox(height: AppDimensions.spacingMd),
            _NotesSection(notes: details.notes!),
          ],
          if (details.hasOffer) ...[
            const SizedBox(height: AppDimensions.spacingMd),
            _LinkedOfferSection(details: details),
          ],
          const SizedBox(height: AppDimensions.spacingLg),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) {
      return AppLocalizations.of(context).requestDetailsNotAvailable;
    }
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('d/M/yyyy', locale).format(date);
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CompanySection extends StatelessWidget {
  final ServiceRequestDetails details;

  const _CompanySection({required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CompanyLogoWidget(logoUrl: details.companyLogoUrl),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.companyName ?? 'Company #${details.companyId}',
                  style: AppTypography.heading3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (details.serviceType != null &&
                    details.serviceType!.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.spacingXs),
                  _ServiceTypeChip(label: details.serviceType!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceTypeChip extends StatelessWidget {
  final String label;

  const _ServiceTypeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: AppDimensions.spacingXs + 1,
      ),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusRound),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _LocationsCard extends StatelessWidget {
  final ServiceRequestDetails details;

  const _LocationsCard({required this.details});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TimelineIndicator(),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LocationItem(
                    label: localizations.requestDetailsFromPickup,
                    address: details.fromAddress,
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _LocationItem(
                    label: localizations.requestDetailsToDropoff,
                    address: details.toAddress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.brandRed.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.location_on,
            size: AppDimensions.iconSizeSm,
            color: AppColors.brandRed,
          ),
        ),
        Container(width: 2, height: 28, color: AppColors.divider),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.statusAccepted.withValues(alpha: 0.20),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.flag_outlined,
            size: AppDimensions.iconSizeSm,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _LocationItem extends StatelessWidget {
  final String label;
  final String address;

  const _LocationItem({required this.label, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        Text(
          address.isEmpty
              ? AppLocalizations.of(context).requestDetailsNotAvailable
              : address,
          style: AppTypography.bodyLarge.copyWith(
            color: address.isEmpty
                ? AppColors.textSecondary
                : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DateTimeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DateTimeCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.brandRed.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
            ),
            child: Icon(
              icon,
              size: AppDimensions.iconSizeMd - 2,
              color: AppColors.brandRed,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  final String notes;

  const _NotesSection({required this.notes});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
          child: Text(
            localizations.requestDetailsCustomerNotes,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: AppColors.brandRed,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.borderRadiusLg),
                      bottomLeft: Radius.circular(AppDimensions.borderRadiusLg),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    child: Text(
                      notes,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LinkedOfferSection extends StatelessWidget {
  final ServiceRequestDetails details;

  const _LinkedOfferSection({required this.details});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final offerStatusColor = _resolveOfferStatusColor(details.offerStatus);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  localizations.requestDetailsLinkedOffer,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (details.offerStatus != null)
                _StatusBadge(
                  label: details.offerStatus!,
                  color: offerStatusColor,
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            details.offerNumber ?? '',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppDimensions.spacingMd),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.requestDetailsEstimatedTotal,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatCurrency(details.offerTotalAmount),
                style: AppTypography.heading3.copyWith(
                  color: AppColors.brandRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          PrimaryButton(
            label: localizations.requestDetailsViewOffer,
            onPressed: () {
              if (details.offerId != null) {
                context.push(
                  AppRouter.offerDetailsLocation(
                    details.offerId!,
                    sourceRequestId: details.serviceRequestId,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double? amount) {
    if (amount == null) return '';
    return '\$${amount.toStringAsFixed(2)}';
  }

  Color _resolveOfferStatusColor(String? status) {
    if (status == null) return AppColors.textSecondary;
    final lower = status.toLowerCase();
    if (lower.contains('accept')) return AppColors.statusAccepted;
    if (lower.contains('reject') || lower.contains('declin')) {
      return AppColors.statusDeclined;
    }
    if (lower.contains('cancel')) return AppColors.statusCanceled;
    if (lower.contains('expire')) return AppColors.statusExpired;
    if (lower.contains('pending')) return AppColors.statusPending;
    return AppColors.textSecondary;
  }
}
