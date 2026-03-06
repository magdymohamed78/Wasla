# Research: Forgot Password Flow

**Feature**: 024-forgot-password-flow  
**Date**: 2026-03-05  
**Status**: Complete

## 1. Existing Forgot Password Implementation

**Decision**: Refactor the existing UI-only `ForgotPasswordCubit` and `ForgotPasswordPage` to integrate real API calls, rather than creating entirely new files for Screen A.

**Rationale**: The existing `ForgotPasswordCubit` already has `emailChanged()`, `submit()`, form validation, and `ForgotPasswordState` with `email`, `emailError`, `isSubmitting`, `isValid`. The page already uses `BlocProvider<ForgotPasswordCubit>` and `BlocListener` with snackbar feedback. Refactoring is less disruptive and reuses validated UI. The cubit currently uses `Future.delayed(500ms)` as a stub — this will be replaced with a real `ForgotPasswordUseCase` call.

**Alternatives considered**:
- Create entirely new cubit/page: Rejected — would duplicate existing UI work and require deleting old files.

---

## 2. State Management Pattern (Cubit vs full Bloc)

**Decision**: Use the Cubit pattern (not full Bloc with events) for all three screens.

**Rationale**: The entire project uses Cubit exclusively — `LoginCubit`, `RegisterCubit`, `ForgotPasswordCubit`, `SplashCubit` all use `Cubit<State>` with `emit()` and `copyWith()`. The `LoginCubit` provides the most comprehensive reference pattern with: status enum (`initial/loading/success/failure`), error codes, error categories, rate limit cooldown timer, field validation, and `DioException` handling.

**Alternatives considered**:
- Full Bloc with event classes: Rejected — breaks project consistency; Cubit is sufficient for form-based flows.

---

## 3. Data Passing Between Screens

**Decision**: Pass `email` and `otp` as route parameters using GoRouter's `extra` parameter or query parameters.

**Rationale**: The project uses `GoRouter` with `context.push()` for navigation. The existing pattern in `login_page.dart` uses `context.push(AppRouter.forgotPassword)` without params. For the forgot password flow, `email` must flow from Screen A → B → C, and `otp` from Screen B → C. GoRouter supports `extra` (typed object) or path/query params. Since these are simple strings and not persisted, `extra` with a typed record/class is the cleanest approach.

**Alternatives considered**:
- Global state/shared cubit: Rejected — over-engineering for two string values; creates coupling.
- Path parameters (e.g., `/otp/:email`): Rejected — email in URL is a security concern; `extra` keeps data in-memory only.

---

## 4. Error Handling Pattern

**Decision**: Follow the `LoginCubit` error handling pattern with status enum, error codes, and error categories.

**Rationale**: `LoginCubit` already handles `DioException` with status code mapping (400, 401, 429, 500+), network errors (`connectionTimeout`, `sendTimeout`, `connectionError`), rate limit cooldown timers, and structured error categories. This exact pattern applies to the forgot password endpoints, which return the same HTTP status codes (200, 400, 429).

**Key mappings for this feature**:
- `forgot-password` → 200 (always success, navigate to OTP), 429 (rate limit error)
- `reset-password` → 200 (success, toast + navigate to login), 400 (expired OTP → auto-navigate back to Screen A; password policy → inline error), 429 (rate limit error)
- `resend-otp` → 200 (success, restart timer), 429 (rate limit error, show message + restart timer)

**Alternatives considered**:
- Simple try/catch with string messages: Rejected — structured error codes enable UI-specific responses (e.g., auto-navigate on expired OTP vs. inline error on password policy).

---

## 5. OTP Input Widget Design

**Decision**: Create a custom `OtpInputField` widget with 6 `TextFormField` controllers and `FocusNode` instances.

**Rationale**: No OTP input package is in the project's dependencies, and adding a third-party package for a single widget increases dependency surface. A custom widget with 6 controllers provides full control over: auto-advance on digit entry, backspace to previous field, paste support (intercepting clipboard), visual states (default/focused/filled/error), and RTL support.

**Implementation approach**:
- 6 `TextEditingController` + 6 `FocusNode` managed in the widget
- `onChanged` handler: if digit entered → advance focus; if empty (backspace) → move to previous
- Paste detection: listen on first field, distribute 6 digits across all fields
- Visual sizing: ~40-44px square boxes with ~10-12px gap (per spec FR-012)
- Expose `onCompleted(String otp)` callback when all 6 digits filled

**Alternatives considered**:
- `pin_code_fields` package: Rejected — not in current dependencies; custom widget is straightforward.
- Single `TextField` with letter spacing: Rejected — doesn't match the spec's "6 individual input boxes" requirement; poor UX for backspace behavior.

---

## 6. Timer Implementation for OTP Screen

**Decision**: Use `dart:async` `Timer.periodic` in `OtpVerificationCubit`, following the `LoginCubit`'s rate limit cooldown pattern.

**Rationale**: `LoginCubit` already implements a countdown timer with `Timer.periodic(Duration(seconds: 1))`, decrementing `rateLimitRemainingSeconds` each tick and cleaning up in `close()`. The OTP screen needs an identical pattern: 60-second countdown, show/hide resend button based on remaining time, restart on resend success or 429 error.

**State fields needed**: `timerRemainingSeconds` (int), `canResend` (bool, derived: `timerRemainingSeconds == 0`).

**Alternatives considered**:
- `Stream.periodic`: Rejected — `Timer.periodic` is already the established pattern and integrates cleanly with Cubit `emit()`.
- Third-party timer package: Rejected — unnecessary dependency.

---

## 7. Request Model Pattern

**Decision**: Create 3 new request models following the existing `LoginRequestModel` / `RegisterRequestModel` pattern: `toJson()` method, constructor with required fields.

**Rationale**: All existing request models (`LoginRequestModel`, `RegisterRequestModel`, `RefreshTokenRequestModel`) follow the same pattern: class with final fields, constructor, `toJson()` method returning `Map<String, dynamic>`. No `fromJson` needed for request-only models. The 3 endpoints need:
- `ForgotPasswordRequestModel(email)` → `{ "email": email }`
- `ResendOtpRequestModel(email)` → `{ "email": email }`
- `ResetPasswordRequestModel(email, otp, newPassword, confirmNewPassword)` → `{ "email": email, "otp": otp, "newPassword": newPassword, "confirmNewPassword": confirmNewPassword }`

**Alternatives considered**:
- Inline JSON maps in data source: Rejected — breaks the model abstraction pattern used everywhere else.

---

## 8. Use Case Pattern

**Decision**: Create 3 new use cases following the existing `LoginUseCase` / `RegisterUseCase` pattern.

**Rationale**: Existing use cases take the repository in their constructor and expose a `call()` method. `ForgotPasswordUseCase.call(email)`, `ResendOtpUseCase.call(email)`, `ResetPasswordUseCase.call(email, otp, newPassword, confirmNewPassword)`. These endpoints return no domain entity (just success/failure), so the use cases return `Future<void>` and throw on error.

**Alternatives considered**:
- Call repository directly from cubit: Rejected — breaks the Clean Architecture use case layer that exists for all other auth operations.

---

## 9. Route Configuration

**Decision**: Add 2 new routes to `AppRouter`: `/otp-verification` and `/change-password`. Keep existing `/forgot-password` route.

**Rationale**: The existing `AppRouter` defines static const route paths and `GoRoute` entries. Two new routes are needed for the OTP and Change Password screens. Data (email, OTP) will be passed via GoRouter's `extra` parameter as typed records.

**Route definitions**:
- `static const otpVerification = '/otp-verification'` → `OtpVerificationPage(email: extra.email)`
- `static const changePassword = '/change-password'` → `ChangePasswordPage(email: extra.email, otp: extra.otp)`

**Alternatives considered**:
- Nested routes under `/forgot-password`: Rejected — the screens are sequential but independent (user can't deep-link mid-flow); flat routes are simpler.

---

## 10. Navigation Flow After Password Reset

**Decision**: On successful reset, show a success `SnackBar`, then navigate to Login using `context.go(AppRouter.login)` (replace stack, not push).

**Rationale**: After password reset, the user should land on Login with no back-stack to the forgot password flow. Using `context.go()` replaces the navigation stack. The success toast uses the same `SnackBar` pattern as the existing forgot password page. The clarification confirmed: show toast first, then navigate.

**Alternatives considered**:
- Push to login (allowing back navigation): Rejected — user could navigate back to the change password screen with a used OTP.
- Navigate without toast: Rejected — clarification explicitly requires success feedback before redirect.

---

## 11. Localization

**Decision**: Add new localization keys for all three screens' text content to the existing `app_en.arb` / `app_ar.arb` files.

**Rationale**: The project uses Flutter's built-in localization with `.arb` files (configured in `l10n.yaml`). All user-facing strings must be localized. New keys needed for: screen titles, descriptions, button labels, error messages, timer text, success messages.

**Alternatives considered**:
- Hardcoded strings: Rejected — project already uses localization throughout; would be inconsistent and block RTL/Arabic support.

---

## 12. Auto-Navigate on Expired OTP Error (Screen C → Screen A)

**Decision**: When `reset-password` returns 400 with an expired/invalid OTP error, show the error message on Screen C for 2-3 seconds, then auto-navigate back to Screen A using `context.go(AppRouter.forgotPassword)`.

**Rationale**: Per clarification, the user should see the error, then be taken back to restart the flow. Using `Future.delayed` + navigation in `BlocListener` matches the existing pattern. `context.go()` clears the stack so the user starts fresh.

**Key distinction**: The 400 response from `reset-password` can mean either expired OTP OR password policy violation. The error needs to be differentiated:
- If the error message contains OTP-related text → auto-navigate back to Screen A
- If the error message is about password policy → show inline error, stay on Screen C

**Alternatives considered**:
- Immediate redirect without showing error: Rejected — user wouldn't understand why they're back on Screen A.
- Manual "Go Back" button: Rejected — clarification specifies auto-navigation.
