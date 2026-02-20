import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

/// Login form widget containing all input fields and action buttons.
///
/// Reads state from [LoginCubit] and dispatches user interactions.
/// Pure presentation — no business logic or navigation.
class LoginForm extends StatelessWidget {
  final VoidCallback? onForgotPasswordTap;

  const LoginForm({super.key, this.onForgotPasswordTap});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();

        return AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email field
              TextFormField(
                onChanged: cubit.emailChanged,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: localizations.loginEmail,
                  hintText: localizations.loginEmail,
                  errorText: _mapEmailError(state.emailError, localizations),
                 
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

              // Password field
              TextFormField(
                onChanged: cubit.passwordChanged,
                obscureText: state.obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                textDirection: TextDirection.ltr,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onSubmit(state, cubit),
                decoration: InputDecoration(
                  labelText: localizations.loginPassword,
                  hintText: localizations.loginPassword,
                  errorText: _mapPasswordError(
                    state.passwordError,
                    localizations,
                  ),
                 
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

              // Remember me + Forgot password row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remember me checkbox
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: AppDimensions.iconSizeMd,
                        width: AppDimensions.iconSizeMd,
                        child: Checkbox(
                          value: state.rememberMe,
                          onChanged: (_) => cubit.toggleRememberMe(),
                          activeColor: AppColors.brandRed,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingXs),
                      Text(
                        localizations.loginRememberMe,
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ),

                  // Forgot password
                  TextButton(
                    onPressed: onForgotPasswordTap,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      localizations.loginForgotPassword,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.brandRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacingXxl),

              // Sign In button
              state.status == LoginStatus.loading
                  ? const SizedBox(
                      height: AppDimensions.buttonHeight,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.brandRed,
                        ),
                      ),
                    )
                  : PrimaryButton(
                      label: localizations.loginSignIn,
                      icon: Icons.arrow_forward_rounded,
                      onPressed: state.status == LoginStatus.loading || state.isRateLimited
                          ? null
                          : () => _onSubmit(state, cubit),
                    ),
            ],
          ),
        );
      },
    );
  }

  String? _mapEmailError(String? errorKey, AppLocalizations localizations) {
    if (errorKey == null) return null;
    switch (errorKey) {
      case 'email_empty':
        return localizations.loginEmailRequired;
      case 'email_invalid':
        return localizations.loginEmailInvalid;
      default:
        return null;
    }
  }

  String? _mapPasswordError(String? errorKey, AppLocalizations localizations) {
    if (errorKey == null) return null;
    switch (errorKey) {
      case 'password_empty':
        return localizations.loginPasswordRequired;
      default:
        return null;
    }
  }

  void _onSubmit(LoginState state, LoginCubit cubit) {
    if (state.status != LoginStatus.loading) {
      cubit.login();
    }
  }
}
