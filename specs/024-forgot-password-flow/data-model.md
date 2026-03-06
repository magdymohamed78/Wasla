# Data Model: Forgot Password Flow

**Feature**: 024-forgot-password-flow  
**Date**: 2026-03-05

## Entities

This feature does not introduce new domain entities. The flow operates on transient data (email, OTP, passwords) that does not need to be persisted client-side or modeled as domain objects. The three screens pass simple string values via route parameters.

## Request Models (Data Layer)

### ForgotPasswordRequestModel

| Field   | Type     | Required | Validation          | Description                          |
|---------|----------|----------|---------------------|--------------------------------------|
| `email` | `String` | Yes      | Non-empty, email format | User's registered email address     |

**JSON mapping**: `{ "email": "<value>" }`  
**Used by**: `POST /api/Auth/forgot-password`

---

### ResendOtpRequestModel

| Field   | Type     | Required | Validation          | Description                          |
|---------|----------|----------|---------------------|--------------------------------------|
| `email` | `String` | Yes      | Non-empty, email format | Email from the forgot password flow |

**JSON mapping**: `{ "email": "<value>" }`  
**Used by**: `POST /api/Auth/resend-otp`

---

### ResetPasswordRequestModel

| Field                | Type     | Required | Validation                | Description                                |
|----------------------|----------|----------|---------------------------|--------------------------------------------|
| `email`              | `String` | Yes      | Non-empty, email format   | Email from the forgot password flow       |
| `otp`                | `String` | Yes      | Exactly 6 characters      | OTP entered by user on Screen B           |
| `newPassword`        | `String` | Yes      | minLength: 6              | User's desired new password               |
| `confirmNewPassword` | `String` | Yes      | Must match `newPassword`  | Password confirmation                     |

**JSON mapping**: `{ "email": "<value>", "otp": "<value>", "newPassword": "<value>", "confirmNewPassword": "<value>" }`  
**Used by**: `POST /api/Auth/reset-password`

## State Models (Presentation Layer)

### ForgotPasswordState (MODIFIED)

Existing state — adding `loading` and `failure` statuses, and an error message field.

| Field          | Type                     | Default     | Description                              |
|----------------|--------------------------|-------------|------------------------------------------|
| `email`        | `String`                 | `''`        | Current email input value               |
| `emailError`   | `String?`                | `null`      | Inline validation error for email       |
| `isSubmitting`  | `bool`                  | `false`     | Whether API call is in progress         |
| `status`       | `ForgotPasswordStatus`   | `initial`   | `initial / loading / success / failure` |
| `errorMessage` | `String?`                | `null`      | Server error message                    |

**Status enum update**: `{ initial, loading, success, failure }`

---

### OtpVerificationState (NEW)

| Field                    | Type                       | Default     | Description                              |
|--------------------------|----------------------------|-------------|------------------------------------------|
| `email`                  | `String`                   | `''`        | Email carried from Screen A             |
| `otp`                    | `String`                   | `''`        | Current OTP value (6 digits concat)     |
| `otpDigits`              | `List<String>`             | `['','','','','','']` | Individual OTP digit values  |
| `status`                 | `OtpVerificationStatus`    | `initial`   | `initial / loading / success / failure` |
| `timerRemainingSeconds`  | `int`                      | `60`        | Countdown seconds remaining             |
| `canResend`              | `bool` (derived)           | `false`     | `timerRemainingSeconds == 0`            |
| `isResending`            | `bool`                     | `false`     | Whether resend API call is in progress  |
| `errorMessage`           | `String?`                  | `null`      | Error message for display               |
| `isComplete`             | `bool` (derived)           | `false`     | All 6 digits filled                     |

**Status enum**: `OtpVerificationStatus { initial, success, failure }`

---

### ChangePasswordState (NEW)

| Field                | Type                     | Default     | Description                              |
|----------------------|--------------------------|-------------|------------------------------------------|
| `email`              | `String`                 | `''`        | Email carried from Screen A             |
| `otp`                | `String`                 | `''`        | OTP carried from Screen B               |
| `newPassword`        | `String`                 | `''`        | Current new password input              |
| `confirmPassword`    | `String`                 | `''`        | Current confirm password input          |
| `obscureNewPassword` | `bool`                   | `true`      | Toggle visibility for new password      |
| `obscureConfirmPassword` | `bool`               | `true`      | Toggle visibility for confirm password  |
| `newPasswordError`   | `String?`                | `null`      | Inline validation error                 |
| `confirmPasswordError` | `String?`              | `null`      | Inline validation error                 |
| `status`             | `ChangePasswordStatus`   | `initial`   | `initial / loading / success / failure` |
| `errorMessage`       | `String?`                | `null`      | Server error message                    |
| `errorType`          | `ChangePasswordErrorType?` | `null`    | `otpExpired / passwordPolicy / rateLimit / network / server` |
| `hasSubmitted`       | `bool`                   | `false`     | Whether form has been submitted once    |

**Status enum**: `ChangePasswordStatus { initial, loading, success, failure }`  
**Error type enum**: `ChangePasswordErrorType { otpExpired, passwordPolicy, rateLimit, network, server }`

## State Transitions

### Screen A — Forgot Password Flow

```
initial ──[user types email]──→ initial (email updated, validation runs)
initial ──[press Send]──→ loading (API call starts)
loading ──[200 OK]──→ success (navigate to Screen B)
loading ──[429]──→ failure (show rate limit error)
loading ──[network error]──→ failure (show network error)
failure ──[user retries]──→ loading
```

### Screen B — OTP Verification Flow

```
initial ──[timer starts: 60s]──→ initial (timerRemainingSeconds counting down)
initial ──[user enters digits]──→ initial (otpDigits updated)
initial ──[all 6 digits + press Verify]──→ success (navigate to Screen C with email + OTP)
initial ──[timer reaches 0]──→ initial (canResend = true)
initial ──[press Resend OTP]──→ initial (isResending = true, API call)
initial ──[resend 200 OK]──→ initial (timer restarts 60s, isResending = false)
initial ──[resend 429]──→ failure (show error, timer restarts 60s)
```

### Screen C — Change Password Flow

```
initial ──[user types passwords]──→ initial (validation runs)
initial ──[press Confirm]──→ loading (API call starts)
loading ──[200 OK]──→ success (show toast, navigate to Login)
loading ──[400 expired OTP]──→ failure (errorType: otpExpired, auto-navigate to Screen A)
loading ──[400 password policy]──→ failure (errorType: passwordPolicy, show inline error)
loading ──[429]──→ failure (errorType: rateLimit, show error)
loading ──[network error]──→ failure (errorType: network, show error)
failure ──[user corrects input]──→ initial
```

## Relationships

```
Screen A (ForgotPasswordPage)
    │
    │ passes: email
    ▼
Screen B (OtpVerificationPage)
    │
    │ passes: email + otp
    ▼
Screen C (ChangePasswordPage)
    │
    │ on success: navigate to Login (clear stack)
    │ on expired OTP: navigate back to Screen A (clear stack)
    ▼
Login Page
```
