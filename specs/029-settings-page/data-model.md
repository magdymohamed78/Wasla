# Data Model: Settings Page (Lead & Customer)

## Entity: SettingsUserIdentity
- Purpose: Lightweight identity model for the avatar card at the top of Settings.
- Fields:
  - `firstName: String?`
  - `lastName: String?`
  - `fullName: String` (computed: `"$firstName $lastName"` trimmed)
  - `initials: String` (computed: first letter of firstName + first letter of lastName, uppercase; fallback to first letter of firstName only)
  - `role: SessionRole` (`lead`, `customer`)
- Source: Derived from `SessionCubit.state.user` and `SessionCubit.state.role`. No separate API call.

## Entity: SignatureRevealState
- Purpose: Tracks the lifecycle of the digital signature reveal flow.
- Enum: `SignatureStatus` with values:
  - `hidden` — default; asterisks displayed
  - `revealed` — actual signature visible, auto-hide timer running
  - `locked` — 403 received; attempts blocked
- Fields:
  - `status: SignatureStatus`
  - `signatureText: String?` — only non-null during `revealed` state
  - `errorMessage: String?` — set on wrong password or 403
  - `isLoading: bool`
- State transitions:
  - `hidden` → `isLoading=true` → `revealed` (success) or `hidden` (wrong password) or `locked` (403)
  - `revealed` → `hidden` (timer expires, navigation away, or logout)
  - `locked` → `hidden` (user retries after lock period indicated by server)

## Entity: ChangePasswordFormState
- Purpose: Holds form field values and validation state for the Change Password modal.
- Fields:
  - `currentPassword: String`
  - `newPassword: String`
  - `confirmPassword: String`
  - `currentPasswordError: String?`
  - `newPasswordError: String?`
  - `confirmPasswordError: String?`
  - `isSubmitting: bool`
  - `generalError: String?`
  - `isSuccess: bool`
- Validation rules (applied before submission):
  - `currentPassword`: non-empty
  - `newPassword`: `Validators.validatePasswordLength` (8+ chars, uppercase, digit, special char)
  - `confirmPassword`: `Validators.validatePasswordMatch(newPassword, confirmPassword)`
- State transitions:
  - `idle` → field edits update corresponding values and clear that field's error
  - `idle` → `isSubmitting=true` → `isSuccess=true` (close modal) or `generalError` (show error, stay open)

## Entity: LogoutActionState
- Purpose: Tracks loading/error for each logout action independently.
- Fields:
  - `isLoggingOutCurrent: bool`
  - `isLoggingOutAll: bool`
  - `errorMessage: String?`
- State transitions:
  - `idle` → `isLoggingOutCurrent=true` → success (navigate to login) or `errorMessage`
  - `idle` → `isLoggingOutAll=true` → success (navigate to login) or `errorMessage`

## Relationships
- `SettingsUserIdentity` is derived from `SessionCubit.state` — reactive, no independent storage.
- `SignatureRevealState` is owned by `DigitalSignatureCubit`, scoped to the Settings page lifecycle.
- `ChangePasswordFormState` is owned by `ChangePasswordCubit`, scoped to the modal lifecycle.
- `LogoutActionState` is owned by `LogoutCubit`, scoped to the Settings page lifecycle.
- Language selection delegates entirely to existing `LocaleCubit` — no new entity needed.

## Validation and Mapping Rules
- Avatar initials: `firstName?[0].toUpperCase()` + `lastName?[0].toUpperCase()`, fallback handling for nulls.
- Signature: revealed text cleared from memory when reverting to hidden (set to null).
- Password fields: reuse `Validators` utility class for all validation rules.
- 403 error parsing: extract message from DioException response body; fallback to localized default.
