import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../domain/entities/offer_details.dart';
import '../../domain/entities/offer_filter.dart';
import '../../domain/use_cases/get_offer_details_use_case.dart';
import '../cubit/offer_details_cubit.dart';
import '../cubit/offer_details_state.dart';
import '../../../../core/types/load_status.dart';
import '../widgets/service_type_chips.dart';
import '../widgets/offer_total_card.dart';
import '../widgets/offer_savings_card.dart';
import '../widgets/offer_locations_section.dart';
import '../widgets/offer_service_line_item_card.dart';
import '../widgets/offer_insurance_section.dart';
import '../widgets/offer_included_in_price_section.dart';
import '../widgets/offer_attachment_row.dart';
import '../widgets/offer_details_skeleton.dart';

class OfferDetailsPage extends StatelessWidget {
  final int offerId;
  final int? sourceRequestId;

  const OfferDetailsPage({
    super.key,
    required this.offerId,
    this.sourceRequestId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfferDetailsCubit(
        offerId: offerId,
        getDetailsUseCase: context.read<GetOfferDetailsUseCase>(),
      )..load(),
      child: _OfferDetailsView(sourceRequestId: sourceRequestId),
    );
  }
}

class _OfferDetailsView extends StatelessWidget {
  final int? sourceRequestId;

  const _OfferDetailsView({this.sourceRequestId});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }

            if (sourceRequestId != null && sourceRequestId! > 0) {
              context.go(AppRouter.requestDetailsLocation(sourceRequestId!));
              return;
            }

            context.go(AppRouter.customerOffersLocation());
          },
        ),
        title: BlocBuilder<OfferDetailsCubit, OfferDetailsState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.details?.offerNumber != current.details?.offerNumber ||
              previous.details?.status != current.details?.status ||
              previous.details?.normalizedFilter !=
                  current.details?.normalizedFilter,
          builder: (context, state) {
            final details = state.details;
            if (details == null || state.status != LoadStatus.success) {
              return Text(l.offerDetailsTitle, style: AppTypography.heading3);
            }

            final offerIdentifier = details.offerNumber ?? '${details.offerId}';
            final offerStatus = details.status?.trim() ?? '';
            final statusColor = OfferFilter.resolveColor(
              details.normalizedFilter,
            );

            return Row(
              children: [
                Flexible(
                  child: Text(
                    offerIdentifier,
                    style: AppTypography.heading3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (offerStatus.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _StatusBadge(label: offerStatus, color: statusColor),
                ],
              ],
            );
          },
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: BlocBuilder<OfferDetailsCubit, OfferDetailsState>(
        builder: (context, state) {
          if (state.status == LoadStatus.loading ||
              state.status == LoadStatus.initial) {
            return const OfferDetailsSkeleton();
          }

          if (state.status == LoadStatus.error) {
            return _ErrorView(errorCode: state.errorCode);
          }

          final details = state.details;
          if (details == null) {
            return _ErrorView(errorCode: OfferDetailsState.loadFailedError);
          }

          return _SuccessBody(details: details);
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String? errorCode;

  const _ErrorView({this.errorCode});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    String message;
    switch (errorCode) {
      case OfferDetailsState.notFoundError:
        message = l.offerNotFound;
        break;
      case OfferDetailsState.accessDeniedError:
        message = l.offerAccessDenied;
        break;
      default:
        message = l.offerLoadFailed;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 56,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.read<OfferDetailsCubit>().load(),
              icon: const Icon(Icons.refresh),
              label: Text(l.offerDetailsRetry),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandRed,
              ),
            ),
          ],
        ),
      ),
    );
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

class _SuccessBody extends StatelessWidget {
  final OfferDetails details;

  const _SuccessBody({required this.details});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                // Company name
                if (details.companyName != null) ...[
                  Text(
                    details.companyName!,
                    style: AppTypography.heading3.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                ],

                // ── Service type chips ──
                ServiceTypeChips(
                  serviceTypeOverall: details.serviceTypeOverall,
                ),

                const SizedBox(height: AppDimensions.spacingMd),

                // ── Total card ──
                OfferTotalCard(
                  totalAmount: details.totalAmount,
                  costsIncludeVAT: details.costsIncludeVAT,
                  insurance: details.insurance,
                ),

                // ── Savings card ──
                if (details.hasDiscount) ...[
                  const SizedBox(height: 12),
                  OfferSavingsCard(discountAmount: details.discountAmount),
                ],

                // ── Locations section ──
                if (details.locations.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  OfferLocationsSection(locations: details.locations),
                ],

                // ── Service line items ──
                if (details.serviceLineItems.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.spacingLg),
                  Text(
                    l.servicesTitle,
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  ...details.serviceLineItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: OfferServiceLineItemCard(item: item),
                    ),
                  ),
                ],

                // ── Insurance section ──
                if (details.insurance != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    l.insuranceTitle,
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OfferInsuranceSection(insurance: details.insurance),
                ],

                // ── Included in price section ──
                if (details.includedInPrice != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    l.includedInPriceTitle,
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OfferIncludedInPriceSection(
                    includedInPrice: details.includedInPrice,
                  ),
                ],

                // ── Attachment row ──
                if (details.hasAttachment) ...[
                  const SizedBox(height: 20),
                  Text(
                    l.attachmentTitle,
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OfferAttachmentRow(
                    pdfUrl: details.pdfUrl!,
                    onDownload: () =>
                        _downloadAttachment(context, details.pdfUrl!),
                  ),
                ],

          // ── Action buttons at end of page (not pinned) ──
          if (details.canAccept || details.canReject) ...[
            const SizedBox(height: 24),
            _ActionButtons(details: details),
          ] else
            const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _downloadAttachment(BuildContext context, String url) async {
    final l = AppLocalizations.of(context);

    final uri = Uri.tryParse(url);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        if (context.mounted) ToastUtils.showError(context, l.downloadFailed);
      }
    } else {
      if (context.mounted) ToastUtils.showError(context, l.downloadFailed);
    }
  }
}

class _ActionButtons extends StatelessWidget {
  final OfferDetails details;

  const _ActionButtons({required this.details});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (details.canAccept)
          PrimaryButton(
            label: l.acceptOffer,
            onPressed: () {
              context.go(
                AppRouter.acceptOfferLocation(details.offerId),
                extra: details,
              );
            },
          ),
        if (details.canAccept && details.canReject)
          const SizedBox(height: 12),
        if (details.canReject)
          SecondaryButton(
            label: l.rejectOffer,
            onPressed: () {
              context.go(
                AppRouter.rejectOfferLocation(details.offerId),
                extra: details,
              );
            },
          ),
      ],
    );
  }
}
