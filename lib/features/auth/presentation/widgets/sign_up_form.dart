import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaapp/features/auth/presentation/cubit/register_cubit.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/register_state.dart';

import 'password_feedback_section.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _firstNameFocus.addListener(() {
      if (!_firstNameFocus.hasFocus) {
        context.read<RegisterCubit>().firstNameBlurred();
      }
    });
    _lastNameFocus.addListener(() {
      if (!_lastNameFocus.hasFocus) {
        context.read<RegisterCubit>().lastNameBlurred();
      }
    });
    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) context.read<RegisterCubit>().phoneBlurred();
    });
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) context.read<RegisterCubit>().emailBlurred();
    });
    _passwordFocus.addListener(() {
      setState(() {});
      if (!_passwordFocus.hasFocus) {
        context.read<RegisterCubit>().passwordBlurred();
      }
    });
    _confirmPasswordFocus.addListener(() {
      if (!_confirmPasswordFocus.hasFocus) {
        context.read<RegisterCubit>().confirmPasswordBlurred();
      }
    });
  }

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();

        return AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                focusNode: _firstNameFocus,
                onChanged: cubit.firstNameChanged,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: localizations.signUpFirstName,
                  hintText: localizations.signUpFirstName,
                  errorText: _mapNameError(state.firstNameError, localizations),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.brandRed,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                ),
                style: AppTypography.bodyLarge,
              ),

              const SizedBox(height: AppDimensions.spacingMd),

              TextFormField(
                focusNode: _lastNameFocus,
                onChanged: cubit.lastNameChanged,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: localizations.signUpLastName,
                  hintText: localizations.signUpLastName,
                  errorText: _mapNameError(state.lastNameError, localizations),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.brandRed,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                ),
                style: AppTypography.bodyLarge,
              ),

              const SizedBox(height: AppDimensions.spacingMd),

              TextFormField(
                focusNode: _phoneFocus,
                onChanged: cubit.phoneChanged,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: localizations.signUpPhoneNumber,
                  hintText: localizations.signUpPhoneNumber,
                  errorText: _mapPhoneError(state.phoneError, localizations),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.brandRed,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                ),
                style: AppTypography.bodyLarge,
              ),

              const SizedBox(height: AppDimensions.spacingMd),

              TextFormField(
                focusNode: _emailFocus,
                onChanged: cubit.emailChanged,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: localizations.signUpEmail,
                  hintText: localizations.signUpEmailHint,
                  errorText: _mapEmailError(
                    state.emailError,
                    localizations,
                    state,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.brandRed,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                ),
                style: AppTypography.bodyLarge,
              ),

              const SizedBox(height: AppDimensions.spacingMd),

              TextFormField(
                focusNode: _passwordFocus,
                onChanged: cubit.passwordChanged,
                obscureText: state.obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                textDirection: TextDirection.ltr,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: localizations.signUpPassword,
                  hintText: localizations.signUpPassword,
                  // errorText: _mapPasswordError(
                  //   state.passwordError,
                  //   localizations,
                  // ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: cubit.togglePasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.brandRed,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                ),
                style: AppTypography.bodyLarge,
              ),

              const SizedBox(height: AppDimensions.spacingSm),

              PasswordFeedbackSection(
                password: state.password,
                hasFocus: _passwordFocus.hasFocus,
              ),

              const SizedBox(height: AppDimensions.spacingMd),

              TextFormField(
                focusNode: _confirmPasswordFocus,
                onChanged: cubit.confirmPasswordChanged,
                obscureText: state.obscureConfirmPassword,
                keyboardType: TextInputType.visiblePassword,
                textDirection: TextDirection.ltr,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onSubmit(state, cubit),
                decoration: InputDecoration(
                  labelText: localizations.signUpConfirmPassword,
                  hintText: localizations.signUpConfirmPassword,
                  errorText: _mapConfirmPasswordError(
                    state.confirmPasswordError,
                    localizations,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: cubit.toggleConfirmPasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.brandRed,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMd,
                    ),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                ),
                style: AppTypography.bodyLarge,
              ),

              const SizedBox(height: AppDimensions.spacingXxl),

              state.status == RegisterStatus.loading
                  ? const SizedBox(
                      height: AppDimensions.buttonHeight,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.brandRed,
                        ),
                      ),
                    )
                  : PrimaryButton(
                      label: localizations.signUpButton,
                      icon: Icons.arrow_forward_rounded,
                      onPressed: _isButtonEnabled(state, localizations)
                          ? () => _onSubmit(state, cubit)
                          : null,
                    ),
            ],
          ),
        );
      },
    );
  }

  bool _isButtonEnabled(RegisterState state, AppLocalizations localizations) {
    if (state.status == RegisterStatus.loading) return false;

    if (state.firstName.trim().isEmpty) return false;
    if (state.lastName.trim().isEmpty) return false;
    if (state.email.trim().isEmpty) return false;
    if (state.password.trim().isEmpty) return false;
    if (state.confirmPassword.trim().isEmpty) return false;

    if (state.firstNameError != null) return false;
    if (state.lastNameError != null) return false;
    if (state.phoneError != null) return false;
    if (state.emailError != null) return false;
    if (state.passwordError != null) return false;
    if (state.confirmPasswordError != null) return false;

    if (state.password != state.confirmPassword) return false;

    return true;
  }

  String? _mapNameError(String? errorKey, AppLocalizations localizations) {
    if (errorKey == null) return null;
    switch (errorKey) {
      case 'name_empty':
        return localizations.signUpFirstNameRequired;
      case 'name_too_long':
        return localizations.signUpNameTooLong;
      case 'name_letters_only':
        return localizations.signUpNameLettersOnly;
      default:
        return null;
    }
  }

  String? _mapPhoneError(String? errorKey, AppLocalizations localizations) {
    if (errorKey == null) return null;
    switch (errorKey) {
      case 'phone_too_long':
        return localizations.signUpPhoneTooLong;
      case 'phone_invalid':
        return localizations.signUpPhoneInvalid;
      default:
        return null;
    }
  }

  String? _mapEmailError(
    String? errorKey,
    AppLocalizations localizations,
    RegisterState state,
  ) {
    if (state.errorCode == RegisterErrorCode.emailAlreadyRegistered) {
      return localizations.signUpErrorEmailInUse;
    }
    if (errorKey == null) return null;
    switch (errorKey) {
      case 'email_empty':
        return localizations.signUpEmailRequired;
      case 'email_invalid':
        return localizations.signUpEmailInvalid;
      default:
        return null;
    }
  }

  // String? _mapPasswordError(String? errorKey, AppLocalizations localizations) {
  //   if (errorKey == null) return null;
  //   switch (errorKey) {
  //     case 'password_empty':
  //       return localizations.signUpPasswordRequired;
  //     case 'password_too_short':
  //       return localizations.signUpPasswordTooShort;
  //     case 'password_missing_uppercase':
  //       return localizations.signUpPasswordMissingUppercase;
  //     case 'password_missing_number':
  //       return localizations.signUpPasswordMissingNumber;
  //     case 'password_missing_special':
  //       return localizations.signUpPasswordMissingSpecial;
  //     default:
  //       return null;
  //   }
  // }

  String? _mapConfirmPasswordError(
    String? errorKey,
    AppLocalizations localizations,
  ) {
    if (errorKey == null) return null;
    switch (errorKey) {
      case 'confirm_password_empty':
        return localizations.signUpConfirmPasswordRequired;
      case 'confirm_password_mismatch':
        return localizations.signUpConfirmPasswordMismatch;
      default:
        return null;
    }
  }

  void _onSubmit(RegisterState state, RegisterCubit cubit) {
    if (state.status != RegisterStatus.loading) {
      cubit.register();
    }
  }
}
