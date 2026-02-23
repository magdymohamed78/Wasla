# Quickstart: Customer Portal Sign Up

**Branch**: `020-company-signup` | **Date**: 2026-02-23

## Prerequisites

- Flutter SDK (latest stable, ≥3.11)
- Dart SDK (^3.11.0, included with Flutter)
- Android Studio or VS Code with Flutter extension
- An Android emulator or physical device
- API server running with `/api/customer-portal/register` endpoint available

## Setup

### 1. Dependencies (already installed)

No new dependencies are needed. The feature uses the same packages already in `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.6
  go_router: ^14.8.1
  dio: ^5.7.0
  shared_preferences: ^2.3.3
  flutter_localizations:
    sdk: flutter
  intl: any
```

### 2. Add localization keys

Add the following keys to `lib/core/localization/l10n/app_en.arb`:

```json
{
  "signUpTitle": "Sign Up",
  "signUpFirstName": "First Name",
  "signUpLastName": "Last Name",
  "signUpPhoneNumber": "Phone Number",
  "signUpEmail": "Email Address",
  "signUpEmailHint": "youremail@gmail.com",
  "signUpPassword": "Password",
  "signUpConfirmPassword": "Confirm Password",
  "signUpButton": "Sign Up",
  "signUpHaveAccount": "Already have an account? Log In",
  "signUpHaveAccountAction": "Log In",
  "signUpFirstNameRequired": "First name is required",
  "signUpLastNameRequired": "Last name is required",
  "signUpNameTooLong": "Must be 100 characters or less",
  "signUpPhoneTooLong": "Must be 50 characters or less",
  "signUpEmailRequired": "Email is required",
  "signUpEmailInvalid": "Enter a valid email address",
  "signUpPasswordRequired": "Password is required",
  "signUpPasswordTooShort": "Password must be at least 6 characters",
  "signUpConfirmPasswordRequired": "Please confirm your password",
  "signUpConfirmPasswordMismatch": "Passwords do not match",
  "signUpErrorEmailInUse": "This email is already registered",
  "signUpErrorServer": "Something went wrong. Please try again later.",
  "signUpErrorNetwork": "No internet connection. Please check your network.",
  "signUpErrorUnexpected": "An unexpected error occurred. Please try again."
}
```

Add corresponding Arabic keys to `lib/core/localization/l10n/app_ar.arb`:

```json
{
  "signUpTitle": "إنشاء حساب",
  "signUpFirstName": "الاسم الأول",
  "signUpLastName": "اسم العائلة",
  "signUpPhoneNumber": "رقم الهاتف",
  "signUpEmail": "البريد الإلكتروني",
  "signUpEmailHint": "youremail@gmail.com",
  "signUpPassword": "كلمة المرور",
  "signUpConfirmPassword": "تأكيد كلمة المرور",
  "signUpButton": "إنشاء حساب",
  "signUpHaveAccount": "لديك حساب بالفعل؟ تسجيل الدخول",
  "signUpHaveAccountAction": "تسجيل الدخول",
  "signUpFirstNameRequired": "الاسم الأول مطلوب",
  "signUpLastNameRequired": "اسم العائلة مطلوب",
  "signUpNameTooLong": "يجب أن يكون 100 حرف أو أقل",
  "signUpPhoneTooLong": "يجب أن يكون 50 حرف أو أقل",
  "signUpEmailRequired": "البريد الإلكتروني مطلوب",
  "signUpEmailInvalid": "أدخل بريد إلكتروني صالح",
  "signUpPasswordRequired": "كلمة المرور مطلوبة",
  "signUpPasswordTooShort": "كلمة المرور يجب أن تكون 6 أحرف على الأقل",
  "signUpConfirmPasswordRequired": "يرجى تأكيد كلمة المرور",
  "signUpConfirmPasswordMismatch": "كلمات المرور غير متطابقة",
  "signUpErrorEmailInUse": "هذا البريد الإلكتروني مسجل بالفعل",
  "signUpErrorServer": "حدث خطأ ما. يرجى المحاولة مرة أخرى لاحقاً.",
  "signUpErrorNetwork": "لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.",
  "signUpErrorUnexpected": "حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى."
}
```

### 3. Regenerate localizations

```bash
flutter gen-l10n
```

### 4. Create new files

Create the following files (see data-model.md and research.md for detailed structure):

| File | Purpose |
|------|---------|
| `lib/features/auth/data/models/register_request_model.dart` | Request body model |
| `lib/features/auth/domain/use_cases/register_use_case.dart` | Registration use case |
| `lib/features/auth/presentation/cubit/register_cubit.dart` | Registration state management |
| `lib/features/auth/presentation/cubit/register_state.dart` | Registration state class |
| `lib/features/auth/presentation/pages/sign_up_page.dart` | Sign Up page widget |
| `lib/features/auth/presentation/widgets/sign_up_form.dart` | Sign Up form widget |

### 5. Modify existing files

| File | Change |
|------|--------|
| `lib/features/auth/data/data_sources/auth_remote_data_source.dart` | Add `register()` method |
| `lib/features/auth/domain/repositories/auth_repository.dart` | Add `register()` abstract method |
| `lib/features/auth/data/repositories/auth_repository_impl.dart` | Add `register()` implementation |
| `lib/core/utils/validators.dart` | Add `validateName()`, `validatePhone()`, `validatePasswordLength()` |
| `lib/core/routing/app_router.dart` | Swap `RegisterPlaceholderPage` → `SignUpPage` with `BlocProvider<RegisterCubit>` |
| `lib/core/localization/l10n/app_en.arb` | Add `signUp*` keys |
| `lib/core/localization/l10n/app_ar.arb` | Add `signUp*` keys (Arabic) |

### 6. Delete placeholder

Delete `lib/features/auth/presentation/pages/register_placeholder_page.dart` after replacing it.

## Running the App

```bash
flutter run
```

## Verification Checklist

After running, verify the following:

1. **Navigation to Sign Up** → From login page, tap "Sign Up" link → navigates to Sign Up page.
2. **Visual consistency** → Sign Up page has same background, logo, card container, input styling as login page.
3. **Form fields** → 6 fields present in order: First Name, Last Name, Phone Number, Email, Password, Confirm Password.
4. **Validation (empty fields)** → Leave required fields empty, tap Sign Up → error messages appear below each empty required field.
5. **Validation (email)** → Enter invalid email → "Enter a valid email address" appears.
6. **Validation (password length)** → Enter 3-char password → "Password must be at least 6 characters" appears.
7. **Validation (password match)** → Enter mismatched passwords → "Passwords do not match" appears below confirm password.
8. **Button state** → Button is disabled when validation errors exist, enabled when all fields are valid.
9. **Password toggle** → Tap eye icon on password field → text becomes visible. Tap again → obscured. Same for confirm password independently.
10. **Successful registration** → Fill valid data, tap Sign Up → loading indicator → navigates to home screen.
11. **Duplicate email** → Register with an already-used email → inline error "This email is already registered" below email field.
12. **Server error** → Simulate 500 error → snackbar with "Something went wrong" + retry button.
13. **Network error** → Disable network, submit → snackbar with "No internet connection" + retry button.
14. **Form preservation** → After any error, all form data is preserved (user can correct and resubmit).
15. **Back navigation** → From Sign Up page, tap "Already have an account? Log In" → navigates to login page.
16. **Arabic/RTL** → Switch to Arabic → all labels, errors, and button text display in Arabic with RTL layout.

## Key Technical Decisions (see research.md for details)

| Area | Decision |
|------|----------|
| Response model | Reuse `LoginResponseModel` / `LoginEntity` (same API response schema) |
| Error display | Mixed: field-specific inline, general as snackbar |
| State management | Separate `RegisterCubit` + `RegisterState` (not shared with login) |
| Validation | Extend `Validators` utility + cubit-level confirm password check |
| Session persistence | Reuse existing `AuthLocalDataSource.saveToken()` + `saveUser()` |
| Route wiring | Replace placeholder page import, add `BlocProvider<RegisterCubit>` |
| Localization | `signUp*` prefixed ARB keys, English + Arabic |
