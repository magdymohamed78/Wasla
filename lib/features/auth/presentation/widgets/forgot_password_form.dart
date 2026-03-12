import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
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
        const SizedBox(height: AppDimensions.spacingMd),
        _SignUpLink(localizations: localizations),
        const SizedBox(height: AppDimensions.spacingLg),
      ],
    );
  }
}

class _EmailField extends StatefulWidget {
  const _EmailField({required this.localizations});

  final AppLocalizations localizations;

  @override
  State<_EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<_EmailField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) context.read<ForgotPasswordCubit>().emailBlurred();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (prev, curr) =>
          prev.email != curr.email ||
          prev.emailError != curr.emailError ||
          prev.emailTouched != curr.emailTouched,
      builder: (context, state) {
        return TextField(
          focusNode: _focusNode,
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
            labelText: widget.localizations.forgotPasswordEmailLabel,
            hintText: widget.localizations.forgotPasswordEmailPlaceholder,
            errorText: state.emailTouched && state.emailError != null
                ? _mapError(state.emailError, widget.localizations)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
            ),
          ),
        );
      },
    );
  }

  String? _mapError(String? error, AppLocalizations localizations) {
    switch (error) {
      case 'email_empty':
        return localizations.forgotPasswordEmailRequired;
      case 'email_invalid':
        return localizations.forgotPasswordEmailInvalid;
      default:
        return null;
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
          prev.isSubmitting != curr.isSubmitting ||
          prev.status != curr.status ||
          prev.rateLimitSecondsRemaining != curr.rateLimitSecondsRemaining,
      builder: (context, state) {
        final isLoading = state.status == ForgotPasswordStatus.loading;
        final isEnabled = state.isValid && !isLoading && !state.isRateLimited;

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
                    state.isRateLimited
                        ? localizations.forgotPasswordRateLimitWait(
                            state.rateLimitSecondsRemaining)
                        : localizations.forgotPasswordSend,
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

class _SignUpLink extends StatelessWidget {
  const _SignUpLink({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          localizations.forgotPasswordSignUp.split(
            localizations.forgotPasswordSignUpAction,
          )[0],
          style: AppTypography.bodyMedium,
        ),
        GestureDetector(
          onTap: () => context.push(AppRouter.register),
          child: Text(
            localizations.forgotPasswordSignUpAction,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.brandRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
