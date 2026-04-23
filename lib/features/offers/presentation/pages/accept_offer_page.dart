import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/types/load_status.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../domain/entities/offer_details.dart';
import '../../domain/use_cases/accept_offer_use_case.dart';
import '../cubit/accept_offer_cubit.dart';
import '../cubit/accept_offer_state.dart';
import '../widgets/offer_summary_card.dart';
import '../widgets/payment_method_selector.dart';

class AcceptOfferPage extends StatelessWidget {
  final int offerId;
  final OfferDetails? offerDetails;

  const AcceptOfferPage({super.key, required this.offerId, this.offerDetails});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AcceptOfferCubit(
        offerId: offerId,
        acceptOfferUseCase: context.read<AcceptOfferUseCase>(),
      ),
      child: _AcceptOfferView(offerDetails: offerDetails),
    );
  }
}

class _AcceptOfferView extends StatelessWidget {
  final OfferDetails? offerDetails;

  const _AcceptOfferView({this.offerDetails});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocListener<AcceptOfferCubit, AcceptOfferState>(
      listener: (context, state) {
        if (state.status == LoadStatus.success) {
          if (state.checkoutUrl != null) {
            // Online payment — open checkout URL
            _launchCheckoutUrl(context, state.checkoutUrl!);
          } else {
            // COD — navigate to offers list
            ToastUtils.showSuccess(context, l.acceptOfferSuccessCod);
            context.go(AppRouter.customerOffersLocation());
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(l.acceptOfferTitle, style: AppTypography.heading3),
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        body: BlocBuilder<AcceptOfferCubit, AcceptOfferState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.acceptOfferFinalizeTitle,
                          style: AppTypography.heading1.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l.acceptOfferFinalizeSubtitle(
                            offerDetails?.companyName ?? l.companyLabel,
                          ),
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Offer summary
                        if (offerDetails != null)
                          OfferSummaryCard(
                            offerNumber: offerDetails!.offerNumber,
                            offerId: offerDetails!.offerId,
                            companyName: offerDetails!.companyName,
                            totalAmount: offerDetails!.totalAmount,
                          ),
                        const SizedBox(height: 20),

                        // Payment method selection
                        Text(
                          l.acceptOfferPaymentRequired,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        PaymentMethodSelector(
                          selected: state.selectedPaymentMethod,
                          onChanged: (method) {
                            context
                                .read<AcceptOfferCubit>()
                                .selectPaymentMethod(method);
                          },
                        ),
                        if (state.errorCode == 'PAYMENT_REQUIRED') ...[
                          const SizedBox(height: 4),
                          Text(
                            l.acceptOfferPaymentRequired,
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),

                        // Signature field
                        Text(
                          l.acceptOfferDigitalSignatureLabel,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          onChanged: (value) {
                            context.read<AcceptOfferCubit>().updateSignature(
                              value,
                            );
                          },
                          decoration: InputDecoration(
                            hintText: l.acceptOfferSignatureHint,
                            hintStyle: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.surface,
                            suffixIcon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            errorText: _signatureError(state.errorCode, l),
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                            children: [
                              TextSpan(text: l.acceptOfferSignatureHintPart1),
                              TextSpan(
                                text: l.acceptOfferSignatureHintPart2,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.brandRed,
                                  fontSize: 11,
                                ),
                              ),
                              TextSpan(text: l.acceptOfferSignatureHintPart3),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Confirmation checkbox
                        Container(
                          padding: const EdgeInsets.all(
                            AppDimensions.paddingMd,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: state.isConfirmed,
                                  onChanged: (_) {
                                    context
                                        .read<AcceptOfferCubit>()
                                        .toggleConfirmation();
                                  },
                                  activeColor: AppColors.brandRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<AcceptOfferCubit>()
                                        .toggleConfirmation();
                                  },
                                  child: Text(
                                    l.acceptOfferConfirmationTextLong,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textPrimary,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state.errorCode == 'CONFIRMATION_REQUIRED') ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              l.acceptOfferConfirmationRequired,
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],

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
                      ],
                    ),
                  ),
                ),

                // Action buttons
                SafeArea(
                  minimum: const EdgeInsets.all(AppDimensions.paddingMd),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilledButton.icon(
                        onPressed: state.isSubmitting
                            ? null
                            : () => context.read<AcceptOfferCubit>().submit(),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.brandRed,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: state.isSubmitting
                            ? const SizedBox.shrink()
                            : const Icon(Icons.edit, size: 18),
                        label: state.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                l.acceptOfferSignAndAccept,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          l.reviewFullAgreement.toUpperCase(),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String? _signatureError(String? errorCode, AppLocalizations l) {
    if (errorCode == 'SIGNATURE_REQUIRED') {
      return l.acceptOfferSignatureRequired;
    }
    if (errorCode == 'SIGNATURE_INVALID_PREFIX') {
      return l.acceptOfferSignatureInvalidPrefix;
    }
    return null;
  }

  bool _isApiError(String? errorCode) {
    return errorCode == AcceptOfferState.terminalStateError ||
        errorCode == AcceptOfferState.forbiddenError ||
        errorCode == AcceptOfferState.paymentConfigMissingError ||
        errorCode == AcceptOfferState.genericError;
  }

  String _apiErrorMessage(String? errorCode, AppLocalizations l) {
    switch (errorCode) {
      case AcceptOfferState.terminalStateError:
        return l.acceptOfferTerminalState;
      case AcceptOfferState.forbiddenError:
        return l.acceptOfferForbidden;
      case AcceptOfferState.paymentConfigMissingError:
        return l.acceptOfferPaymentConfigMissing;
      default:
        return l.acceptOfferFailed;
    }
  }

  Future<void> _launchCheckoutUrl(BuildContext context, String url) async {
    final l = AppLocalizations.of(context);

    ToastUtils.showSuccess(context, l.acceptOfferSuccessOnline);

    final uri = Uri.tryParse(url);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        if (context.mounted) {
          ToastUtils.showError(context, l.acceptOfferCheckoutError);
        }
      }
    }

    if (context.mounted) {
      context.go(AppRouter.customerOffersLocation());
    }
  }
}
