# Login Error Response Contracts

**Feature**: `011-login-error-handling` | **Date**: 2026-02-20
**Source Endpoint**: `POST /api/customer-portal/login`

---

## Server Error Response Format

All error responses from the login endpoint follow this shape:

```json
{
  "message": "Human-readable error description"
}
```

## Status Code → Client Behavior Mapping

### HTTP 401 — Invalid Credentials

**Server Response:**
```json
{
  "message": "Invalid credentials or inactive account."
}
```

**Client Behavior:**
- Display snackbar with message: `"Invalid credentials or inactive account."`
- Error category: `credentials`
- Retry button: **Not shown** (user must correct credentials)
- Sign In button: **Enabled** (user can re-attempt)
- Snackbar duration: **4 seconds**

---

### HTTP 400 — Unlinked Account

**Server Response:**
```json
{
  "message": "User is not linked to a lead or customer record."
}
```

**Client Behavior:**
- Display snackbar with **replaced** message: `"Your account is not fully set up. Please contact support for help."`
- Error category: `accountLink`
- Retry button: **Not shown** (retrying won't help; user needs backend fix)
- Sign In button: **Enabled**
- Snackbar duration: **4 seconds**

---

### HTTP 429 — Rate Limited

**Server Response:**
```json
{
  "message": "Too many login attempts. Please try again later."
}
```

**Client Behavior:**
- Display snackbar with message: `"Too many login attempts. Please try again later."`
- Error category: `rateLimit`
- Retry button: **Not shown**
- Sign In button: **Disabled for 15 seconds** (cooldown timer)
- Snackbar duration: **4 seconds**
- After 15-second cooldown: Sign In button re-enabled, error cleared

---

### HTTP 500 — Server Error

**Server Response:**
```json
{
  "message": "An unexpected error occurred. Please try again later."
}
```

**Client Behavior:**
- Display snackbar with message: `"An unexpected error occurred. Please try again later."`
- Error category: `server`
- Retry button: **Shown** (dismisses snackbar, re-submits login)
- Sign In button: **Enabled**
- Snackbar duration: **4 seconds**

---

### Network Error — No Response

**No server response (DioExceptionType: connectionError, connectionTimeout, sendTimeout, receiveTimeout, SocketException)**

**Client Behavior:**
- Display snackbar with message: `"No internet connection. Please check your network and try again."`
- Error category: `network`
- Retry button: **Shown**
- Sign In button: **Enabled**
- Snackbar duration: **4 seconds**

---

### Unknown Status Code / Malformed Response

**Any undocumented status code (e.g., 403, 502, 503) or empty/malformed response body**

**Client Behavior:**
- Display snackbar with message: `"An unexpected error occurred. Please try again later."`
- Error category: `server`
- Retry button: **Shown**
- Sign In button: **Enabled**
- Snackbar duration: **4 seconds**

---

## Contract Summary Table

| Status | Message (displayed to user) | Category | Retry | Button Disabled | Duration |
|--------|----------------------------|----------|-------|-----------------|----------|
| 400 | Your account is not fully set up. Please contact support for help. | `accountLink` | No | No | 4s |
| 401 | Invalid credentials or inactive account. | `credentials` | No | No | 4s |
| 429 | Too many login attempts. Please try again later. | `rateLimit` | No | Yes (15s) | 4s |
| 500 | An unexpected error occurred. Please try again later. | `server` | Yes | No | 4s |
| Network | No internet connection. Please check your network and try again. | `network` | Yes | No | 4s |
| Unknown | An unexpected error occurred. Please try again later. | `server` | Yes | No | 4s |
