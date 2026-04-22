import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/wasla_logo.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/login_form.dart';

/// Customer login page with email/password authentication.
///
/// Follows Constitution principles:
/// - **I.** Clean Architecture: delegates to LoginCubit → LoginUseCase → AuthRepository
/// - **IV.** Navigation via BlocListener on LoginState, not in widgets
/// - **V.** Figma-compliant layout
/// - **VI.** All styling from AppColors, AppTypography, AppDimensions
/// - **VII.** Pure presentation — no business logic
class LoginPage extends StatefulWidget {
  final String? authReason;

  const LoginPage({super.key, this.authReason});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _authReasonShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showAuthReasonIfNeeded();
  }

  void _showAuthReasonIfNeeded() {
    if (_authReasonShown) {
      return;
    }

    final authReason = widget.authReason?.trim();
    if (authReason == null || authReason.isEmpty) {
      return;
    }

    _authReasonShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final localizations = AppLocalizations.of(context);
      ToastUtils.showError(
        context,
        _authReasonMessage(authReason, localizations),
      );
    });
  }

  String _authReasonMessage(String authReason, AppLocalizations localizations) {
    switch (authReason) {
      case AppRouter.authReasonUpgradeRelogin:
        return localizations.requestFlowLeadReloginPromptMessage;
      case AppRouter.authReasonSessionExpired:
      default:
        return localizations.loginSessionExpired;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == LoginStatus.failure ||
              current.status == LoginStatus.success),
      listener: (context, state) {
        if (state.status == LoginStatus.failure) {
          _showErrorSnackBar(
            context,
            state.errorCode,
            localizations,
            state.errorCategory,
          );
        }

        if (state.status == LoginStatus.success) {
          context.go(state.postLoginRoute ?? AppRouter.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      const SizedBox(height: AppDimensions.spacingXxl),

                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const WaslaLogo(size: AppDimensions.logoSizeMedium),
                            Text(
                              'ASLA',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: AppColors.brandRed,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingXl),

                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Container(
                            padding: const EdgeInsets.all(
                              AppDimensions.paddingLg,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cardShadow,
                                  blurRadius: 60,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  localizations.loginTitle,
                                  style: AppTypography.heading2,
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(
                                  height: AppDimensions.spacingXxl,
                                ),

                                LoginForm(
                                  onForgotPasswordTap: () =>
                                      context.push(AppRouter.forgotPassword),
                                ),

                                const SizedBox(height: AppDimensions.spacingMd),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localizations.loginSignUp.split(
                                        localizations.loginSignUpAction,
                                      )[0],
                                      style: AppTypography.bodyMedium,
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          context.push(AppRouter.register),
                                      child: Text(
                                        localizations.loginSignUpAction,
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                              color: AppColors.brandRed,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: AppDimensions.spacingXxl,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingXxl),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(
    BuildContext context,
    LoginErrorCode? errorCode,
    AppLocalizations localizations,
    LoginErrorCategory? errorCategory,
  ) {
    final message = _mapErrorCodeToMessage(errorCode, localizations);

    final showRetry =
        errorCategory == LoginErrorCategory.server ||
        errorCategory == LoginErrorCategory.network;

    ToastUtils.showError(
      context,
      message,
      action: showRetry
          ? SnackBarAction(
              label: localizations.networkErrorRetry,
              textColor: Colors.white,
              onPressed: () {
                context.read<LoginCubit>().login();
              },
            )
          : null,
    );
  }

  String _mapErrorCodeToMessage(
    LoginErrorCode? errorCode,
    AppLocalizations localizations,
  ) {
    switch (errorCode) {
      case LoginErrorCode.invalidCredentials:
        return localizations.loginErrorInvalidCredentials;
      case LoginErrorCode.accountNotSetup:
        return localizations.loginErrorAccountNotSetup;
      case LoginErrorCode.rateLimit:
        return localizations.loginErrorRateLimit;
      case LoginErrorCode.networkError:
        return localizations.loginErrorNetwork;
      case LoginErrorCode.serverError:
        return localizations.loginErrorServer;
      case LoginErrorCode.sessionExpired:
        return localizations.loginSessionExpired;
      case LoginErrorCode.unexpectedError:
      case null:
        return localizations.loginUnexpectedError;
    }
  }
}
