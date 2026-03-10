# Research: Update Forgot Password Endpoint Error Handling

**Feature**: 026-forgot-password-errors  
**Date**: 2026-03-10

## Research Tasks

### 1. How does the existing cubit map DioException status codes?

**Decision**: Extend the existing `_mapDioError` method in `ForgotPasswordCubit` to return distinct error keys for 404 and 403.

**Rationale**: The cubit already has a `_mapDioError(DioException e)` method that checks `e.response?.statusCode`. Currently it only handles 429 → `'rateLimit'` and falls through to network/server defaults. Adding `404 → 'notFound'` and `403 → 'inactive'` follows the exact same pattern with no structural changes.

**Alternatives considered**:
- Creating a shared error mapper class → rejected: only one cubit uses this, no reuse need.
- Throwing typed exceptions from the data layer → rejected: overengineered for two additional status codes; the DioException already carries the status code.

### 2. How does the page display error toast messages?

**Decision**: Extend the existing `_mapErrorMessage` function in `forgot_password_page.dart` to handle the new `'notFound'` and `'inactive'` error keys. For the 403 (`'inactive'`) case, the snackbar must include a "Contact Support" action button that navigates to the Support page via `context.push(AppRouter.support)`.

**Rationale**: The page already has a `BlocListener` that calls `_showErrorSnackBar` when `state.status == ForgotPasswordStatus.failure`. The `_mapErrorMessage` switch statement maps error keys to localized strings. Adding two new cases follows the existing pattern. The 403 snackbar needs special handling: instead of using the generic `_showErrorSnackBar`, the listener should detect the `'inactive'` error key and show a snackbar with a `SnackBarAction` that navigates to `/support`.

**Alternatives considered**:
- Using a dialog instead of a snackbar → rejected: spec explicitly requires toast messages; snackbar is the existing toast mechanism.
- Adding error text inline in the form → rejected: spec says toast only; the form's `_ErrorMessage` widget exists but is for inline display, not relevant here.
- Adding a persistent button on the page for Support → rejected: the action belongs in the toast itself for a contextual, non-permanent affordance.

### 3. How should the static "Don't have an account? Sign Up" link be implemented?

**Decision**: Add a new private widget (e.g., `_SignUpLink`) at the bottom of the `ForgotPasswordForm` column, below the Submit button, using the same visual pattern as the Login page's sign-up link.

**Rationale**: The login page already has a `loginSignUp` / `loginSignUpAction` pattern using a `RichText` with a `TextSpan` + `TapGestureRecognizer` or a `TextButton`. The same approach should be used for consistency. The link navigates using `context.push(AppRouter.register)`. This is a static widget — always visible, not conditional on any error state.

**Alternatives considered**:
- Making the link conditional on 404 error state → rejected: clarification from the user explicitly stated it should always be visible.
- Using a full `ElevatedButton` → rejected: spec says "text button" and the login page uses inline text styling.

### 4. What localization keys are needed?

**Decision**: Add 5 new keys to both `app_en.arb` and `app_ar.arb`:

| Key | English | Arabic |
|-----|---------|--------|
| `forgotPasswordNotRegistered` | "Email not registered. Please sign up first." | "البريد الإلكتروني غير مسجل. يرجى إنشاء حساب أولاً." |
| `forgotPasswordInactiveAccount` | "Account exists but is inactive — please contact support." | "الحساب موجود لكنه غير مفعل — يرجى التواصل مع الدعم." |
| `forgotPasswordSignUp` | "Don't have an account? Sign Up" | "ليس لديك حساب؟ سجل الآن" |
| `forgotPasswordSignUpAction` | "Sign Up" | "سجل الآن" |
| `forgotPasswordContactSupport` | "Contact Support" | "تواصل مع الدعم" |

**Rationale**: Follows exactly the naming convention used by `loginSignUp` / `loginSignUpAction`. The toast messages use dedicated keys rather than the generic `errorServer` to enable specific, actionable user guidance.

**Alternatives considered**:
- Reusing `loginSignUp` key → rejected: the key is semantically tied to the login page; a separate key allows independent text evolution.
- Hardcoding strings → rejected: app uses flutter_localizations with ARB files; all user-facing strings must be localized.

### 5. What is the existing navigation pattern for the Sign Up page?

**Decision**: Use `context.push(AppRouter.register)` — the route is `/register` and resolves to `SignUpPage`.

**Rationale**: Confirmed from `app_router.dart` that `static const String register = '/register'` maps to `SignUpPage()`. The login page navigates to sign-up using the same `context.push(AppRouter.register)` pattern.

**Alternatives considered**: None — the route exists and the pattern is established.

### 6. How does navigation blocking work on error?

**Decision**: No code change needed. The current `BlocListener` only navigates on `ForgotPasswordStatus.success`. When a `DioException` is thrown with 404 or 403, the cubit emits `ForgotPasswordStatus.failure`, which never triggers navigation. Navigation is already gated on success status.

**Rationale**: Verified in the existing listener: `if (state.status == ForgotPasswordStatus.success) { context.push(AppRouter.changePassword, ...) }`. Failure states only trigger `_showErrorSnackBar`. No additional blocking logic is required.

**Alternatives considered**: None — the architecture already prevents navigation on failure.
