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
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/forgot_password_use_case.dart';
import '../cubit/forgot_password_cubit.dart';
import '../cubit/forgot_password_state.dart';
import '../widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => ForgotPasswordCubit(
        forgotPasswordUseCase: ForgotPasswordUseCase(
          context.read<AuthRepository>(),
        ),
      ),
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.success) {
            context.push(AppRouter.changePassword, extra: {'email': state.email});
            context.read<ForgotPasswordCubit>().resetAfterToast();
          } else if (state.status == ForgotPasswordStatus.failure &&
              state.errorMessage != null) {
            if (state.errorMessage == 'inactive') {
              _showInactiveSnackBar(context);
            } else {
              _showErrorSnackBar(context, state.errorMessage!);
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _Header(),
                      const SizedBox(height: AppDimensions.spacingXxl),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        padding: const EdgeInsets.all(
                          AppDimensions.paddingLg,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 60,
                              offset: Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             const SizedBox(height: AppDimensions.spacingXxl),
                            const _Illustration(),
                            const SizedBox(height: AppDimensions.spacingMd),
                            _Title(localizations: localizations),
                            const SizedBox(height: AppDimensions.spacingSm),
                            _Description(localizations: localizations),
                            const SizedBox(height: AppDimensions.spacingXl),
                            const ForgotPasswordForm(),
                          ],
                        ),
                      ),
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
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Directionality(
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
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Password reset illustration',
      child: Image.asset(
        'assets/images/forgetpassword.png',
        height: 120,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Failed to load forget password image: $error');
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Text(
      localizations.forgotPasswordTitle,
      style: AppTypography.heading2,
      textAlign: TextAlign.center,
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Text(
      localizations.forgotPasswordDescription,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
      textAlign: TextAlign.center,
    );
  }
}

void _showInactiveSnackBar(BuildContext context) {
  final localizations = AppLocalizations.of(context);

  ToastUtils.showError(
    context,
    localizations.forgotPasswordInactiveAccount,
    action: SnackBarAction(
      label: localizations.forgotPasswordContactSupport,
      textColor: Colors.white,
      onPressed: () {
        context.push(AppRouter.support);
      },
    ),
  );
}

void _showErrorSnackBar(BuildContext context, String errorKey) {
  final localizations = AppLocalizations.of(context);
  final message = _mapErrorMessage(errorKey, localizations);

  ToastUtils.showError(context, message);
}

String _mapErrorMessage(String errorKey, AppLocalizations localizations) {
  switch (errorKey) {
    case 'notFound':
      return localizations.forgotPasswordNotRegistered;
    case 'inactive':
      return localizations.forgotPasswordInactiveAccount;
    case 'rateLimit':
      return localizations.errorRateLimit;
    case 'network':
      return localizations.errorNetwork;
    default:
      return localizations.errorServer;
  }
}
