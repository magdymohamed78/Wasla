# API Contract: Customer Portal Registration

**Branch**: `020-company-signup` | **Date**: 2026-02-23

## Overview

Single API endpoint for customer portal user registration. Creates a Lead account and returns an authentication session.

## Endpoint

### POST `/api/customer-portal/register` — Register New Account

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Path** | `/api/customer-portal/register` |
| **Content-Type** | `application/json` |
| **Authentication** | None (public endpoint) |
| **Description** | Registers a new portal user account (creates a Lead). Returns JWT with `leadId` claim. |

---

### Request Body — `CustomerRegisterDto`

```json
{
  "email": "string",
  "password": "string",
  "firstName": "string",
  "lastName": "string",
  "phoneNumber": "string | null"
}
```

| Field | Type | Required | Constraints | Description |
|-------|------|----------|-------------|-------------|
| email | string | Yes | max 256, format: email | User's email address |
| password | string | Yes | min 6 | Account password |
| firstName | string | Yes | max 100, min 1 | User's first name |
| lastName | string | Yes | max 100, min 1 | User's last name |
| phoneNumber | string? | No | max 50, nullable | User's phone number |

---

### Response: 201 Created — `CustomerLoginResultDto`

Account created successfully. Returns authentication session.

```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "userId": 42,
  "customerId": null,
  "leadId": 7,
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com"
}
```

| Field | Type | Nullable | Description |
|-------|------|----------|-------------|
| token | string | Yes | JWT authentication token with `leadId` claim |
| userId | int | No | Internal user ID |
| customerId | int? | Yes | Always null for new registrations (Lead, not Customer) |
| leadId | int? | Yes | Lead record ID (set after registration) |
| firstName | string | Yes | User's first name |
| lastName | string | Yes | User's last name |
| email | string | Yes | User's email address |

---

### Response: 400 Bad Request — Validation Error

Invalid input data. Server-side validation failed.

```json
{
  "message": "Password must contain at least 6 characters."
}
```

| Field | Type | Description |
|-------|------|-------------|
| message | string | Human-readable error description |

**Known 400 conditions** (from `error-responses.md`):
- Password policy failure
- Invalid email format
- Missing required fields

**Client behavior**: Parse `message` string. If it contains a field keyword (e.g., "password", "email"), display inline below that field. Otherwise, display as snackbar.

---

### Response: 409 Conflict — Email Already In Use

A user with this email address already exists.

```json
{
  "message": "Email already in use."
}
```

| Field | Type | Description |
|-------|------|-------------|
| message | string | Always "Email already in use." |

**Client behavior**: Display "This email is already registered" inline below the email field. Do not clear form data.

---

### Response: 500 Internal Server Error

Unexpected server error.

```json
{
  "message": "An unexpected error occurred. Please try again later."
}
```

**Client behavior**: Display generic error snackbar with retry option. Do not clear form data.

---

## Dart Model Mapping

### Request → `RegisterRequestModel`

```dart
class RegisterRequestModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;

  const RegisterRequestModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      json['phoneNumber'] = phoneNumber!;
    }
    return json;
  }
}
```

### Response → `LoginResponseModel` (existing, reused)

```dart
// Already exists at lib/features/auth/data/models/login_response_model.dart
// factory LoginResponseModel.fromJson(Map<String, dynamic> json)
// LoginEntity toEntity()
```

---

## Route Contract

### `/register` — Sign Up Page

| Property | Value |
|----------|-------|
| **Path** | `/register` |
| **Page** | `SignUpPage` |
| **Transition** | Default |
| **Back navigation** | System back → returns to login page |
| **Cubit** | `RegisterCubit` provided via `BlocProvider` in route builder |
| **Navigation from** | Login page "Sign Up" link (`context.push('/register')`) |

**Navigation triggers**:
- `BlocListener<RegisterCubit>` on `RegisterStatus.success` → `context.go('/home')`
- `BlocListener<RegisterCubit>` on `RegisterStatus.failure` (server/network category) → show snackbar

**Post-registration**: Session stored locally, user navigated to home screen. User is in Lead state (no company linked).
