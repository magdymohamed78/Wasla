import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/resend_otp_use_case.dart';
import '../../domain/use_cases/reset_password_use_case.dart';
import '../cubit/change_password_cubit.dart';
import '../cubit/change_password_state.dart';
import '../cubit/otp_verification_cubit.dart';
import '../cubit/otp_verification_state.dart';
import '../widgets/change_password_form.dart';

class ChangePasswordPage extends StatelessWidget {
  final String email;

  const ChangePasswordPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OtpVerificationCubit(
            resendOtpUseCase: ResendOtpUseCase(context.read<AuthRepository>()),
          )..init(email),
        ),
        BlocProvider(
          create: (context) => ChangePasswordCubit(
            resetPasswordUseCase: ResetPasswordUseCase(
              context.read<AuthRepository>(),
            ),
            email: email,
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<OtpVerificationCubit, OtpVerificationState>(
            listenWhen: (prev, curr) => prev.otp != curr.otp,
            listener: (context, state) {
              context.read<ChangePasswordCubit>().otpChanged(state.otp);
            },
          ),
          BlocListener<ChangePasswordCubit, ChangePasswordState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status || prev.errorType != curr.errorType,
            listener: (context, state) {
              if (state.status == ChangePasswordStatus.success) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 4),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusSm,
                        ),
                      ),
                      content: Text(localizations.changePasswordSuccess),
                    ),
                  );
                context.go(AppRouter.login);
              }

              // otpExpired (permanently locked after 5 attempts): redirect to
              // forgot-password so the user can request a brand new OTP.
              if (state.status == ChangePasswordStatus.failure &&
                  state.errorType == ChangePasswordErrorType.otpExpired) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 4),
                      backgroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusSm,
                        ),
                      ),
                      content: Text(localizations.errorExpiredOtp),
                    ),
                  );
                Future.delayed(const Duration(seconds: 3), () {
                  if (context.mounted) {
                    context.go(AppRouter.forgotPassword);
                  }
                });
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      const SizedBox(height: AppDimensions.spacingXxl),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        padding: const EdgeInsets.all(AppDimensions.paddingLg),
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
                            const SizedBox(height: AppDimensions.spacingXl),
                            const _Illustration(),
                            const SizedBox(height: AppDimensions.spacingMd),
                            _Title(localizations: localizations),
                            const SizedBox(height: AppDimensions.spacingSm),
                            _Description(localizations: localizations),
                            const SizedBox(height: AppDimensions.spacingXxl),
                            const ChangePasswordForm(),
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


class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Change password illustration',
      child: Image.asset(
        'assets/images/changepassword.png',
        height: 120,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Failed to load change password image: $error');
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
      localizations.changePasswordTitle,
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
      localizations.changePasswordDescription,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
      textAlign: TextAlign.center,
    );
  }
}
