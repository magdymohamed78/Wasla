# Quickstart: Login Error Response Handling

**Feature**: `011-login-error-handling` | **Date**: 2026-02-20

---

## What This Feature Does

Maps all backend login endpoint error responses to user-friendly snackbar messages on the login screen. Adds rate-limit cooldown behavior (15 seconds) for HTTP 429, conditional retry buttons for server/network errors, and a 4-second snackbar auto-dismiss duration.

## Prerequisites

- Base login feature (010-customer-login) implemented with working `LoginCubit`, `LoginState`, `LoginPage`, and `LoginForm`
- Backend login endpoint at `POST /api/customer-portal/login` returning error responses per `error-responses.md`

## Files to Modify

| File | Change |
|------|--------|
| `lib/features/auth/presentation/cubit/login_state.dart` | Add `LoginErrorCategory` enum, `isRateLimited`, `rateLimitRemainingSeconds`, `errorCategory` fields |
| `lib/features/auth/presentation/cubit/login_cubit.dart` | Update `_extractErrorMessage()` to return category + message; add 429 cooldown timer logic; override `close()` |
| `lib/features/auth/presentation/pages/login_page.dart` | Change snackbar duration to 4s; make retry button conditional on error category |
| `lib/features/auth/presentation/widgets/login_form.dart` | Disable Sign In button when `isRateLimited == true` |

## Files to Create

| File | Purpose |
|------|---------|
| `test/features/auth/presentation/cubit/login_cubit_test.dart` | Unit tests for error mapping and 429 cooldown |
| `test/features/auth/presentation/pages/login_page_test.dart` | Widget tests for snackbar display and conditional retry |

## Key Implementation Points

1. **Error category enum** — `LoginErrorCategory { credentials, accountLink, rateLimit, server, network }` drives retry visibility and button disable logic.

2. **Status code mapping in `_extractErrorMessage()`** — Split 400/401 handling (currently lumped together); 400 → friendly replacement message; 429 → start cooldown timer; 500 → contract-matching text.

3. **429 cooldown** — `Timer.periodic(Duration(seconds: 1))` counts down from 15. Store timer as Cubit field. Cancel in `close()`. Guard `login()` to prevent calls while `isRateLimited`.

4. **Conditional retry** — Snackbar shows `Retry` `TextButton` only when `errorCategory` is `server` or `network`.

5. **Snackbar duration** — Change from 5 seconds to 4 seconds.

## Testing Strategy

- **Cubit unit tests**: Mock `LoginUseCase` to throw `DioException` with specific status codes. Assert emitted states match expected `errorMessage`, `errorCategory`, `isRateLimited` values. Use `fakeAsync` for 429 countdown tests.
- **Widget tests**: Use `MockCubit` to emit failure states. Assert snackbar presence, retry button visibility, and Sign In button disabled state.

## Quick Verification

After implementation, verify these scenarios manually:

1. Enter wrong credentials → snackbar shows "Invalid credentials or inactive account." with no retry button
2. Log in with unlinked account → snackbar shows "Your account is not fully set up. Please contact support for help."
3. Trigger rate limit (multiple rapid attempts) → snackbar shows rate-limit message, Sign In button disabled for 15 seconds
4. Simulate server error → snackbar shows "An unexpected error occurred..." with retry button
5. Disable network → snackbar shows "No internet connection..." with retry button
6. Snackbar auto-dismisses after 4 seconds in all cases
