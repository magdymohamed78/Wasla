import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/wasla_logo.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == RegisterStatus.failure || current.status == RegisterStatus.success),
      listener: (context, state) {
        if (state.status == RegisterStatus.failure) {
          if (state.errorCategory == RegisterErrorCategory.server ||
              state.errorCategory == RegisterErrorCategory.network) {
            _showErrorSnackBar(context, state, localizations);
          }
        }

        if (state.status == RegisterStatus.success) {
          context.go(AppRouter.registerSuccess);
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
                                  localizations.signUpTitle,
                                  style: AppTypography.heading2,
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: AppDimensions.spacingXxl),

                                const SignUpForm(),

                                const SizedBox(height: AppDimensions.spacingMd),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localizations.signUpHaveAccount.split(
                                        localizations.signUpHaveAccountAction,
                                      )[0],
                                      style: AppTypography.bodyMedium,
                                    ),
                                    GestureDetector(
                                      onTap: () => context.push(AppRouter.login),
                                      child: Text(
                                        localizations.signUpHaveAccountAction,
                                        style: AppTypography.bodyMedium.copyWith(
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
    RegisterState state,
    AppLocalizations localizations,
  ) {
    final message = _mapErrorCodeToMessage(state.errorCode, localizations, state.serverErrorMessage);

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
          ),
          content: Row(
            children: [
              Expanded(child: Text(message)),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  context.read<RegisterCubit>().register();
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

  String _mapErrorCodeToMessage(
    RegisterErrorCode? errorCode,
    AppLocalizations localizations,
    String? serverMessage,
  ) {
    switch (errorCode) {
      case RegisterErrorCode.emailAlreadyRegistered:
        return localizations.signUpErrorEmailInUse;
      case RegisterErrorCode.networkError:
        return localizations.signUpErrorNetwork;
      case RegisterErrorCode.serverError:
        return localizations.signUpErrorServer;
      case RegisterErrorCode.validationError:
      case RegisterErrorCode.badRequest:
        return serverMessage ?? localizations.signUpErrorUnexpected;
      case RegisterErrorCode.unexpectedError:
      case null:
        return localizations.signUpErrorUnexpected;
    }
  }
}
