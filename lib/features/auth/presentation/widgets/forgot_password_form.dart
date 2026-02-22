import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/forgot_password_cubit.dart';
import '../cubit/forgot_password_state.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _EmailField(localizations: localizations),
        const SizedBox(height: AppDimensions.spacingXxl),
        _SubmitButton(localizations: localizations),
        const SizedBox(height: AppDimensions.spacingXxl),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (prev, curr) =>
          prev.email != curr.email || prev.emailError != curr.emailError,
      builder: (context, state) {
        return TextField(
          onChanged: context.read<ForgotPasswordCubit>().emailChanged,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofocus: true,
          autofillHints: const [AutofillHints.email],
          onSubmitted: (_) {
            if (state.isValid && !state.isSubmitting) {
              context.read<ForgotPasswordCubit>().submit();
            }
          },
          decoration: InputDecoration(
            labelText: localizations.forgotPasswordEmailLabel,
            hintText: localizations.forgotPasswordEmailPlaceholder,
            errorText: state.emailError != null
                ? _mapError(state.emailError, localizations)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
            ),
          ),
        );
      },
    );
  }

  String _mapError(String? error, AppLocalizations localizations) {
    switch (error) {
      case 'email_empty':
        return localizations.forgotPasswordEmailRequired;
      case 'email_invalid':
        return localizations.forgotPasswordEmailInvalid;
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
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (prev, curr) =>
          prev.isValid != curr.isValid ||
          prev.isSubmitting != curr.isSubmitting,
      builder: (context, state) {
        final isEnabled = state.isValid && !state.isSubmitting;

        return SizedBox(
          height: AppDimensions.buttonHeight,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () => context.read<ForgotPasswordCubit>().submit()
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
            child: Text(
              localizations.forgotPasswordSend,
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
