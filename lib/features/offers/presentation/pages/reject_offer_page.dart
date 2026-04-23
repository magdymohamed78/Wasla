import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/types/load_status.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../domain/entities/offer_details.dart';
import '../../domain/use_cases/reject_offer_use_case.dart';
import '../cubit/reject_offer_cubit.dart';
import '../cubit/reject_offer_state.dart';
import '../widgets/offer_summary_card.dart';

class RejectOfferPage extends StatelessWidget {
  final int offerId;
  final OfferDetails? offerDetails;

  const RejectOfferPage({super.key, required this.offerId, this.offerDetails});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RejectOfferCubit(
        offerId: offerId,
        rejectOfferUseCase: context.read<RejectOfferUseCase>(),
      ),
      child: _RejectOfferView(offerDetails: offerDetails, offerId: offerId),
    );
  }
}

class _RejectOfferView extends StatelessWidget {
  final OfferDetails? offerDetails;
  final int offerId;

  const _RejectOfferView({this.offerDetails, required this.offerId});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocListener<RejectOfferCubit, RejectOfferState>(
      listener: (context, state) {
        if (state.status == LoadStatus.success) {
          ToastUtils.showSuccess(context, l.rejectOfferSuccess);
          // Navigate back to offer details to show refreshed Rejected status.
          // Pop with a result so the details page knows to refresh.
          context.pop(true);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l.rejectOfferTitle, style: AppTypography.heading3),
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        body: BlocBuilder<RejectOfferCubit, RejectOfferState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Warning header
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.brandRed.withValues(alpha: 0.1),
                            ),
                            child: const Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.brandRed,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l.rejectOfferWarningHeader,
                          style: AppTypography.heading2.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l.rejectOfferWarningText,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Offer summary
                        if (offerDetails != null)
                          OfferSummaryCard(
                            offerNumber: offerDetails!.offerNumber,
                            offerId: offerDetails!.offerId,
                            companyName: offerDetails!.companyName,
                            totalAmount: offerDetails!.totalAmount,
                            isRejectPage: true,
                            status: offerDetails!.status,
                          ),
                        const SizedBox(height: 32),

                        // Rejection reason field
                        RichText(
                          text: TextSpan(
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                            children: [
                              TextSpan(text: l.rejectionReasonLabel),
                              const TextSpan(
                                text: '*',
                                style: TextStyle(color: AppColors.brandRed),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          onChanged: (value) {
                            context.read<RejectOfferCubit>().updateReason(
                              value,
                            );
                          },
                          maxLines: 5,
                          maxLength: 2000,
                          decoration: InputDecoration(
                            hintText: l.rejectOfferReasonHint,
                            hintStyle: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            errorText: _reasonError(state.errorCode, l),
                            counterStyle: AppTypography.bodySmall.copyWith(
                              color: AppColors.brandRed.withValues(alpha: 0.4),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        // API error feedback
                        if (_isApiError(state.errorCode)) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(
                              AppDimensions.paddingSm,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusMd,
                              ),
                            ),
                            child: Text(
                              _apiErrorMessage(state.errorCode, l),
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: l.rejectOfferSubmit,
                          isLoading: state.isSubmitting,
                          onPressed: state.isSubmitting
                              ? null
                              : () => context.read<RejectOfferCubit>().submit(),
                        ),
                        const SizedBox(height: 16),
                        SecondaryButton(
                          label: l.rejectOfferCancel.toUpperCase(),
                          onPressed: state.isSubmitting
                              ? null
                              : () => context.pop(),
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String? _reasonError(String? errorCode, AppLocalizations l) {
    if (errorCode == 'REASON_REQUIRED') return l.rejectOfferReasonRequired;
    if (errorCode == 'REASON_TOO_LONG') return l.rejectOfferReasonTooLong;
    return null;
  }

  bool _isApiError(String? errorCode) {
    return errorCode == RejectOfferState.terminalStateError ||
        errorCode == RejectOfferState.forbiddenError ||
        errorCode == RejectOfferState.genericError;
  }

  String _apiErrorMessage(String? errorCode, AppLocalizations l) {
    switch (errorCode) {
      case RejectOfferState.terminalStateError:
        return l.rejectOfferTerminalState;
      case RejectOfferState.forbiddenError:
        return l.rejectOfferForbidden;
      default:
        return l.rejectOfferFailed;
    }
  }
}
