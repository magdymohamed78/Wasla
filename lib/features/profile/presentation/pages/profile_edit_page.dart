import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../cubit/profile_edit_cubit.dart';
import '../cubit/profile_edit_state.dart';
import '../helpers/profile_helpers.dart';
import '../widgets/profile_components.dart';

class ProfileEditPage extends StatelessWidget {
  final ProfileEditCubit cubit;

  const ProfileEditPage({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileEditCubit>.value(
      value: cubit,
      child: const _ProfileEditView(),
    );
  }
}

class _ProfileEditView extends StatelessWidget {
  const _ProfileEditView();

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
        child: BlocConsumer<ProfileEditCubit, ProfileEditState>(
          listener: (context, state) {
            if (state.status == ProfileEditStatus.success) {
              ToastUtils.showSuccess(context, localizations.profileSaveSuccess);
              Navigator.of(context).pop(true);
            }

            if (state.status == ProfileEditStatus.failure &&
                state.errorMessage != null) {
              ToastUtils.showError(context, localizations.profileSaveError);
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const _ProfileEditSkeleton();
            }

            final cubit = context.read<ProfileEditCubit>();
            final memberSince = formatDate(context, state.createdAt);

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileSectionCard(
                        title: localizations.profilePersonalDetailsTitle,
                        sectionIcon: Icons.person_outline,
                        child: Column(
                          children: [
                            ProfileEditableField(
                              label: localizations.signUpFirstName,
                              value: state.firstName,
                              prefixIcon: Icons.person,
                              onChanged: cubit.firstNameChanged,
                              errorText: _mapNameError(
                                state.firstNameError,
                                localizations,
                                isFirstName: true,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingSm),
                            const Divider(color: AppColors.divider),
                            const SizedBox(height: AppDimensions.spacingXs),
                            ProfileEditableField(
                              label: localizations.signUpLastName,
                              value: state.lastName,
                              prefixIcon: Icons.person_outline,
                              onChanged: cubit.lastNameChanged,
                              errorText: _mapNameError(
                                state.lastNameError,
                                localizations,
                                isFirstName: false,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingSm),
                            const Divider(color: AppColors.divider),
                            const SizedBox(height: AppDimensions.spacingXs),
                            ProfileEditableField(
                              label: localizations.profileEmailLabel,
                              value: state.email,
                              enabled: false,
                              prefixIcon: Icons.email_outlined,
                              onChanged: (_) {},
                            ),
                            const SizedBox(height: AppDimensions.spacingSm),
                            const Divider(color: AppColors.divider),
                            const SizedBox(height: AppDimensions.spacingXs),
                            ProfileEditableField(
                              label: localizations.signUpPhoneNumber,
                              value: state.phoneNumber,
                              prefixIcon: Icons.phone_outlined,
                              onChanged: cubit.phoneChanged,
                              keyboardType: TextInputType.phone,
                              errorText: _mapPhoneError(
                                state.phoneError,
                                localizations,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingSm),
                            const Divider(color: AppColors.divider),
                            const SizedBox(height: AppDimensions.spacingXs),
                            ProfileEditableField(
                              label: localizations.profileMemberSince,
                              value: memberSince,
                              enabled: false,
                              prefixIcon: Icons.calendar_today_outlined,
                              onChanged: (_) {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      ProfileSectionCard(
                        title: localizations.profileAddressInformationTitle,
                        sectionIcon: Icons.location_on_outlined,
                        child: Column(
                          children: [
                            ProfileEditableField(
                              label: localizations.profileStreetAddress,
                              value: state.address,
                              prefixIcon: Icons.location_on_outlined,
                              onChanged: cubit.addressChanged,
                            ),
                            const SizedBox(height: AppDimensions.spacingSm),
                            const Divider(color: AppColors.divider),
                            const SizedBox(height: AppDimensions.spacingXs),
                            Row(
                              children: [
                                Expanded(
                                  child: ProfileEditableField(
                                    label: localizations.profileCityLabel,
                                    value: state.city,
                                    prefixIcon: Icons.map_outlined,
                                    onChanged: cubit.cityChanged,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.spacingSm),
                                Expanded(
                                  child: ProfileEditableField(
                                    label: localizations.profileZipCodeLabel,
                                    value: state.zipCode,
                                    prefixIcon:
                                        Icons.markunread_mailbox_outlined,
                                    onChanged: cubit.zipCodeChanged,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.spacingSm),
                            const Divider(color: AppColors.divider),
                            const SizedBox(height: AppDimensions.spacingXs),
                            ProfileEditableField(
                              label: localizations.profileCountryLabel,
                              value: state.country,
                              prefixIcon: Icons.public_outlined,
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
                ),
                if (state.isSaving)
                  Container(
                    color: AppColors.surface.withValues(alpha: 0.7),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
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

class _ProfileEditSkeleton extends StatelessWidget {
  const _ProfileEditSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.buttonSecondary,
      highlightColor: AppColors.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SkeletonSectionCard(
              child: Column(
                children: [
                  const _SkeletonField(),
                  const SizedBox(height: AppDimensions.spacingSm),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.spacingXs),
                  const _SkeletonField(),
                  const SizedBox(height: AppDimensions.spacingSm),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.spacingXs),
                  const _SkeletonField(width: 200),
                  const SizedBox(height: AppDimensions.spacingSm),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.spacingXs),
                  const _SkeletonField(width: 160),
                  const SizedBox(height: AppDimensions.spacingSm),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.spacingXs),
                  const _SkeletonField(width: 140),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            _SkeletonSectionCard(
              child: Column(
                children: [
                  const _SkeletonField(),
                  const SizedBox(height: AppDimensions.spacingSm),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.spacingXs),
                  Row(
                    children: const [
                      Expanded(child: _SkeletonField()),
                      SizedBox(width: AppDimensions.spacingSm),
                      Expanded(child: _SkeletonField(width: 100)),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.spacingXs),
                  const _SkeletonField(width: 180),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Container(
              height: AppDimensions.buttonHeight,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMd,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Container(
              height: AppDimensions.buttonHeight,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMd,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonSectionCard extends StatelessWidget {
  final Widget child;

  const _SkeletonSectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          child,
        ],
      ),
    );
  }
}

class _SkeletonField extends StatelessWidget {
  final double? width;

  const _SkeletonField({this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      ),
    );
  }
}
