# Data Model: Update Forgot Password Endpoint Error Handling

**Feature**: 026-forgot-password-errors  
**Date**: 2026-03-10

## Overview

This feature does not introduce new entities or persistent data. It extends existing state management to differentiate error types returned by the API.

## Modified State: ForgotPasswordState

No schema changes are needed. The existing `ForgotPasswordState` already carries:

| Field | Type | Purpose |
|-------|------|---------|
| `email` | `String` | User-entered email |
| `emailError` | `String?` | Validation error key |
| `isSubmitting` | `bool` | Loading indicator |
| `status` | `ForgotPasswordStatus` | `initial`, `loading`, `success`, `failure` |
| `errorMessage` | `String?` | Error key mapped from API response |

The `errorMessage` field is the discriminator. Currently used values: `'rateLimit'`, `'network'`, `'server'`.

### New Error Key Values

| Error Key | HTTP Status | Meaning |
|-----------|-------------|---------|
| `'notFound'` | 404 | Email not registered |
| `'inactive'` | 403 | Account exists but inactive |

These keys are mapped in the cubit's `_mapDioError` method and resolved to localized strings in both the page-level `_mapErrorMessage` (for toasts) and the form-level `_mapErrorMessage` (for inline errors).

## Localization Keys

| Key | English | Arabic |
|-----|---------|--------|
| `forgotPasswordNotRegistered` | "Email not registered. Please sign up first." | "البريد الإلكتروني غير مسجل. يرجى إنشاء حساب أولاً." |
| `forgotPasswordInactiveAccount` | "Account exists but is inactive — please contact support." | "الحساب موجود لكنه غير مفعل — يرجى التواصل مع الدعم." |
| `forgotPasswordSignUp` | "Don't have an account? Sign Up" | "ليس لديك حساب؟ سجل الآن" |
| `forgotPasswordSignUpAction` | "Sign Up" | "سجل الآن" |
| `forgotPasswordContactSupport` | "Contact Support" | "تواصل مع الدعم" |

## State Transitions

```
[initial] --submit--> [loading] --200--> [success] --> navigate to Change Password
                                 --404--> [failure, errorMessage='notFound'] --> toast + stay
                                 --403--> [failure, errorMessage='inactive'] --> toast + stay
                                 --429--> [failure, errorMessage='rateLimit'] --> toast + stay
                                 --network--> [failure, errorMessage='network'] --> toast + stay
                                 --other--> [failure, errorMessage='server'] --> toast + stay
```

No new states or enum values are introduced. The discrimination happens entirely through `errorMessage` string values.
