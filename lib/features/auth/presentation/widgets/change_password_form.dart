import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/change_password_cubit.dart';
import '../cubit/change_password_state.dart';
import '../cubit/otp_verification_cubit.dart';
import '../cubit/otp_verification_state.dart';
import 'otp_input_field.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OtpField(localizations: localizations),
        const SizedBox(height: AppDimensions.spacingMd),
        const _TimerAndResend(),
        const SizedBox(height: AppDimensions.spacingXl),
        _NewPasswordField(localizations: localizations),
        const SizedBox(height: AppDimensions.spacingMd),
        _ConfirmPasswordField(localizations: localizations),
        const SizedBox(height: AppDimensions.spacingSm),
        const _ErrorMessage(),
        const SizedBox(height: AppDimensions.spacingXl),
        _SubmitButton(localizations: localizations),
        const SizedBox(height: AppDimensions.spacingXl),
      ],
    );
  }
}

class _OtpField extends StatelessWidget {
  const _OtpField({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status || prev.errorMessage != curr.errorMessage,
      builder: (context, state) {
        final hasError = state.status == OtpVerificationStatus.failure;

        return OtpInputField(
          hasError: hasError,
          onChanged: (index, value) {
            if (value.isEmpty) {
              context.read<OtpVerificationCubit>().digitRemoved(index);
            } else {
              context.read<OtpVerificationCubit>().digitEntered(index, value);
            }
          },
          onCompleted: (_) {},
        );
      },
    );
  }
}

class _TimerAndResend extends StatelessWidget {
  const _TimerAndResend();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
      buildWhen: (prev, curr) =>
          prev.timerRemainingSeconds != curr.timerRemainingSeconds ||
          prev.canResend != curr.canResend ||
          prev.isResending != curr.isResending,
      builder: (context, state) {
        if (state.canResend) {
          return Center(
            child: TextButton(
              onPressed: () => context.read<OtpVerificationCubit>().resendOtp(),
              child: state.isResending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.brandRed,
                      ),
                    )
                  : Text(
                      localizations.otpVerificationResend,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.brandRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        }

        return Center(
          child: Text(
            localizations.otpVerificationTimerText(state.timerRemainingSeconds),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        );
      },
    );
  }
}

class _NewPasswordField extends StatelessWidget {
  const _NewPasswordField({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (prev, curr) =>
          prev.newPassword != curr.newPassword ||
          prev.newPasswordError != curr.newPasswordError ||
          prev.obscureNewPassword != curr.obscureNewPassword ||
          prev.hasSubmitted != curr.hasSubmitted,
      builder: (context, state) {
        return TextField(
          onChanged: context.read<ChangePasswordCubit>().newPasswordChanged,
          obscureText: state.obscureNewPassword,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          decoration: InputDecoration(
            labelText: localizations.changePasswordNewPasswordLabel,
            errorText: state.hasSubmitted && state.newPasswordError != null
                ? _mapError(state.newPasswordError!, localizations)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                state.obscureNewPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: context
                  .read<ChangePasswordCubit>()
                  .toggleNewPasswordVisibility,
            ),
          ),
        );
      },
    );
  }

  String _mapError(String error, AppLocalizations localizations) {
    switch (error) {
      case 'password_empty':
        return localizations.changePasswordNewPasswordLabel;
      case 'password_too_short':
        return localizations.changePasswordMinLength;
      default:
        return '';
    }
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (prev, curr) =>
          prev.confirmPassword != curr.confirmPassword ||
          prev.confirmPasswordError != curr.confirmPasswordError ||
          prev.obscureConfirmPassword != curr.obscureConfirmPassword ||
          prev.hasSubmitted != curr.hasSubmitted,
      builder: (context, state) {
        return TextField(
          onChanged: context.read<ChangePasswordCubit>().confirmPasswordChanged,
          obscureText: state.obscureConfirmPassword,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          onSubmitted: (_) {
            if (state.isValid) {
              context.read<ChangePasswordCubit>().submit();
            }
          },
          decoration: InputDecoration(
            labelText: localizations.changePasswordConfirmPasswordLabel,
            errorText: state.hasSubmitted && state.confirmPasswordError != null
                ? _mapError(state.confirmPasswordError!, localizations)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                state.obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: context
                  .read<ChangePasswordCubit>()
                  .toggleConfirmPasswordVisibility,
            ),
          ),
        );
      },
    );
  }

  String _mapError(String error, AppLocalizations localizations) {
    switch (error) {
      case 'confirm_password_empty':
        return localizations.changePasswordConfirmPasswordLabel;
      case 'passwords_do_not_match':
        return localizations.changePasswordMismatch;
      default:
        return '';
    }
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (prev, curr) =>
          prev.isValid != curr.isValid || prev.status != curr.status,
      builder: (context, state) {
        final isLoading = state.status == ChangePasswordStatus.loading;
        final isEnabled = state.isValid && !isLoading;

        return SizedBox(
          height: AppDimensions.buttonHeight,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () => context.read<ChangePasswordCubit>().submit()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              disabledBackgroundColor: AppColors.buttonSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusLg,
                ),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    localizations.changePasswordConfirm,
                    style: isEnabled
                        ? AppTypography.buttonLabel
                        : AppTypography.buttonLabel.copyWith(
                            color: AppColors.textSecondary,
                          ),
                  ),
          ),
        );
      },
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (prev, curr) =>
          prev.errorMessage != curr.errorMessage ||
          prev.serverMessage != curr.serverMessage ||
          prev.status != curr.status,
      builder: (context, state) {
        if (state.status != ChangePasswordStatus.failure) {
          return const SizedBox.shrink();
        }

        // Prefer the raw server message; fall back to a localized key.
        final rawServer = state.serverMessage;
        if (rawServer == null && state.errorMessage == null) {
          return const SizedBox.shrink();
        }

        final localizations = AppLocalizations.of(context);
        final message = rawServer ?? _mapErrorMessage(state.errorMessage!, localizations);

        return Padding(
          padding: const EdgeInsets.only(top: AppDimensions.spacingSm),
          child: Text(
            message,
            style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  String _mapErrorMessage(String errorKey, AppLocalizations localizations) {
    switch (errorKey) {
      case 'rateLimit':
        return localizations.errorRateLimit;
      case 'network':
        return localizations.errorNetwork;
      case 'otpInvalid':
        return localizations.errorExpiredOtp;
      case 'otpExpired':
        return localizations.errorExpiredOtp;
      case 'passwordPolicy':
        return localizations.errorPasswordPolicy;
      default:
        return localizations.errorServer;
    }
  }
}
