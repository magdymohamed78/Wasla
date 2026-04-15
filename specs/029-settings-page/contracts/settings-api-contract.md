# Contract: Settings Page API Integration

## Purpose
Define stable client-side integration rules for the Settings page: digital signature reveal, change password, and logout actions.

## Endpoints and Query Contract

### 1) Reveal Digital Signature
- Endpoint: `POST /api/customer-portal/my/digital-signature`
- Auth: Bearer token required
- Request body:
  ```json
  {
    "password": "string"
  }
  ```
- Success response (200):
  ```json
  {
    "digitalSignature": "string"
  }
  ```
- Error responses:
  - 400/401: Wrong password — return error message in response body
  - 403: Rate limited — return error message indicating lock duration (e.g., "Too many failed attempts. Please try again after 15 minutes.")
- Client behavior:
  - On success: close modal, reveal signature inline, start 60-second auto-hide timer
  - On wrong password: show error in modal, keep modal open
  - On 403: set state to `locked`, show server error message, prevent further attempts

### 2) Change Password (Authenticated)
- Endpoint: `POST /api/Auth/change-password`
- Auth: Bearer token required
- Request body:
  ```json
  {
    "currentPassword": "string",
    "newPassword": "string",
    "confirmNewPassword": "string"
  }
  ```
- Success response (200): Empty or success message
- Error responses:
  - 400: Validation error or current password incorrect
  - 401: Unauthorized (token expired)
- Client behavior:
  - On success: close modal, show success SnackBar
  - On error: show error message in modal, keep modal open
- Validation (client-side before submission):
  - All fields required
  - New password: 8+ chars, 1+ uppercase, 1+ digit, 1+ special char (!@#$%^&*)
  - Confirm password must match new password

### 3) Logout Current Session
- Endpoint: `POST /api/customer-portal/logout`
- Auth: Bearer token required
- Request body: None
- Success response (204): No content
- Client behavior:
  - Fire-and-forget: call API, then clear local session and navigate to Login
  - On network failure: still clear local session and navigate to Login (graceful degradation)

### 4) Logout All Devices
- Endpoint: `POST /api/customer-portal/logout-all`
- Auth: Bearer token required
- Request body: None
- Success response (204): No content
- Client behavior:
  - Show confirmation dialog first
  - On confirm: fire-and-forget call, then clear local session and navigate to Login
  - On network failure: still clear local session and navigate to Login (graceful degradation)

## Navigation Contract

### Edit Profile Navigation
- Lead → `AppRouter.leadProfile` (`/my/lead-profile`)
- Customer → `AppRouter.customerProfile` (`/my/profile`)
- Uses `context.go()` (not `push`) to stay within the shell navigation

### Post-Logout Navigation
- All logout actions → `context.go(AppRouter.login)`
- Clears entire navigation stack

## Error Handling Contract

### Signature Errors
- Wrong password: Display server error message in password modal. Keep modal open. Clear password field.
- 403 locked: Display lock message. Set state to `locked`. Disable signature field until user returns to settings (state resets on page rebuild).
- Network error: Display generic network error in modal.

### Change Password Errors
- Validation: Show inline errors per field using existing `Validators` error keys mapped to localized strings.
- Wrong current password: Show server error message as general error in modal.
- Network error: Display generic network error in modal.

### Logout Errors
- API failure: Clear local session anyway. Navigate to Login. Log error silently.
- No confirmation needed for current session logout.
- Confirmation dialog required for logout all devices.

## Localization Contract

New localization keys required:

| Key | English | Arabic |
|-----|---------|--------|
| `settingsEditProfileTitle` | Edit Profile | تعديل الملف الشخصي |
| `settingsEditProfileSubtitle` | Update your personal information | تحديث معلوماتك الشخصية |
| `settingsDigitalSignatureTitle` | Digital Signature | التوقيع الرقمي |
| `settingsDigitalSignatureMasked` | ************* | ************* |
| `settingsSignaturePasswordTitle` | Verify Password | تأكيد كلمة المرور |
| `settingsSignaturePasswordHint` | Enter your password | أدخل كلمة المرور |
| `settingsSignaturePasswordSubmit` | Verify | تأكيد |
| `settingsSignatureCopied` | Copied to clipboard | تم النسخ إلى الحافظة |
| `settingsSignatureLocked` | Too many failed attempts. Please try again after 15 minutes. | محاولات فاشلة كثيرة. يرجى المحاولة مرة أخرى بعد 15 دقيقة. |
| `settingsChangePasswordTitle` | Change Password | تغيير كلمة المرور |
| `settingsCurrentPassword` | Current Password | كلمة المرور الحالية |
| `settingsNewPassword` | New Password | كلمة المرور الجديدة |
| `settingsConfirmNewPassword` | Confirm New Password | تأكيد كلمة المرور الجديدة |
| `settingsChangePasswordSubmit` | Change Password | تغيير كلمة المرور |
| `settingsChangePasswordSuccess` | Password changed successfully | تم تغيير كلمة المرور بنجاح |
| `settingsLogoutCurrent` | Logout | تسجيل الخروج |
| `settingsLogoutAll` | Logout All Devices | تسجيل الخروج من جميع الأجهزة |
| `settingsLogoutAllConfirmTitle` | Logout All Devices? | تسجيل الخروج من جميع الأجهزة؟ |
| `settingsLogoutAllConfirmMessage` | This will sign you out from all devices. | سيتم تسجيل خروجك من جميع الأجهزة. |
| `settingsLanguageTitle` | Language | اللغة |
| `settingsLogoutAllConfirm` | Confirm | تأكيد |
| `settingsLogoutAllCancel` | Cancel | إلغاء |
