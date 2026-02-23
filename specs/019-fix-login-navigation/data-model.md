# Data Model: Fix Login Navigation to Home Screen

**Feature**: 019-fix-login-navigation  
**Date**: 2026-02-23

## Entities

### LoginEntity (Domain Layer)

Represents an authenticated user session. No changes needed to this entity — it is already correct.

| Field        | Type     | Required | Notes                          |
|-------------|----------|----------|--------------------------------|
| token       | String   | Yes      | JWT authentication token       |
| userId      | int      | Yes      | Backend user identifier        |
| customerId  | int?     | No       | Customer portal ID (nullable)  |
| leadId      | int?     | No       | Lead ID (nullable)             |
| firstName   | String   | Yes      | User's first name              |
| lastName    | String   | Yes      | User's last name               |
| email       | String   | Yes      | User's email address           |

### LoginState (Presentation Layer)

Represents the login form/process state. No changes needed.

| Field                      | Type                | Default            |
|---------------------------|---------------------|--------------------|
| email                     | String              | ''                 |
| password                  | String              | ''                 |
| obscurePassword           | bool                | true               |
| rememberMe                | bool                | false              |
| status                    | LoginStatus         | initial            |
| errorCode                 | LoginErrorCode?     | null               |
| user                      | LoginEntity?        | null               |
| emailError                | String?             | null               |
| passwordError             | String?             | null               |
| hasSubmitted              | bool                | false              |
| errorCategory             | LoginErrorCategory? | null               |
| isRateLimited             | bool                | false              |
| rateLimitRemainingSeconds | int                 | 0                  |

### State Transitions

```
LoginStatus.initial → LoginStatus.loading   (login button pressed, validation passes)
LoginStatus.loading → LoginStatus.success   (API success + session saved)
LoginStatus.loading → LoginStatus.failure   (API error or save failure)
LoginStatus.success → [NAVIGATION TO HOME]  (BlocListener triggers context.go('/home'))
```

## Persisted Session Fields (SharedPreferences)

Current state vs. required state for `getUser()`:

| SharedPreferences Key | Type   | Required for valid session? | Current check | Correct check |
|----------------------|--------|----------------------------|---------------|---------------|
| `auth_token`         | String | Yes                        | `!= null` ✓   | `!= null` ✓   |
| `user_id`            | int    | Yes                        | `!= null` ✓   | `!= null` ✓   |
| `customer_id`        | int    | **No** (nullable in entity)| `!= null` ✗   | **optional** ← FIX |
| `first_name`         | String | Yes                        | `!= null` ✓   | `!= null` ✓   |
| `last_name`          | String | Yes                        | `!= null` ✓   | `!= null` ✓   |
| `user_email`         | String | Yes                        | `!= null` ✓   | `!= null` ✓   |

## Validation Rules

- `token` must be a non-empty string
- `userId` must be a positive integer
- `customerId` may be null (user is a lead, not yet a customer)
- `firstName` and `lastName` must be non-empty strings
- `email` must be a valid email format

## Relationships

```
LoginResponseModel (API) --toEntity()--> LoginEntity (Domain)
LoginEntity (Domain) --saveSession()--> SharedPreferences (Storage)
SharedPreferences (Storage) --getUser()--> LoginEntity (Domain)  ← BUG IS HERE
LoginEntity (Domain) --getStoredSession()--> GoRouter redirect guard
```
