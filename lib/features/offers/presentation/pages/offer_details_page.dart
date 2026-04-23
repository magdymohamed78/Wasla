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
import '../../domain/entities/offer_details.dart';
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

  const OfferDetailsPage({super.key, required this.offerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfferDetailsCubit(
        offerId: offerId,
        getDetailsUseCase: context.read<GetOfferDetailsUseCase>(),
      )..load(),
      child: const _OfferDetailsView(),
    );
  }
}

class _OfferDetailsView extends StatelessWidget {
  const _OfferDetailsView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: BlocBuilder<OfferDetailsCubit, OfferDetailsState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.details?.offerNumber != current.details?.offerNumber ||
              previous.details?.status != current.details?.status,
          builder: (context, state) {
            final details = state.details;
            if (details == null || state.status != LoadStatus.success) {
              return Text(l.offerDetailsTitle, style: AppTypography.heading3);
            }

            final offerTitle = details.offerNumber != null
                ? '${l.offerNumberLabel}${details.offerNumber}'
                : '${l.offerNumberLabel}${details.offerId}';

            return Text(
              offerTitle,
              style: AppTypography.heading3.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
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

class _SuccessBody extends StatelessWidget {
  final OfferDetails details;

  const _SuccessBody({required this.details});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company name
                if (details.companyName != null) ...[
                  Text(
                    details.companyName!,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Service type chips ──
                ServiceTypeChips(
                  serviceTypeOverall: details.serviceTypeOverall,
                ),

                const SizedBox(height: 16),

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
                  const SizedBox(height: 24),
                  Text(
                    l.servicesTitle,
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
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

                // Bottom spacing for action buttons
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // ── Action buttons (only for pending offers) ──
        if (details.canAccept || details.canReject)
          _ActionButtons(details: details),
      ],
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

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (details.canAccept)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    context.push(
                      AppRouter.acceptOfferLocation(details.offerId),
                      extra: details,
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brandRed,
                    minimumSize: const Size.fromHeight(
                      AppDimensions.buttonHeight,
                    ),
                  ),
                  child: Text(l.acceptOffer),
                ),
              ),
            if (details.canAccept && details.canReject)
              const SizedBox(height: 12),
            if (details.canReject)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.push(
                      AppRouter.rejectOfferLocation(details.offerId),
                      extra: details,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      AppDimensions.buttonHeight,
                    ),
                    side: const BorderSide(color: AppColors.brandRed),
                  ),
                  child: Text(
                    l.rejectOffer,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.brandRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
