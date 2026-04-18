import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/session/session_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../home/domain/use_cases/discovery_use_cases.dart';
import '../../../home/domain/use_cases/service_request_use_cases.dart';
import '../cubit/new_service_request_cubit.dart';
import '../cubit/new_service_request_state.dart';
import '../widgets/location_form_section.dart';
import '../widgets/schedule_step_content.dart';
import '../widgets/service_type_selector.dart';
import '../widgets/step_navigation_buttons.dart';
import '../widgets/step_progress_indicator.dart';

class NewServiceRequestPage extends StatelessWidget {
  final int companyId;

  const NewServiceRequestPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewServiceRequestCubit>(
      create: (context) => NewServiceRequestCubit(
        companyId: companyId,
        submitServiceRequestUseCase: context
            .read<SubmitServiceRequestUseCase>(),
        getCompanyDetailsUseCase: context.read<GetCompanyDetailsUseCase>(),
        sessionCubit: context.read<SessionCubit>(),
      ),
      child: const _NewServiceRequestView(),
    );
  }
}

class _NewServiceRequestView extends StatelessWidget {
  const _NewServiceRequestView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          localizations.newRequestPageTitle,
          style: AppTypography.heading3,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NewServiceRequestCubit, NewServiceRequestState>(
            listenWhen: (prev, curr) =>
                prev.isLeadReloginPromptVisible !=
                curr.isLeadReloginPromptVisible,
            listener: (context, state) {
              if (!state.isLeadReloginPromptVisible) return;
              _showLeadReloginModal(context);
            },
          ),
          BlocListener<NewServiceRequestCubit, NewServiceRequestState>(
            listenWhen: (prev, curr) =>
                prev.navigateToRequests != curr.navigateToRequests,
            listener: (context, state) {
              if (!state.navigateToRequests) return;
              final ensureRequestId = state.lastSubmission?.serviceRequestId;
              final refreshToken = DateTime.now().millisecondsSinceEpoch
                  .toString();
              final targetLocation = AppRouter.customerRequestsLocation(
                ensureRequestId: ensureRequestId,
                refreshToken: refreshToken,
              );

              debugPrint(
                '[NewServiceRequestPage] submit success navigate to requests '
                'ensureRequestId=$ensureRequestId '
                'refreshToken=$refreshToken '
                'target=$targetLocation',
              );

              ToastUtils.showSuccess(
                context,
                localizations.newRequestSuccessMessage,
              );
              context
                  .read<NewServiceRequestCubit>()
                  .consumeNavigateToRequests();
              context.pushReplacement(targetLocation);
            },
          ),
          BlocListener<NewServiceRequestCubit, NewServiceRequestState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status &&
                curr.status == NewServiceRequestStatus.failure &&
                curr.errorCode != null,
            listener: (context, state) {
              final msg = _errorMessage(localizations, state);
              ToastUtils.showError(context, msg);
            },
          ),
        ],
        child: BlocBuilder<NewServiceRequestCubit, NewServiceRequestState>(
          builder: (context, state) {
            final stepTitle = switch (state.currentStep) {
              0 => localizations.newRequestStepServiceType,
              1 => localizations.newRequestStepLocations,
              _ => localizations.newRequestStepSchedule,
            };

            void handleExit() {
              final companyId = state.companyId;
              if (Navigator.of(context).canPop()) {
                context.pop();
                return;
              }

              if (companyId > 0) {
                context.go(AppRouter.companyLocation(companyId));
                return;
              }

              context.go(AppRouter.home);
            }

            void handleBack() {
              context.read<NewServiceRequestCubit>().previousStep();
            }

            void handleNext() {
              final cubit = context.read<NewServiceRequestCubit>();
              if (state.currentStep < 2) {
                if (cubit.validateStep(state.currentStep)) {
                  cubit.nextStep();
                }
              } else {
                if (cubit.validateStep(2)) {
                  cubit.submit();
                }
              }
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.paddingMd,
                    AppDimensions.spacingMd,
                    AppDimensions.paddingMd,
                    AppDimensions.spacingSm,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(stepTitle, style: AppTypography.heading2),
                  ),
                ),
                StepProgressIndicator(currentStep: state.currentStep),
                const SizedBox(height: AppDimensions.spacingMd),
                if (state.currentStep == 0)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _Step1Content(state: state),
                          StepNavigationButtons(
                            showBack: false,
                            showExit: true,
                            isLastStep: false,
                            isSubmitting: state.isSubmitting,
                            onExit: handleExit,
                            onBack: handleBack,
                            onNext: handleNext,
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  Expanded(
                    child: IndexedStack(
                      index: state.currentStep,
                      children: [
                        _Step1Content(state: state),
                        _Step2Content(state: state),
                        _Step3Content(state: state),
                      ],
                    ),
                  ),
                  StepNavigationButtons(
                    showBack: true,
                    showExit: false,
                    isLastStep: state.currentStep == 2,
                    isSubmitting: state.isSubmitting,
                    onExit: handleExit,
                    onBack: handleBack,
                    onNext: handleNext,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  void _showLeadReloginModal(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.brandRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.brandRed.withValues(alpha: 0.18),
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.brandRed,
                    size: 28,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                Text(
                  localizations.requestFlowLeadReloginPromptTitle,
                  style: AppTypography.heading3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                Text(
                  localizations.requestFlowLeadReloginPromptMessage,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingXl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<NewServiceRequestCubit>()
                          .dismissLeadReloginPrompt();
                      Navigator.of(dialogContext).pop();
                      context.go(AppRouter.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                      foregroundColor: AppColors.surface,
                      elevation: 0,
                      minimumSize: const Size(
                        double.infinity,
                        AppDimensions.buttonHeight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusMd,
                        ),
                      ),
                    ),
                    child: Text(
                      localizations.restrictionContinue,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _errorMessage(AppLocalizations l, NewServiceRequestState state) {
    switch (state.errorCode) {
      case NewServiceRequestCubit.invalidCompanyIdError:
        return l.requestsDetailsNotFound;
      case NewServiceRequestCubit.submitFailedError:
        return l.networkErrorServer;
      case NewServiceRequestCubit.guestNotAllowedError:
        return l.restrictionLoginOrRegister;
      default:
        return l.networkErrorServer;
    }
  }
}

class _Step1Content extends StatelessWidget {
  final NewServiceRequestState state;

  const _Step1Content({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewServiceRequestCubit>();
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
      child: ServiceTypeSelector(
        servicesLoadStatus: state.servicesLoadStatus,
        availableServices: state.availableServices,
        selectedServices: state.selectedServices,
        errorText: state.serviceTypeError != null
            ? localizations.newRequestValidationServiceType
            : null,
        onToggle: cubit.toggleServiceType,
        onRemove: cubit.removeServiceType,
        onRetry: () {
          context.read<NewServiceRequestCubit>().retryLoadServices();
        },
      ),
    );
  }
}

class _Step2Content extends StatelessWidget {
  final NewServiceRequestState state;

  const _Step2Content({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewServiceRequestCubit>();
    final localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
      child: Column(
        children: [
          LocationFormSection(
            title: localizations.newRequestFromTitle,
            isPickup: true,
            street: state.fromStreet,
            city: state.fromCity,
            zipCode: state.fromZipCode,
            country: state.fromCountry,
            streetKey: 'fromStreet',
            cityKey: 'fromCity',
            zipCodeKey: 'fromZipCode',
            countryKey: 'fromCountry',
            fieldErrors: state.fieldErrors,
            touchedFields: state.touchedFields,
            onFieldChanged: cubit.fieldChanged,
            onFieldBlurred: cubit.fieldBlurred,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          LocationFormSection(
            title: localizations.newRequestToTitle,
            isPickup: false,
            street: state.toStreet,
            city: state.toCity,
            zipCode: state.toZipCode,
            country: state.toCountry,
            streetKey: 'toStreet',
            cityKey: 'toCity',
            zipCodeKey: 'toZipCode',
            countryKey: 'toCountry',
            fieldErrors: state.fieldErrors,
            touchedFields: state.touchedFields,
            onFieldChanged: cubit.fieldChanged,
            onFieldBlurred: cubit.fieldBlurred,
          ),
        ],
      ),
    );
  }
}

class _Step3Content extends StatelessWidget {
  final NewServiceRequestState state;

  const _Step3Content({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewServiceRequestCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
      child: ScheduleStepContent(
        preferredDate: state.preferredDate,
        preferredTimeSlot: state.preferredTimeSlot,
        notes: state.notes,
        preferredDateError: state.preferredDateError,
        preferredTimeSlotError: state.preferredTimeSlotError,
        onPreferredDateChanged: cubit.preferredDateChanged,
        onPreferredTimeSlotChanged: cubit.preferredTimeSlotChanged,
        onNotesChanged: cubit.notesChanged,
      ),
    );
  }
}
