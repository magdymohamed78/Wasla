# Quickstart: Forgot Password Flow Implementation

**Feature**: 024-forgot-password-flow  
**Branch**: `024-forgot-password-flow`  
**Date**: 2026-03-05

## Prerequisites

- Flutter SDK ^3.11.0 installed
- Project compiles and runs (`flutter run`)
- Familiarity with the existing auth feature structure under `lib/features/auth/`

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│  Presentation Layer                                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  │
│  │ ForgotPassword    │→│ OtpVerification   │→│ ChangePassword    │  │
│  │ Page + Cubit      │  │ Page + Cubit      │  │ Page + Cubit     │  │
│  └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘  │
│           │                      │                      │           │
│           ▼                      ▼                      ▼           │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  │
│  │ ForgotPasswordUC  │  │ ResendOtpUC      │  │ ResetPasswordUC   │  │
│  └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘  │
├───────────┼──────────────────────┼──────────────────────┼───────────┤
│  Domain   │ AuthRepository (abstract)                    │          │
├───────────┼──────────────────────────────────────────────┼──────────┤
│  Data     │                                              │          │
│  ┌────────▼─────────────────────────────────────────────▼────────┐  │
│  │ AuthRepositoryImpl                                             │  │
│  │  → AuthRemoteDataSource (Dio)                                  │  │
│  │    → POST /api/Auth/forgot-password                           │  │
│  │    → POST /api/Auth/resend-otp                                │  │
│  │    → POST /api/Auth/reset-password                            │  │
│  └────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

## Implementation Order

Follow this order to ensure each layer builds on the previous:

### Step 1: Request Models (Data Layer)

Create 3 new files under `lib/features/auth/data/models/`:

1. **`forgot_password_request_model.dart`**
   ```dart
   class ForgotPasswordRequestModel {
     final String email;
     const ForgotPasswordRequestModel({required this.email});
     Map<String, dynamic> toJson() => {'email': email};
   }
   ```

2. **`resend_otp_request_model.dart`**
   ```dart
   class ResendOtpRequestModel {
     final String email;
     const ResendOtpRequestModel({required this.email});
     Map<String, dynamic> toJson() => {'email': email};
   }
   ```

3. **`reset_password_request_model.dart`**
   ```dart
   class ResetPasswordRequestModel {
     final String email;
     final String otp;
     final String newPassword;
     final String confirmNewPassword;
     const ResetPasswordRequestModel({
       required this.email,
       required this.otp,
       required this.newPassword,
       required this.confirmNewPassword,
     });
     Map<String, dynamic> toJson() => {
       'email': email,
       'otp': otp,
       'newPassword': newPassword,
       'confirmNewPassword': confirmNewPassword,
     };
   }
   ```

### Step 2: Remote Data Source Methods

Add 3 methods to `lib/features/auth/data/data_sources/auth_remote_data_source.dart`:

- `Future<void> forgotPassword(ForgotPasswordRequestModel request)` — `POST /api/Auth/forgot-password`
- `Future<void> resendOtp(ResendOtpRequestModel request)` — `POST /api/Auth/resend-otp`
- `Future<void> resetPassword(ResetPasswordRequestModel request)` — `POST /api/Auth/reset-password`

Follow the existing pattern: `_dio.post(url, data: request.toJson())` with `debugPrint` logging and `DioException` propagation.

### Step 3: Domain Repository & Use Cases

1. Add 3 abstract methods to `lib/features/auth/domain/repositories/auth_repository.dart`:
   - `Future<void> forgotPassword({required String email})`
   - `Future<void> resendOtp({required String email})`
   - `Future<void> resetPassword({required String email, required String otp, required String newPassword, required String confirmNewPassword})`

2. Implement in `lib/features/auth/data/repositories/auth_repository_impl.dart` — delegate to `AuthRemoteDataSource`.

3. Create 3 use cases under `lib/features/auth/domain/use_cases/`:
   - `ForgotPasswordUseCase` — takes `AuthRepository`, `call({required String email})`
   - `ResendOtpUseCase` — takes `AuthRepository`, `call({required String email})`
   - `ResetPasswordUseCase` — takes `AuthRepository`, `call({required String email, required String otp, required String newPassword, required String confirmNewPassword})`

### Step 4: Validators

Add to `lib/core/utils/validators.dart`:

- `static String? validateOtp(String otp)` — returns error if not exactly 6 digits
- `static String? validatePasswordMatch(String password, String confirmPassword)` — returns "Passwords do not match" if different

### Step 5: States & Cubits (Presentation Layer)

1. **Modify** `ForgotPasswordState` — add `loading`/`failure` to status enum, add `errorMessage` field
2. **Modify** `ForgotPasswordCubit` — inject `ForgotPasswordUseCase`, replace `Future.delayed` stub with real API call
3. **Create** `OtpVerificationState` + `OtpVerificationCubit` — timer management, digit entry, resend OTP
4. **Create** `ChangePasswordState` + `ChangePasswordCubit` — password validation, reset API call, error type differentiation

### Step 6: Pages & Widgets (UI)

1. **Modify** `ForgotPasswordPage` — navigate to OTP screen on success (instead of showing snackbar)
2. **Modify** `ForgotPasswordForm` — add loading/error state handling
3. **Create** `OtpInputField` widget — 6 individual text fields with auto-advance/backspace/paste
4. **Create** `OtpVerificationPage` + `OtpVerificationForm`
5. **Create** `ChangePasswordPage` + `ChangePasswordForm`

### Step 7: Routes

Add to `lib/core/routing/app_router.dart`:

```dart
static const otpVerification = '/otp-verification';
static const changePassword = '/change-password';
```

Add `GoRoute` entries with `extra` parameter for data passing:
- `/otp-verification` → `OtpVerificationPage(email: extra)`
- `/change-password` → `ChangePasswordPage(email: extra.email, otp: extra.otp)`

### Step 8: DI / Provider Setup

The existing pattern creates `ForgotPasswordCubit` locally inside `ForgotPasswordPage` (not globally in `app.dart`). Follow the same pattern:
- `OtpVerificationCubit` created locally in `OtpVerificationPage`
- `ChangePasswordCubit` created locally in `ChangePasswordPage`

However, `ForgotPasswordCubit` now needs `ForgotPasswordUseCase`, so either:
- Add `ForgotPasswordUseCase` to `app.dart`'s `MultiRepositoryProvider` and access via `context.read()` in the page, OR
- Instantiate the use case inline when creating the cubit (simpler, matches existing pattern for locally-scoped cubits)

### Step 9: Localization

Add new keys to `lib/core/localization/app_en.arb` and `lib/core/localization/app_ar.arb`:
- OTP screen title, description, timer text, resend button, verify button
- Change password screen title, description, field labels, confirm button
- Error messages: rate limit, network error, expired OTP, password policy, success toast

### Step 10: Tests

1. **Unit tests** for 3 new use cases
2. **Cubit tests** for modified `ForgotPasswordCubit` + 2 new cubits
3. **Data source tests** for 3 new API methods (mock Dio)
4. **Repository tests** for 3 new repository methods

## Key Patterns to Follow

| Pattern | Reference File | Notes |
|---------|---------------|-------|
| Cubit + State | `login_cubit.dart` / `login_state.dart` | Status enum, copyWith, DioException handling |
| Request Model | `login_request_model.dart` | `toJson()` method, constructor with required fields |
| Data Source | `auth_remote_data_source.dart` | `_dio.post()`, debugPrint logging, error propagation |
| Repository | `auth_repository_impl.dart` | Delegates to remote data source |
| Use Case | `login_use_case.dart` | Constructor takes repository, `call()` method |
| Page + BlocProvider | `forgot_password_page.dart` | Local BlocProvider, BlocListener for navigation |
| Form Widget | `forgot_password_form.dart` | BlocBuilder, field validation, disabled button logic |
| Route Definition | `app_router.dart` | Static const path, GoRoute with builder |
| Error Handling | `login_cubit.dart` | DioException switch on statusCode + type |
| Timer | `login_cubit.dart` | Timer.periodic, cancel in close() |

## API Base URL

```
http://waslacrm.runasp.net/
```

## Endpoints Summary

| Endpoint | Method | Request Body | Success | Errors |
|----------|--------|-------------|---------|--------|
| `/api/Auth/forgot-password` | POST | `{ email }` | 200 (always) | 429 |
| `/api/Auth/resend-otp` | POST | `{ email }` | 200 (always) | 429 |
| `/api/Auth/reset-password` | POST | `{ email, otp, newPassword, confirmNewPassword }` | 200 | 400, 429 |
