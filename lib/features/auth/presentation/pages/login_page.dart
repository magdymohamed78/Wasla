import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
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
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == LoginStatus.failure,
      listener: (context, state) {
        if (state.status == LoginStatus.failure) {
          _showErrorSnackBar(context, state.errorMessage, localizations);
        }

        if (state.status == LoginStatus.success) {
          context.go(AppRouter.home);
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

                                const SizedBox(height: AppDimensions.spacingXxl),

                                const LoginForm(),

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
    String? errorMessage,
    AppLocalizations localizations,
  ) {
    if (errorMessage == null || errorMessage.isEmpty) {
      errorMessage = localizations.loginUnexpectedError;
    }
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
          ),
          content: Row(
            children: [
              Expanded(child: Text(errorMessage)),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  context.read<LoginCubit>().login();
                },
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
