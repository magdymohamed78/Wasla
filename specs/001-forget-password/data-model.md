# Data Model: Forget Password Page

**Feature**: 001-forget-password
**Date**: 2026-02-22

## Overview

UI-only feature with no persistent data storage. Data model consists of form state managed by Cubit.

## Entities

### ForgetPasswordState

In-memory state managed by ForgotPasswordCubit.

| Field | Type | Description |
|-------|------|-------------|
| email | String | Current email input value |
| emailError | String? | Validation error message (null if valid) |
| isValid | bool | Derived: email is non-empty and valid format |
| isSubmitting | bool | True while toast is displayed |
| status | ForgotPasswordStatus | Enum: initial, success |

### ForgotPasswordStatus (Enum)

| Value | Description |
|-------|-------------|
| initial | Default state, ready for input |
| success | Toast shown after valid submission |

## State Transitions

```
┌─────────┐  valid email   ┌──────────┐  click Send  ┌─────────┐
│ initial │ ──────────────>│ isValid  │ ────────────>│ success │
└─────────┘                └──────────┘              └─────────┘
     ▲                          │                        │
     │                          │ clear                  │
     │                          ▼                        │
     │                    ┌──────────┐                   │
     └────────────────────│ !isValid │<──────────────────┘
                          └──────────┘    toast dismiss
```

## Validation Rules

### Email Field

| Rule | Condition | Error Message |
|------|-----------|---------------|
| Required | `value == null \|\| value.trim().isEmpty` | "Email is required" |
| Format | `!_emailRegex.hasMatch(value.trim())` | "Please enter a valid email" |

Regex: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`

## No Persistence

This feature does not persist data:
- No local storage
- No remote API calls
- No shared preferences
- State exists only in memory during page lifecycle
