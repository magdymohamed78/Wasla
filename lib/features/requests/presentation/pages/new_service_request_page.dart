import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/session/session_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../home/domain/use_cases/service_request_use_cases.dart';
import '../cubit/new_service_request_cubit.dart';
import '../cubit/new_service_request_state.dart';
import '../widgets/new_service_request_form.dart';
import '../../../home/presentation/widgets/restricted_request_prompt_card.dart';

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

    return MultiBlocListener(
      listeners: [
        BlocListener<NewServiceRequestCubit, NewServiceRequestState>(
          listenWhen: (previous, current) =>
              previous.isLeadReloginPromptVisible !=
              current.isLeadReloginPromptVisible,
          listener: (context, state) {
            if (!state.isLeadReloginPromptVisible) {
              return;
            }

            _showLeadReloginModal(context, localizations);
          },
        ),
        BlocListener<NewServiceRequestCubit, NewServiceRequestState>(
          listenWhen: (previous, current) =>
              previous.navigateToRequests != current.navigateToRequests,
          listener: (context, state) {
            if (!state.navigateToRequests) {
              return;
            }

            context.read<NewServiceRequestCubit>().consumeNavigateToRequests();
            context.go(AppRouter.customerRequests);
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: const Text('New Service Request'),
        ),
        body: SafeArea(
          child: BlocBuilder<NewServiceRequestCubit, NewServiceRequestState>(
            builder: (context, state) {
              final cubit = context.read<NewServiceRequestCubit>();
              final preferredDateLabel = state.preferredDate == null
                  ? 'No date selected'
                  : state.preferredDate!.toLocal().toString().split(' ').first;

              return NewServiceRequestForm(
                companyId: state.companyId,
                serviceType: state.serviceType,
                fromStreet: state.fromStreet,
                fromCity: state.fromCity,
                fromZipCode: state.fromZipCode,
                fromCountry: state.fromCountry,
                toStreet: state.toStreet,
                toCity: state.toCity,
                toZipCode: state.toZipCode,
                toCountry: state.toCountry,
                preferredDate: state.preferredDate,
                preferredTimeSlot: state.preferredTimeSlot,
                notes: state.notes,
                preferredDateLabel: preferredDateLabel,
                pickDateLabel: 'Pick date',
                clearDateLabel: 'Clear',
                submitLabel: localizations.companyDetailsRequestService,
                errorMessage: _errorMessage(localizations, state),
                isSubmitting:
                    state.status == NewServiceRequestStatus.submitting,
                onServiceTypeChanged: cubit.serviceTypeChanged,
                onFromStreetChanged: cubit.fromStreetChanged,
                onFromCityChanged: cubit.fromCityChanged,
                onFromZipCodeChanged: cubit.fromZipCodeChanged,
                onFromCountryChanged: cubit.fromCountryChanged,
                onToStreetChanged: cubit.toStreetChanged,
                onToCityChanged: cubit.toCityChanged,
                onToZipCodeChanged: cubit.toZipCodeChanged,
                onToCountryChanged: cubit.toCountryChanged,
                onPreferredTimeSlotChanged: cubit.preferredTimeSlotChanged,
                onNotesChanged: cubit.notesChanged,
                onPickPreferredDate: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: state.preferredDate ?? now,
                    firstDate: now,
                    lastDate: DateTime(now.year + 2),
                  );
                  if (picked == null) {
                    return;
                  }
                  cubit.preferredDateChanged(picked);
                },
                onClearPreferredDate: () => cubit.preferredDateChanged(null),
                onSubmit: cubit.submit,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showLeadReloginModal(
    BuildContext context,
    AppLocalizations localizations,
  ) async {
    final cubit = context.read<NewServiceRequestCubit>();

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.22),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (dialogContext, _, _) {
        return SafeArea(
          child: Material(
            type: MaterialType.transparency,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLg,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: RestrictedRequestPromptCard(
                      message:
                          localizations.requestFlowLeadReloginPromptMessage,
                      continueLabel: localizations.restrictionContinue,
                      cancelLabel: localizations.restrictionCancel,
                      onContinue: () {
                        Navigator.of(dialogContext).pop();
                        context.go(AppRouter.login);
                      },
                      onCancel: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );

    if (context.mounted) {
      cubit.dismissLeadReloginPrompt();
    }
  }

  String? _errorMessage(
    AppLocalizations localizations,
    NewServiceRequestState state,
  ) {
    if (state.errorCode == null) {
      return null;
    }

    if (state.errorCode == NewServiceRequestCubit.invalidCompanyIdError) {
      return localizations.requestFlowMissingCompany;
    }

    if (state.errorCode == NewServiceRequestCubit.serviceTypeRequiredError) {
      return 'Please enter a service type.';
    }

    if (state.errorCode == NewServiceRequestCubit.guestNotAllowedError) {
      return localizations.restrictionLoginOrRegister;
    }

    return localizations.networkErrorServer;
  }
}
