# Quickstart: Forget Password Page

**Feature**: 001-forget-password
**Date**: 2026-02-22

## Prerequisites

- Flutter SDK 3.11+
- Dart 3.11+
- Project dependencies installed (`flutter pub get`)

## Implementation Steps

### 1. Add Localization Keys

Add to `lib/core/localization/l10n/AppLocalizations_en.dart`:

```dart
// Add these getters
String get forgotPasswordTitle => 'Forget Password ?';
String get forgotPasswordDescription => 'Don\'t worry! It occurs. Please enter the email address linked with your account.';
String get forgotPasswordEmailLabel => 'Enter Your Email Address';
String get forgotPasswordEmailPlaceholder => 'yourmail@gmail.com';
String get forgotPasswordSend => 'Send';
String get forgotPasswordSuccess => 'Reset link sent successfully';
String get forgotPasswordEmailRequired => 'Email is required';
String get forgotPasswordEmailInvalid => 'Please enter a valid email';
```

Add to `lib/core/localization/l10n/AppLocalizations_ar.dart` with Arabic translations.

Update `lib/core/localization/l10n/AppLocalizations.dart` with abstract getters.

### 2. Create Cubit

**File**: `lib/features/auth/presentation/cubit/forgot_password_state.dart`

```dart
import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus { initial, success }

class ForgotPasswordState extends Equatable {
  final String email;
  final String? emailError;
  final bool isSubmitting;
  final ForgotPasswordStatus status;

  const ForgotPasswordState({
    this.email = '',
    this.emailError,
    this.isSubmitting = false,
    this.status = ForgotPasswordStatus.initial,
  });

  bool get isValid => 
      email.isNotEmpty && 
      emailError == null;

  ForgotPasswordState copyWith({
    String? email,
    String? emailError,
    bool? isSubmitting,
    ForgotPasswordStatus? status,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailError: emailError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [email, emailError, isSubmitting, status];
}
```

**File**: `lib/features/auth/presentation/cubit/forgot_password_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void emailChanged(String value) {
    final error = Validators.validateEmail(value);
    emit(state.copyWith(
      email: value,
      emailError: error,
      status: ForgotPasswordStatus.initial,
    ));
  }

  Future<void> submit() async {
    if (!state.isValid) return;
    
    emit(state.copyWith(isSubmitting: true));
    
    // UI only - simulate delay then show success
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(state.copyWith(
      isSubmitting: false,
      status: ForgotPasswordStatus.success,
    ));
  }

  void resetAfterToast() {
    emit(state.copyWith(status: ForgotPasswordStatus.initial));
  }
}
```

### 3. Create Form Widget

**File**: `lib/features/auth/presentation/widgets/forgot_password_form.dart`

```dart
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
        _EmailField(),
        const SizedBox(height: AppDimensions.spacingLg),
        _SubmitButton(),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (prev, curr) => prev.email != curr.email || prev.emailError != curr.emailError,
      builder: (context, state) {
        return TextField(
          onChanged: context.read<ForgotPasswordCubit>().emailChanged,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofocus: true,
          autofillHints: const [AutofillHints.email],
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
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (prev, curr) => prev.isValid != curr.isValid || prev.isSubmitting != curr.isSubmitting,
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
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
              ),
            ),
            child: Text(
              localizations.forgotPasswordSend,
              style: AppTypography.buttonLabel,
            ),
          ),
        );
      },
    );
  }
}
```

### 4. Create Page Widget

**File**: `lib/features/auth/presentation/pages/forgot_password_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/wasla_logo.dart';
import '../cubit/forgot_password_cubit.dart';
import '../cubit/forgot_password_state.dart';
import '../widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.success) {
            _showSuccessSnackBar(context, localizations);
            context.read<ForgotPasswordCubit>().resetAfterToast();
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
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
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
                            const _Header(),
                            const SizedBox(height: AppDimensions.spacingMd),
                            const _Illustration(),
                            const SizedBox(height: AppDimensions.spacingMd),
                            _Title(localizations: localizations),
                            const SizedBox(height: AppDimensions.spacingSm),
                            _Description(localizations: localizations),
                            const SizedBox(height: AppDimensions.spacingLg),
                            const ForgotPasswordForm(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, AppLocalizations localizations) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.brandRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
          ),
          content: Text(localizations.forgotPasswordSuccess),
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
    return Image.asset(
      'assets/images/forget password.png',
      height: 120,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
```

### 5. Run Tests

```bash
flutter test test/features/auth/presentation/
```

### 6. Verify

1. Navigate to Login page
2. Click "Forgot Password?"
3. Verify Forget Password page opens
4. Test validation: empty, invalid, valid emails
5. Test Send button state changes
6. Verify toast appears on valid submission
