# Data Model: Login Remember Me & Refresh Token

**Feature**: 023-login-remember-me  
**Date**: 2026-02-24

---

## Entities

### LoginRequestModel (updated)

| Field | Type | Required | Notes |
|---|---|---|---|
| email | String | Yes | User email address |
| password | String | Yes | User password |
| rememberMe | bool | Yes | Checkbox state; determines session persistence |

**File**: `lib/features/auth/data/models/login_request_model.dart`  
**Change**: Add `rememberMe` field (currently only has `email`, `password`)

---

### LoginResponseModel (updated)

| Field | Type | Required | Notes |
|---|---|---|---|
| token | String | Yes | Short-lived JWT access token |
| refreshToken | String? | No | Long-lived refresh token (30-day validity); only returned when `rememberMe: true` |
| refreshTokenExpiry | String? | No | ISO 8601 datetime string for refresh token expiration |
| userId | int | Yes | User ID |
| customerId | int? | No | Customer ID (nullable) |
| leadId | int? | No | Lead ID (nullable) |
| firstName | String | Yes | User first name |
| lastName | String | Yes | User last name |
| email | String | Yes | User email |

**File**: `lib/features/auth/data/models/login_response_model.dart`  
**Change**: Add `refreshToken` (String?) and `refreshTokenExpiry` (String?) fields; update `fromJson()` and `toEntity()`

---

### LoginEntity (updated)

| Field | Type | Required | Notes |
|---|---|---|---|
| token | String | Yes | Access token |
| refreshToken | String? | No | Refresh token |
| refreshTokenExpiry | String? | No | Refresh token expiry (ISO 8601 string) |
| userId | int | Yes | User ID |
| customerId | int? | No | Customer ID |
| leadId | int? | No | Lead ID |
| firstName | String | Yes | First name |
| lastName | String | Yes | Last name |
| email | String | Yes | Email |

**File**: `lib/features/auth/domain/entities/login_entity.dart`  
**Change**: Add `refreshToken` (String?) and `refreshTokenExpiry` (String?)

---

### RefreshTokenRequestModel (new)

| Field | Type | Required | Notes |
|---|---|---|---|
| refreshToken | String | Yes | The stored refresh token to exchange for new tokens |

**File**: `lib/features/auth/data/models/refresh_token_request_model.dart`  
**Methods**: `toJson()` → `{ "refreshToken": "..." }`

---

### RefreshTokenResponseModel (new)

| Field | Type | Required | Notes |
|---|---|---|---|
| token | String | Yes | New access token |
| refreshToken | String | Yes | New rotated refresh token |
| refreshTokenExpiry | String | Yes | New expiry for the rotated refresh token |
| userId | int | Yes | User ID |
| customerId | int? | No | Customer ID |
| leadId | int? | No | Lead ID |
| firstName | String | Yes | First name |
| lastName | String | Yes | Last name |
| email | String | Yes | Email |

**File**: `lib/features/auth/data/models/refresh_token_response_model.dart`  
**Notes**: Same structure as `LoginResponseModel` but all token fields are required (not nullable). Uses same `fromJson()` pattern. Converts to `LoginEntity` via `toEntity()`.

---

### Persisted Auth State (secure storage keys)

| Key | Type (stored as String) | Condition | Notes |
|---|---|---|---|
| `auth_token` | String | Always (when Remember Me ON) | Access token |
| `refresh_token` | String | Only when Remember Me ON | Refresh token |
| `refresh_token_expiry` | String | Only when Remember Me ON | ISO 8601 datetime |
| `remember_me` | String ("true"/"false") | Only when Remember Me ON | Flag to trigger auto-login on app reopen |
| `user_id` | String (int serialized) | Always (when Remember Me ON) | User ID |
| `customer_id` | String (int serialized) | Optional | Customer ID |
| `lead_id` | String (int serialized) | Optional | Lead ID |
| `first_name` | String | Always (when Remember Me ON) | User first name |
| `last_name` | String | Always (when Remember Me ON) | User last name |
| `user_email` | String | Always (when Remember Me ON) | User email |

**Storage**: `FlutterSecureStorage` (encrypted, platform Keystore/Keychain)  
**When Remember Me OFF**: None of these are written to disk. Tokens live in `InMemoryAuthLocalDataSource` (a `Map<String, dynamic>` in memory).

---

### SplashState (updated)

| Field | Type | Default | Notes |
|---|---|---|---|
| phase | SplashAnimationPhase | initial | Enum: initial, animating, completed |
| authStatus | SplashAuthStatus | pending | Enum: pending, authenticated, unauthenticated, networkError |
| readyToNavigate | bool | false | True when BOTH animation and auth check are complete |

**Computed property**: `destination` → `/home` if authenticated, `/onboarding` otherwise

**File**: `lib/features/splash/presentation/cubit/splash_state.dart`

---

## State Transitions

### Splash Auth Flow

```
App Launch
  │
  ├─ Animation starts (phase: animating)
  │   └─ Auth check starts in parallel (authStatus: pending)
  │
  ├─ [Remember Me flag NOT found]
  │   └─ authStatus → unauthenticated
  │       └─ When animation also done → navigate to /onboarding
  │
  ├─ [Remember Me flag found + refresh token exists]
  │   ├─ Call POST /refresh-token
  │   ├─ [Success] → store new tokens → authStatus → authenticated
  │   │   └─ When animation also done → navigate to /home
  │   ├─ [401 / auth error] → clear all tokens → authStatus → unauthenticated
  │   │   └─ When animation also done → navigate to /onboarding
  │   └─ [Network error] → authStatus → networkError
  │       └─ Show "No connection — Retry" overlay (animation continues)
  │           └─ Retry → reset authStatus to pending → re-run auth check
  │
  └─ [Remember Me flag found + NO refresh token]
      └─ Clear flag → authStatus → unauthenticated
          └─ When animation also done → navigate to /onboarding
```

### Login Session Flow

```
Login Page
  │
  ├─ User enters credentials + sets Remember Me checkbox
  │
  ├─ Submit → POST /login with { email, password, rememberMe }
  │
  ├─ [Success]
  │   ├─ [rememberMe: true]
  │   │   ├─ Store access token, refresh token, expiry, remember me flag in SecureStorage
  │   │   ├─ Store user info in SecureStorage
  │   │   └─ Navigate to /home
  │   └─ [rememberMe: false]
  │       ├─ Hold access token in memory only (InMemoryAuthLocalDataSource)
  │       ├─ Do NOT persist refresh token or remember me flag
  │       └─ Navigate to /home
  │
  └─ [Failure] → show error (existing behavior)
```

### Mid-Session Token Refresh (Interceptor)

```
Any API Call
  │
  ├─ onRequest: inject Authorization: Bearer <token> header
  │
  ├─ [200] → pass through
  │
  └─ [401]
      ├─ Is this a refresh call? → reject (don't re-intercept)
      ├─ Get stored refresh token
      │   ├─ [No refresh token] → force logout → navigate to /login
      │   └─ [Has refresh token] → call /refresh-token via separate Dio
      │       ├─ [Success] → store new tokens → retry original request → resolve
      │       ├─ [401] → clear all tokens → force logout → navigate to /login
      │       └─ [Network error] → reject with network error → do NOT clear tokens
      └─ (QueuedInterceptorsWrapper: all concurrent 401s queue behind the first)
```

---

## Relationships

```
LoginRequestModel ──POST──→ /login ──→ LoginResponseModel ──→ LoginEntity
                                                                   │
                                                    ┌──────────────┴──────────────┐
                                                    │                             │
                                              [rememberMe: true]          [rememberMe: false]
                                                    │                             │
                                        SecureAuthLocalDataSource    InMemoryAuthLocalDataSource
                                          (FlutterSecureStorage)          (Map in memory)
                                                    │
                                              On next app launch
                                                    │
                                        SplashCubit reads flag + token
                                                    │
                                    RefreshTokenRequestModel ──POST──→ /refresh-token
                                                    │
                                    RefreshTokenResponseModel ──→ LoginEntity
                                                    │
                                        Store new tokens → navigate /home
```
