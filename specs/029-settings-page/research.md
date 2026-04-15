# Research: Settings Page (Lead & Customer)

## Decision 1: Reuse existing `LocaleCubit` for language switching
- Decision: Delegate language switching entirely to the existing `LocaleCubit` and `LocaleRepository` infrastructure. No new cubit needed.
- Rationale: The app already has a fully functional language switching system with persistence via `SharedPreferences`. The `LanguageDropdown` widget in `core/widgets/` can be adapted or the pattern reused as a radio-style section in Settings.
- Alternatives considered:
  - Create a new `LanguageCubit` for Settings: rejected due to duplication of existing infrastructure.
  - Store language in a new storage mechanism: rejected because `LocaleRepositoryImpl` already handles persistence correctly.

## Decision 2: Signature reveal via dedicated cubit with timer management
- Decision: Create a `DigitalSignatureCubit` that manages three states (hidden, revealed, locked) and owns the 60-second auto-hide `Timer`. The cubit cancels the timer on `close()` and exposes a `hideSignature()` method.
- Rationale: Timer lifecycle must be tied to the cubit (not the widget) to ensure proper cancellation on dispose, navigation away, or logout. Using `WidgetsBindingObserver` for app lifecycle is unnecessary since SH-002 already specifies clearing on widget tree exit.
- Alternatives considered:
  - Timer in widget `State`: rejected because lifecycle management across navigation/logout is fragile.
  - Timer in a global service: rejected because the signature state is page-scoped, not app-scoped.

## Decision 3: Change password as a standalone use case, not extending existing OTP flow
- Decision: Create a new `ChangePasswordUseCase` in the auth feature domain layer that calls `POST /api/Auth/change-password` with current password, new password, and confirm password. Do not modify the existing `ResetPasswordUseCase` (OTP-based).
- Rationale: The existing change-password flow is part of the forgot-password OTP verification and has different semantics (email + OTP vs current password). Mixing them would violate single responsibility and create confusing state management.
- Alternatives considered:
  - Extend existing `ChangePasswordCubit`: rejected because it is tightly coupled to OTP verification flow and error types.

## Decision 4: Logout API calls added to `CustomerPortalRemoteDataSource`
- Decision: Add `logout()` and `logoutAll()` methods to the existing `CustomerPortalRemoteDataSource`, with corresponding repository methods and use cases. Extend `SessionCubit.logout()` to call the API before clearing local state.
- Rationale: The logout endpoints (`/api/customer-portal/logout` and `/api/customer-portal/logout-all`) are customer-portal endpoints. The existing data source and repository are the natural home. Fire-and-forget pattern: call API, then clear local session regardless of API response (graceful degradation).
- Alternatives considered:
  - New dedicated `AuthRemoteDataSource` methods: rejected because `/api/customer-portal/logout` is a portal endpoint, not an auth endpoint.
  - Call API only (no local clear on failure): rejected because user expectation is to be logged out regardless of network state.

## Decision 5: Single unified `SettingsCubit` orchestrates page-level state
- Decision: Use one `SettingsCubit` for the main settings page that reads user identity from `SessionCubit` and determines role-based section visibility. Feature-specific cubits (signature, change password, logout) are provided as nested `BlocProvider` widgets at the section/modal level.
- Rationale: The settings page itself is primarily read-only (displaying identity and section cards). Only individual actions require state management. Following the spec's "Cubit per feature" guidance, each action gets its own cubit, but the page scaffold doesn't need complex orchestration.
- Alternatives considered:
  - One monolithic cubit for all settings state: rejected because it mixes concerns (signature timer + password validation + logout).
  - No page-level cubit at all: rejected because role-based visibility needs a reactive source.

## Decision 6: Signature field uses `AnimatedCrossFade` for smooth reveal/hide transition
- Decision: Use Flutter's built-in `AnimatedCrossFade` to animate between masked asterisk text and revealed signature text, satisfying FR-028 (smooth visual transition).
- Rationale: Built-in widget, no new dependencies, provides cross-fade effect that is smooth and standard. Animation duration of ~300ms is appropriate.
- Alternatives considered:
  - `AnimatedSwitcher`: viable but `AnimatedCrossFade` provides more explicit layout transition control.
  - Third-party animation package: rejected to avoid new dependencies for a simple effect.

## Decision 7: Copy-to-clipboard feedback via `SnackBar`
- Decision: Use a brief `SnackBar` with localized "Copied to clipboard" message as the copy feedback (FR-009).
- Rationale: Consistent with the existing `DigitalSignatureModal` which already uses clipboard + snackbar pattern. No new widget needed.
- Alternatives considered:
  - Custom toast overlay: rejected because SnackBar is the standard Material pattern already used.

## Decision 8: Logout confirmation dialog uses `AlertDialog` with brand styling
- Decision: Logout All Devices confirmation uses a standard `AlertDialog` with AppColors/AppTypography styling, matching the existing dialog patterns in the app (language selector, restriction prompts).
- Rationale: Consistency with existing dialog UX. The `OnboardingHeader` language dialog and other AlertDialogs in the app set the pattern.
- Alternatives considered:
  - Bottom sheet confirmation: rejected because it deviates from the app's existing confirmation pattern.

## Decision 9: Signature API 403 error handling — parse server error message
- Decision: When the signature API returns 403, extract the error message from the response body. Display it as-is if available; otherwise fall back to the hardcoded "Too many failed attempts. Please try again after 15 minutes." message. Set cubit to `locked` state.
- Rationale: The spec says to display the specific message, but the actual lock duration is server-determined. Parsing the server message provides the most accurate feedback while the hardcoded fallback ensures the user always sees something meaningful.
- Alternatives considered:
  - Always show hardcoded message: rejected because it may not reflect actual lock duration from server.
  - Parse lock duration and implement client-side countdown: rejected as over-engineering for this feature scope.
