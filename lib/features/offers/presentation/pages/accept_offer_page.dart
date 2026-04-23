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
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
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
        final errorMessage = _errorToastMessage(state.errorCode, l);
        if (errorMessage != null) {
          ToastUtils.showError(context, errorMessage);
          return;
        }

        if (state.status == LoadStatus.success) {
          if (state.checkoutUrl != null) {
            // Online payment: notify user then open checkout URL.
            _launchCheckoutUrl(context, state.checkoutUrl!);
          } else {
            // COD: show success then navigate back to offers.
            ToastUtils.showSuccess(context, l.acceptOfferSuccessCod);
            context.go(AppRouter.customerOffersLocation());
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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

                        if (offerDetails != null)
                          OfferSummaryCard(
                            offerNumber: offerDetails!.offerNumber,
                            offerId: offerDetails!.offerId,
                            companyName: offerDetails!.companyName,
                            totalAmount: offerDetails!.totalAmount,
                          ),
                        const SizedBox(height: 20),

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
                            errorText: _signatureFieldError(state.errorCode, l),
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
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 8),
                            child: Text(
                              l.acceptOfferConfirmationRequired,
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: l.acceptOfferSignAndAccept,
                          isLoading: state.isSubmitting,
                          onPressed: state.isSubmitting
                              ? null
                              : () => context.read<AcceptOfferCubit>().submit(),
                          icon: Icons.edit,
                        ),
                        const SizedBox(height: 16),
                        SecondaryButton(
                          label: l.reviewFullAgreement.toUpperCase(),
                          onPressed: () => context.pop(),
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

  String? _signatureFieldError(String? errorCode, AppLocalizations l) {
    if (errorCode == 'SIGNATURE_REQUIRED') {
      return l.acceptOfferSignatureRequired;
    }
    return null;
  }

  String? _errorToastMessage(String? errorCode, AppLocalizations l) {
    if (errorCode == 'SIGNATURE_INVALID_PREFIX') {
      return l.acceptOfferSignatureInvalidPrefix;
    }

    switch (errorCode) {
      case AcceptOfferState.terminalStateError:
        return l.acceptOfferTerminalState;
      case AcceptOfferState.forbiddenError:
        return l.acceptOfferForbidden;
      case AcceptOfferState.paymentConfigMissingError:
        return l.acceptOfferPaymentConfigMissing;
      case AcceptOfferState.genericError:
        return l.acceptOfferFailed;
      default:
        return null;
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
