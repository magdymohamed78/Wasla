import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/session/session_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../domain/use_cases/customer_portal_use_cases.dart';
import '../cubit/lead_profile_edit_cubit.dart';
import '../cubit/lead_profile_edit_state.dart';
import '../widgets/profile_components.dart';

class LeadProfileEditPage extends StatelessWidget {
  const LeadProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LeadProfileEditCubit>(
      create: (context) => LeadProfileEditCubit(
        getLeadProfileUseCase: context.read<GetLeadProfileUseCase>(),
        updateLeadProfileUseCase: context.read<UpdateLeadProfileUseCase>(),
        sessionCubit: context.read<SessionCubit>(),
      )..load(),
      child: const _LeadProfileEditView(),
    );
  }
}

class _LeadProfileEditView extends StatelessWidget {
  const _LeadProfileEditView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(localizations.profileEditPageTitle),
      ),
      body: SafeArea(
        child: BlocConsumer<LeadProfileEditCubit, LeadProfileEditState>(
          listener: (context, state) {
            if (state.status == LeadProfileEditStatus.success) {
              ToastUtils.showSuccess(context, localizations.profileSaveSuccess);
              Navigator.of(context).pop(true);
            }

            if (state.status == LeadProfileEditStatus.failure &&
                state.errorMessage != null) {
              ToastUtils.showError(context, localizations.profileSaveError);
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final cubit = context.read<LeadProfileEditCubit>();
            final memberSince = _formatDate(context, state.profile?.createdAt);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileSectionCard(
                    title: localizations.profilePersonalDetailsTitle,
                    child: Column(
                      children: [
                        _EditableField(
                          label: localizations.signUpFirstName,
                          value: state.firstName,
                          onChanged: cubit.firstNameChanged,
                          errorText: _mapNameError(
                            state.firstNameError,
                            localizations,
                            isFirstName: true,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        _EditableField(
                          label: localizations.signUpLastName,
                          value: state.lastName,
                          onChanged: cubit.lastNameChanged,
                          errorText: _mapNameError(
                            state.lastNameError,
                            localizations,
                            isFirstName: false,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        _EditableField(
                          label: localizations.profileEmailLabel,
                          value: state.email,
                          enabled: false,
                          onChanged: (_) {},
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        _EditableField(
                          label: localizations.signUpPhoneNumber,
                          value: state.phoneNumber,
                          onChanged: cubit.phoneChanged,
                          keyboardType: TextInputType.phone,
                          errorText: _mapPhoneError(
                            state.phoneError,
                            localizations,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        _EditableField(
                          label: localizations.profileMemberSince,
                          value: memberSince,
                          enabled: false,
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  ProfileSectionCard(
                    title: localizations.profileAddressInformationTitle,
                    child: Column(
                      children: [
                        _EditableField(
                          label: localizations.profileStreetAddress,
                          value: state.address,
                          onChanged: cubit.addressChanged,
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        Row(
                          children: [
                            Expanded(
                              child: _EditableField(
                                label: localizations.profileCityLabel,
                                value: state.city,
                                onChanged: cubit.cityChanged,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacingSm),
                            Expanded(
                              child: _EditableField(
                                label: localizations.profileZipCodeLabel,
                                value: state.zipCode,
                                onChanged: cubit.zipCodeChanged,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingSm),
                        _EditableField(
                          label: localizations.profileCountryLabel,
                          value: state.country,
                          onChanged: cubit.countryChanged,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  PrimaryButton(
                    label: localizations.profileSaveChanges,
                    onPressed: state.isSaving ? null : cubit.save,
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  SecondaryButton(
                    label: localizations.profileCancel,
                    onPressed: state.isSaving
                        ? null
                        : () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) {
      return '-';
    }

    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(date.toLocal());
  }

  String? _mapNameError(
    String? error,
    AppLocalizations localizations, {
    required bool isFirstName,
  }) {
    if (error == null) {
      return null;
    }

    switch (error) {
      case 'name_empty':
        return isFirstName
            ? localizations.signUpFirstNameRequired
            : localizations.signUpLastNameRequired;
      case 'name_too_long':
        return localizations.signUpNameTooLong;
      case 'name_letters_only':
        return localizations.signUpNameLettersOnly;
      default:
        return null;
    }
  }

  String? _mapPhoneError(String? error, AppLocalizations localizations) {
    if (error == null) {
      return null;
    }

    switch (error) {
      case 'phone_too_long':
        return localizations.signUpPhoneTooLong;
      case 'phone_invalid':
        return localizations.signUpPhoneInvalid;
      default:
        return null;
    }
  }
}

class _EditableField extends StatelessWidget {
  final String label;
  final String value;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final TextInputType? keyboardType;

  const _EditableField({
    required this.label,
    required this.value,
    this.enabled = true,
    required this.onChanged,
    this.errorText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      enabled: enabled,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        labelStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: enabled ? AppColors.background : AppColors.buttonSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          borderSide: const BorderSide(color: AppColors.brandRed, width: 1.5),
        ),
      ),
    );
  }
}
