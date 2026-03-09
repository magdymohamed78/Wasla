# Contract: Customer Portal Registration API

**Source**: `swagger.json` — `/api/customer-portal/register`
**Date**: March 9, 2026

---

## POST `/api/customer-portal/register`

Registers a new portal user account (creates a Lead). A unique **Digital Signature** is automatically generated for the lead upon registration.

### Request

```
POST /api/customer-portal/register
Content-Type: application/json
```

#### Body — `CustomerRegisterDto`

| Field | Type | Required | Constraints |
|---|---|---|---|
| `email` | string | yes | format: email, maxLength: 256 |
| `password` | string | yes | minLength: 6 |
| `firstName` | string | yes | maxLength: 100 |
| `lastName` | string | yes | maxLength: 100 |
| `phoneNumber` | string | no | maxLength: 50, nullable |

#### Example Request Body

```json
{
  "email": "user@example.com",
  "password": "secret123",
  "firstName": "Ahmed",
  "lastName": "Hassan",
  "phoneNumber": "+201001234567"
}
```

---

### Responses

#### 201 Created — Success

Lead account created. Returns JWT token, refresh token, and user info.

**Schema**: `CustomerLoginResultDto`

| Field | Type | Nullable | Notes |
|---|---|---|---|
| `token` | string | yes | JWT access token |
| `refreshToken` | string | yes | Short-lived (1 day) |
| `refreshTokenExpiry` | string (date-time) | no | ISO 8601 datetime |
| `userId` | integer (int32) | no | |
| `customerId` | integer (int32) | yes | null for new Leads |
| `leadId` | integer (int32) | yes | Set for new Leads |
| `firstName` | string | yes | |
| `lastName` | string | yes | |
| `email` | string | yes | |
| `digitalSignature` | string | **yes** | **Unique opaque string. Required for this feature.** |

#### Example Response Body (201)

```json
{
  "token": "eyJhbGci...",
  "refreshToken": "dGhpcyBpcy...",
  "refreshTokenExpiry": "2026-03-10T12:00:00Z",
  "userId": 42,
  "customerId": null,
  "leadId": 7,
  "firstName": "Ahmed",
  "lastName": "Hassan",
  "email": "user@example.com",
  "digitalSignature": "SIG-a3f9c2d1e8b746..."
}
```

#### 400 Bad Request

Validation errors (invalid email, password too short, etc.).

**Schema**: `ProblemDetails` — standard RFC 7807 problem detail object.

#### 409 Conflict

Email already in use.

**Schema**: `ProblemDetails`

#### 500 Internal Server Error

Unexpected server error. No response body guaranteed.

---

## Client Handling Rules (FR-009 coverage)

| Condition | Client Behaviour |
|---|---|
| `digitalSignature` is present and non-empty | Show digital signature modal |
| `digitalSignature` is null or empty string | Emit `RegisterStatus.failure` with `RegisterErrorCode.missingSignature`; show error snackbar with Retry |
| HTTP 400 | Map to `RegisterErrorCode.validationError` or `badRequest` |
| HTTP 409 | Map to `RegisterErrorCode.emailAlreadyRegistered` |
| HTTP 5xx or network error | Map to `RegisterErrorCode.serverError` or `networkError` |

---

## Widget Interface Contract: `DigitalSignatureModal`

This is the internal contract for the new modal widget.

### Constructor Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `signature` | `String` | yes | The raw digital signature string to display and download |
| `onOkPressed` | `VoidCallback` | yes | Called when OK is tapped (after successful download) |

### Preconditions

- `signature` must not be empty. Caller (SignUpPage) must validate this before showing the modal.
- `onOkPressed` is only invokable when `SignatureModalCubit.state.status == downloaded`.

### Behaviour Contract

| State | Signature text area | Download icon | OK button |
|---|---|---|---|
| `idle` | Plaintext, selectable, scrollable | Active (tap to download) | Disabled |
| `downloading` | Plaintext, selectable, scrollable | Loading indicator | Disabled |
| `downloaded` | Redacted (`*** ... ***`) | Disabled (greyed) | **Enabled** |
| `downloadError` | Plaintext, selectable, scrollable | Active (tap to retry) | Disabled |

### Error Display

When `status == downloadError`, an inline error message is shown below the text area. The error is cleared when the user taps the download icon again.

### Dismissal

The modal is **not dismissible** via back button or tapping outside. The only way to close it is the OK button (after download). This enforces FR-005.
