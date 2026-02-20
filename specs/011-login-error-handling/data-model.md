# Data Model: Login Error Response Handling

**Feature**: `011-login-error-handling` | **Date**: 2026-02-20

---

## Entities

### LoginErrorCategory (Enum)

Categorizes login errors to drive UI behavior (retry visibility, button disable).

| Value | Description | Maps from |
|-------|-------------|-----------|
| `credentials` | Invalid email/password or inactive account | HTTP 401 |
| `accountLink` | Account not linked to lead/customer record | HTTP 400 |
| `rateLimit` | Too many login attempts | HTTP 429 |
| `server` | Unexpected server error | HTTP 500, 502, 503, unknown status codes |
| `network` | Network connectivity failure | `DioExceptionType.connectionError`, `connectionTimeout`, `sendTimeout`, `receiveTimeout`, `SocketException` |

### LoginState (Updated — Existing Entity)

Extends the existing `LoginState` class with error handling fields.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `email` | `String` | `''` | *(existing)* |
| `password` | `String` | `''` | *(existing)* |
| `obscurePassword` | `bool` | `true` | *(existing)* |
| `rememberMe` | `bool` | `false` | *(existing)* |
| `status` | `LoginStatus` | `initial` | *(existing)* |
| `errorMessage` | `String?` | `null` | *(existing)* Error text displayed in snackbar |
| `user` | `LoginEntity?` | `null` | *(existing)* |
| `emailError` | `String?` | `null` | *(existing)* |
| `passwordError` | `String?` | `null` | *(existing)* |
| `hasSubmitted` | `bool` | `false` | *(existing)* |
| **`errorCategory`** | `LoginErrorCategory?` | `null` | **NEW** — categorizes the error for conditional UI |
| **`isRateLimited`** | `bool` | `false` | **NEW** — disables Sign In button during 429 cooldown |
| **`rateLimitRemainingSeconds`** | `int` | `0` | **NEW** — countdown seconds for rate-limit cooldown |

### Error Message Mapping (Constants)

Static mapping from HTTP status codes to user-visible messages.

| Status Code | User-Visible Message | Source |
|------------|---------------------|--------|
| 400 | `"Your account is not fully set up. Please contact support for help."` | Client-side replacement (friendlier than server message) |
| 401 | `"Invalid credentials or inactive account."` | Server `message` field (pass-through) |
| 429 | `"Too many login attempts. Please try again later."` | Server `message` field (matches contract) |
| 500 | `"An unexpected error occurred. Please try again later."` | Server `message` field (matches contract) |
| Network | `"No internet connection. Please check your network and try again."` | Client-side generated |
| Unknown/Default | `"An unexpected error occurred. Please try again later."` | Client-side fallback |

---

## Relationships

```text
LoginState
 ├── has-a → LoginErrorCategory? (categorizes current error)
 ├── has-a → LoginEntity? (authenticated user on success)
 └── used-by → LoginCubit (emits state changes)

LoginCubit
 ├── owns → Timer? (_cooldownTimer for 429 rate-limit)
 ├── depends-on → LoginUseCase (calls login endpoint)
 └── depends-on → AuthRepository (session persistence)

LoginPage
 ├── listens-to → LoginCubit via BlocListener (shows snackbar on failure)
 └── reads → LoginState.errorCategory (conditional retry action)

LoginForm
 └── reads → LoginState.isRateLimited (disables Sign In button)
```

---

## State Transitions

```text
                    ┌─────────────┐
                    │   initial   │
                    └──────┬──────┘
                           │ login()
                    ┌──────▼──────┐
                    │   loading   │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
       ┌──────▼──────┐ ┌──▼───┐ ┌──────▼──────┐
       │   failure    │ │ 429  │ │   success   │
       │ (401/400/    │ │      │ └─────────────┘
       │  500/network)│ └──┬───┘
       └──────┬───────┘    │
              │            │ isRateLimited=true
              │            │ Timer.periodic(1s)
              │      ┌─────▼─────┐
              │      │ cooldown  │──(tick)──► remaining--
              │      │ ticking   │
              │      └─────┬─────┘
              │            │ remaining == 0
              │      ┌─────▼─────┐
              │      │ cooldown  │
              │      │ expired   │
              │      └─────┬─────┘
              │            │ isRateLimited=false
              └────────────┤
                           │
                    ┌──────▼──────┐
                    │   initial   │ (ready for next attempt)
                    └─────────────┘
```

---

## Validation Rules

| Rule | Enforcement |
|------|-------------|
| Email must be non-empty and valid format | Existing FR — `Validators.validateEmail()` |
| Password must be non-empty | Existing FR — `Validators.validatePassword()` |
| Login blocked while `isRateLimited == true` | `LoginForm` disables button; `login()` should also guard |
| Login blocked while `status == loading` | Existing FR — button disabled during loading |
| Error message cleared on field edit | `emailChanged()` / `passwordChanged()` reset status to `initial` |
