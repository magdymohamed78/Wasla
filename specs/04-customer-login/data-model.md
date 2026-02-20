# Data Model: Customer Login

**Feature**: 010-customer-login  
**Date**: 2026-02-19

## Entities

### LoginEntity (Domain Layer)

Represents a successful authentication response. Pure domain object with no framework dependencies.

| Field | Type | Description |
|-------|------|-------------|
| `token` | String | Server-issued JWT or session token |
| `userId` | int | Unique user identifier |
| `customerId` | int | Unique customer identifier |
| `firstName` | String | Customer's first name |
| `lastName` | String | Customer's last name |
| `email` | String | Customer's email address |

**Status**: Existing — `lib/features/auth/domain/entities/login_entity.dart`

---

### LoginState (Presentation Layer — Cubit State)

Represents the complete state of the login screen. Immutable; updated via `copyWith`.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `email` | String | `''` | Current email field value |
| `password` | String | `''` | Current password field value |
| `obscurePassword` | bool | `true` | Whether password is hidden |
| `rememberMe` | bool | `false` | Whether "Remember Me" is checked |
| `status` | LoginStatus | `initial` | Current process status |
| `errorMessage` | String? | `null` | Server error key (for snackbar) |
| `user` | LoginEntity? | `null` | User data on success |
| `emailError` | String? | `null` | **NEW** — Inline validation error key for email field |
| `passwordError` | String? | `null` | **NEW** — Inline validation error key for password field |
| `hasSubmitted` | bool | `false` | **NEW** — Whether user has attempted submit at least once |

**LoginStatus enum**: `initial`, `loading`, `success`, `failure`

**Validation error keys** (mapped to l10n in UI):
- `email_empty` → "Email is required"
- `email_invalid` → "Please enter a valid email address"
- `password_empty` → "Password is required"

**Server error keys** (mapped to l10n in snackbar):
- `invalid_credentials` → "Invalid email or password"
- `no_connection` → "No internet connection. Please check your connection."
- `rate_limited` → "Too many attempts. Please try again later." **(NEW — from clarification)**
- `session_expired` → "Session expired, please sign in again" **(NEW — from clarification)**
- `unexpected` → "Something went wrong. Please try again."

**Status**: Partially existing — `lib/features/auth/presentation/cubit/login_state.dart` (needs 3 new fields)

---

## Data Models (Data Layer)

### LoginRequestModel

Maps customer credentials to API request JSON.

| Field | Type | JSON Key | Description |
|-------|------|----------|-------------|
| `email` | String | `email` | Trimmed email address |
| `password` | String | `password` | Password (never stored) |

**Serialization**: `toJson() → Map<String, dynamic>`  
**Status**: Existing — `lib/features/auth/data/models/login_request_model.dart`

### LoginResponseModel

Maps API success response JSON to domain entity.

| Field | Type | JSON Key | Description |
|-------|------|----------|-------------|
| `token` | String | `token` | Authentication token |
| `userId` | int | `userId` | User ID |
| `customerId` | int | `customerId` | Customer ID |
| `firstName` | String | `firstName` | First name |
| `lastName` | String | `lastName` | Last name |
| `email` | String | `email` | Email address |

**Deserialization**: `fromJson(Map<String, dynamic>) → LoginResponseModel`  
**Conversion**: `toEntity() → LoginEntity`  
**Status**: Existing — `lib/features/auth/data/models/login_response_model.dart`

---

## Data Sources

### AuthRemoteDataSource (Data Layer)

Handles raw API communication for login.

| Method | Input | Output | Endpoint |
|--------|-------|--------|----------|
| `login(LoginRequestModel)` | Request model | `LoginResponseModel` | `POST /api/customer-portal/login` |

**Status**: Existing — `lib/features/auth/data/data_sources/auth_remote_data_source.dart`

### AuthLocalDataSource (Data Layer) — NEW

Handles local token and user data persistence for "Remember Me".

| Method | Input | Output | Description |
|--------|-------|--------|-------------|
| `saveToken(String)` | Token | `Future<void>` | Persist auth token |
| `getToken()` | — | `Future<String?>` | Retrieve stored token |
| `clearToken()` | — | `Future<void>` | Remove stored token |
| `saveUser(LoginEntity)` | Entity | `Future<void>` | Persist user data (name, email, IDs) |
| `getUser()` | — | `Future<LoginEntity?>` | Retrieve stored user data |
| `clearAll()` | — | `Future<void>` | Remove all auth data (logout) |

**Storage**: `SharedPreferences` (injected)  
**Status**: NEW — `lib/features/auth/data/data_sources/auth_local_data_source.dart`

---

## Repositories

### AuthRepository (Domain Layer — Interface)

| Method | Input | Output | Description |
|--------|-------|--------|-------------|
| `login(email, password)` | Strings | `Future<LoginEntity>` | Authenticate credentials |

**Status**: Existing — `lib/features/auth/domain/repositories/auth_repository.dart`  
**Modification needed**: Consider adding `saveSession()`, `getStoredSession()`, `clearSession()` methods — OR keep session management in a separate concern.

### AuthRepositoryImpl (Data Layer — Implementation)

Bridges domain with data sources.

**Current dependencies**: `AuthRemoteDataSource`  
**New dependencies**: `AuthRemoteDataSource` + `AuthLocalDataSource`

**Modification**: On login success, if "Remember Me" is enabled, delegate token/user storage to `AuthLocalDataSource`.

---

## Relationships

```text
┌─────────────────┐     ┌──────────────────┐     ┌──────────────────────┐
│   LoginPage     │────▶│   LoginCubit     │────▶│   LoginUseCase       │
│   (UI)          │     │   (State Mgmt)   │     │   (Business Logic)   │
└─────────────────┘     └──────────────────┘     └──────────────────────┘
                                                          │
                                                          ▼
                                                 ┌──────────────────┐
                                                 │  AuthRepository  │
                                                 │  (Interface)     │
                                                 └──────────────────┘
                                                          │
                                                          ▼
                                                 ┌──────────────────────┐
                                                 │ AuthRepositoryImpl   │
                                                 │ (Data Layer)         │
                                                 └──────────────────────┘
                                                    │             │
                                                    ▼             ▼
                                          ┌─────────────┐ ┌────────────────┐
                                          │ RemoteSource │ │ LocalSource    │
                                          │ (Dio/API)    │ │ (SharedPrefs)  │
                                          └─────────────┘ └────────────────┘
```

## State Transitions

```text
LoginStatus Flow:
  initial ──(tap Sign In)──▶ [validate] ──(invalid)──▶ initial (with emailError/passwordError)
                                         ──(valid)───▶ loading
  loading ──(API 200)─────▶ success ──(navigate)──▶ [/home dashboard]
  loading ──(API 401)─────▶ failure (invalid_credentials)
  loading ──(API 429)─────▶ failure (rate_limited)
  loading ──(timeout/no net)─▶ failure (no_connection)
  loading ──(other error)───▶ failure (unexpected)
  failure ──(show snackbar)─▶ initial

Session Expiry Flow (in-app, not on login screen):
  [any authenticated screen] ──(API 401)──▶ clearAll() ──▶ redirect /login (session_expired message)
```
