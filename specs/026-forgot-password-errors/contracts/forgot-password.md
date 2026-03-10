# API Contract: POST /api/Auth/forgot-password

**Feature**: 026-forgot-password-errors  
**Source**: swagger.json

## Endpoint

```
POST /api/Auth/forgot-password
Content-Type: application/json
```

## Request Body

```json
{
  "email": "string"
}
```

## Response Status Codes

| Status | Condition | Response Body | Client Behavior |
|--------|-----------|---------------|-----------------|
| 200 | OTP sent successfully | — (empty) | Navigate to Change Password page with email |
| 400 | Invalid email format | `ProblemDetails` | Show validation error (existing) |
| 403 | Account exists but inactive | `ProblemDetails` | Toast: "Account exists but is inactive — please contact support." with "Contact Support" action button → Support page. Stay on page. |
| 404 | Email not registered | `ProblemDetails` | Toast: "Email not registered. Please sign up first." Stay on page. |
| 429 | Rate limited (5 req/60s/IP) | `ProblemDetails` | Toast: rate limit message (existing) |

## ProblemDetails Schema

```json
{
  "type": "string",
  "title": "string",
  "status": 0,
  "detail": "string",
  "instance": "string"
}
```

## Error Key Mapping (Client-Side)

| HTTP Status | Error Key | Localization Key |
|-------------|-----------|------------------|
| 404 | `notFound` | `forgotPasswordNotRegistered` |
| 403 | `inactive` | `forgotPasswordInactiveAccount` |
| 429 | `rateLimit` | `errorRateLimit` |
| timeout/connection | `network` | `errorNetwork` |
| other | `server` | `errorServer` |

## Rate Limiting

- 5 requests per 60 seconds per IP
- Returns 429 when exceeded

## Breaking Change Note

Previously the endpoint always returned 200 OK regardless of email existence. Since feature 011, it returns 404 for unregistered emails and 403 for inactive accounts.
