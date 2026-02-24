# API Contracts: Login Remember Me & Refresh Token

**Feature**: 023-login-remember-me  
**Date**: 2026-02-24  
**Base URL**: `http://waslacrm.runasp.net/`

---

## 1. Login (Updated)

**Endpoint**: `POST /api/customer-portal/login`

### Request

```json
{
  "email": "string (required)",
  "password": "string (required)",
  "rememberMe": "boolean (optional, defaults to false)"
}
```

### Response — 200 OK

```json
{
  "token": "string",
  "refreshToken": "string | null",
  "refreshTokenExpiry": "datetime (ISO 8601) | null",
  "userId": "int",
  "customerId": "int | null",
  "leadId": "int | null",
  "firstName": "string",
  "lastName": "string",
  "email": "string"
}
```

**Notes**:
- `refreshToken` and `refreshTokenExpiry` are returned when `rememberMe: true`
- When `rememberMe: false` (or omitted), `refreshToken` may be null
- Existing error responses (400, 401, 429, 500) are unchanged

### Error Responses (unchanged)

| Status | Meaning |
|---|---|
| 400 | Bad request / Account not set up |
| 401 | Invalid credentials |
| 429 | Rate limited |
| 500 | Server error |

---

## 2. Refresh Token (New)

**Endpoint**: `POST /api/customer-portal/refresh-token`

### Request

```json
{
  "refreshToken": "string (required)"
}
```

### Response — 200 OK

```json
{
  "token": "string",
  "refreshToken": "string",
  "refreshTokenExpiry": "datetime (ISO 8601)",
  "userId": "int",
  "customerId": "int | null",
  "leadId": "int | null",
  "firstName": "string",
  "lastName": "string",
  "email": "string"
}
```

**Notes**:
- Token rotation: the returned `refreshToken` is a NEW token; the old one is invalidated
- Each refresh token is single-use — using it again triggers replay detection (401)
- All token fields are required (non-null) in the response

### Error Responses

| Status | Meaning | App Behavior |
|---|---|---|
| 200 | Success — new tokens returned | Store new tokens, navigate to /home or retry original request |
| 401 | Refresh token expired / revoked / invalid / replay detected | Clear all tokens + remember me flag → navigate to Login |
| 429 | Rate limited | Treat as auth failure → clear tokens → Login |
| 500 | Server error | Treat as auth failure → clear tokens → Login |
| Network Error | No connectivity / timeout | Do NOT clear tokens → show "No connection — Retry" |

---

## 3. Authorization Header (All Authenticated Requests)

All API calls (except login, register, and refresh-token) must include:

```
Authorization: Bearer <access_token>
```

Injected automatically by the `AuthInterceptor` in `onRequest`.

---

## 4. Secure Storage Keys Contract

| Key | Value Type | Written When | Cleared When |
|---|---|---|---|
| `auth_token` | String | Login (Remember Me ON) or Refresh success | Logout, Auth failure, Legacy migration |
| `refresh_token` | String | Login (Remember Me ON) or Refresh success | Logout, Auth failure, Legacy migration |
| `refresh_token_expiry` | String (ISO 8601) | Login (Remember Me ON) or Refresh success | Logout, Auth failure, Legacy migration |
| `remember_me` | String ("true") | Login (Remember Me ON) | Logout, Auth failure, Legacy migration |
| `user_id` | String (int) | Login (Remember Me ON) or Refresh success | Logout, Auth failure, Legacy migration |
| `customer_id` | String (int) | Login (Remember Me ON) or Refresh success (if present) | Logout, Auth failure, Legacy migration |
| `lead_id` | String (int) | Login (Remember Me ON) or Refresh success (if present) | Logout, Auth failure, Legacy migration |
| `first_name` | String | Login (Remember Me ON) or Refresh success | Logout, Auth failure, Legacy migration |
| `last_name` | String | Login (Remember Me ON) or Refresh success | Logout, Auth failure, Legacy migration |
| `user_email` | String | Login (Remember Me ON) or Refresh success | Logout, Auth failure, Legacy migration |

**Legacy SharedPreferences key** (non-auth, kept):
| Key | Value Type | Purpose |
|---|---|---|
| `secure_storage_migrated` | bool | One-time flag to track legacy data cleanup |
| Locale keys | String | Language preference (managed by `LocaleRepositoryImpl`) |
