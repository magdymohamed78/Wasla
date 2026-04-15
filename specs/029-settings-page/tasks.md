# Tasks: Settings Page (Lead & Customer)

**Feature**: `029-settings-page` | **Spec**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)

## Implementation Strategy

Deliver incrementally by user story priority. Each phase produces a independently testable increment:
- **MVP** = US1 (Identity Card) + US2 (Edit Profile) — users can see their identity and navigate to profile editing
- **Full** = US1–US6 — complete settings experience with signature, security, and language

---

## Phase 1: Setup

- [x] T001 Add all new localization keys to `lib/core/localization/l10n/app_en.arb` (settingsEditProfileTitle, settingsEditProfileSubtitle, settingsDigitalSignatureTitle, settingsDigitalSignatureMasked, settingsSignaturePasswordTitle, settingsSignaturePasswordHint, settingsSignaturePasswordSubmit, settingsSignatureCopied, settingsSignatureLocked, settingsChangePasswordTitle, settingsCurrentPassword, settingsNewPassword, settingsConfirmNewPassword, settingsChangePasswordSubmit, settingsChangePasswordSuccess, settingsLogoutCurrent, settingsLogoutAll, settingsLogoutAllConfirmTitle, settingsLogoutAllConfirmMessage, settingsLogoutAllConfirm, settingsLogoutAllCancel, settingsLanguageTitle, settingsSecuritySectionTitle)
- [x] T002 Add all corresponding Arabic translations to `lib/core/localization/l10n/app_ar.arb`
- [x] T003 Run `flutter gen-l10n` and verify all new getters exist in generated `AppLocalizations`

---

## Phase 2: Foundational — Data Layer & Cubits

Goal: Complete all data/domain layer extensions and cubit implementations so user story phases only need to build widgets.

- [x] T004 [P] Add `SignatureRevealResponseDto` to `lib/features/home/data/models/customer_portal_models.dart` with `fromJson` factory parsing `digitalSignature` field
- [x] T005 [P] Add `revealDigitalSignature({required String password})`, `logout()`, and `logoutAll()` methods to `CustomerPortalRemoteDataSource` abstract class in `lib/features/home/data/data_sources/customer_portal_remote_data_source.dart`
- [x] T006 Implement the three new methods in `CustomerPortalRemoteDataSourceImpl` in `lib/features/home/data/data_sources/customer_portal_remote_data_source.dart` — `revealDigitalSignature` POSTs to `/api/customer-portal/my/digital-signature`, `logout` POSTs to `/api/customer-portal/logout`, `logoutAll` POSTs to `/api/customer-portal/logout-all`
- [x] T007 [P] Add `changePassword({required String currentPassword, required String newPassword, required String confirmNewPassword})` method to `AuthRemoteDataSource` abstract class and implementation in `lib/features/auth/data/data_sources/auth_remote_data_source.dart` — POSTs to `/api/Auth/change-password`
- [x] T008 Add `revealDigitalSignature`, `logout`, `logoutAll` to `CustomerPortalRepository` abstract class in `lib/features/home/domain/repositories/customer_portal_repository.dart`
- [x] T009 Implement the three new repository methods in `CustomerPortalRepositoryImpl` in `lib/features/home/data/repositories/customer_portal_repository_impl.dart` — delegate to remote data source, map DTOs to domain
- [x] T010 [P] Add `changePassword` to `AuthRepository` abstract class in `lib/features/auth/domain/repositories/auth_repository.dart`
- [x] T011 [P] Implement `changePassword` in `AuthRepositoryImpl` in `lib/features/auth/data/repositories/auth_repository_impl.dart`
- [x] T012 [P] Create `RevealDigitalSignatureUseCase` in `lib/features/home/domain/use_cases/reveal_signature_use_case.dart`
- [x] T013 [P] Create `LogoutUseCase` in `lib/features/home/domain/use_cases/logout_use_case.dart`
- [x] T014 [P] Create `LogoutAllUseCase` in `lib/features/home/domain/use_cases/logout_all_use_case.dart`
- [x] T015 [P] Create `ChangePasswordUseCase` in `lib/features/auth/domain/use_cases/change_password_use_case.dart`
- [x] T016 Create `SettingsState` in `lib/features/home/presentation/cubit/settings_state.dart` — holds `SettingsUserIdentity` with firstName, lastName, fullName, initials, role
- [x] T017 Create `SettingsCubit` in `lib/features/home/presentation/cubit/settings_cubit.dart` — reads from `SessionCubit`, computes initials/fullName, reacts to session changes
- [x] T018 [P] Create `DigitalSignatureState` in `lib/features/home/presentation/cubit/digital_signature_state.dart` — enum `SignatureStatus` {hidden, revealed, locked} plus signatureText, errorMessage, isLoading fields with copyWith
- [x] T019 [P] Create `DigitalSignatureCubit` in `lib/features/home/presentation/cubit/digital_signature_cubit.dart` — manages reveal/hide/locked states, owns 60-second Timer for auto-hide, cancels timer on close, calls `RevealDigitalSignatureUseCase`
- [x] T020 [P] Create `ChangePasswordState` in `lib/features/auth/presentation/cubit/settings_change_password_state.dart` (settings-specific, separate from existing OTP cubit) — holds currentPassword, newPassword, confirmPassword, field errors, isSubmitting, generalError, isSuccess
- [x] T021 [P] Create `SettingsChangePasswordCubit` in `lib/features/auth/presentation/cubit/settings_change_password_cubit.dart` (settings-specific) — validates fields via `Validators`, calls `ChangePasswordUseCase`, manages submission state
- [x] T022 [P] Create `LogoutState` in `lib/features/home/presentation/cubit/logout_state.dart` — isLoggingOutCurrent, isLoggingOutAll, errorMessage
- [x] T023 [P] Create `LogoutCubit` in `lib/features/home/presentation/cubit/logout_cubit.dart` — calls LogoutUseCase/LogoutAllUseCase then SessionCubit.logout(), manages loading state
- [x] T024 Register all new use cases and provide cubit factories in `lib/app.dart` dependency injection setup

---

## Phase 3: US1 — View Profile Identity Card (P1)

**Story Goal**: Authenticated users see their avatar initials and full name at the top of Settings.  
**Independent Test**: Open Settings as Lead and Customer — verify avatar shows correct initials and full name.

- [x] T025 [US1] Create `SettingsIdentityCard` widget in `lib/features/home/presentation/widgets/settings_identity_card.dart` — circular avatar container with computed initials text using `AppColors.brandRed`/`AppColors.surface`, full name using `AppTypography.heading3`, reads from `SettingsCubit`
- [x] T026 [US1] Create shared `SettingsPage` widget in `lib/features/home/presentation/pages/settings_page.dart` — Scaffold with AppBar titled "Settings", BlocProvider for SettingsCubit, ScrollView body starting with `SettingsIdentityCard`
- [x] T027 [US1] Rewrite `LeadSettingsPage` in `lib/features/home/presentation/pages/lead_settings_page.dart` — thin wrapper that provides cubits and renders `SettingsPage` with `SessionRole.lead`
- [x] T028 [US1] Rewrite `CustomerSettingsPage` in `lib/features/home/presentation/pages/customer_settings_page.dart` — thin wrapper that provides cubits and renders `SettingsPage` with `SessionRole.customer`

---

## Phase 4: US2 — Navigate to Edit Profile (P1)

**Story Goal**: Users tap Edit Profile and navigate to the correct role-specific profile page.  
**Independent Test**: Tap Edit Profile as Lead → reaches Lead Profile. Tap as Customer → reaches Customer Profile.

- [x] T029 [US2] Create `SettingsEditProfileSection` widget in `lib/features/home/presentation/widgets/settings_edit_profile_section.dart` — card with title "Edit Profile", subtitle, trailing chevron icon, tap navigates via `context.go()` to `AppRouter.leadProfile` or `AppRouter.customerProfile` based on role
- [x] T030 [US2] Add `SettingsEditProfileSection` to `SettingsPage` body below the identity card in `lib/features/home/presentation/pages/settings_page.dart`

---

## Phase 5: US3 — Reveal Digital Signature (P2)

**Story Goal**: Customers can reveal their digital signature via password, it auto-hides after 60s, and shows lock message on 403.  
**Independent Test**: Tap signature field → enter password → signature reveals → wait 60s → auto-hides. Enter wrong password → error in modal. Trigger 403 → lock message displayed.

- [x] T031 [US3] Create `SignaturePasswordModal` widget in `lib/features/home/presentation/widgets/signature_password_modal.dart` — `AlertDialog` with password TextField (obscureText toggle), submit button, error Text, loading state; calls cubit on submit, closes on success
- [x] T032 [US3] Create `SettingsSignatureSection` widget in `lib/features/home/presentation/widgets/settings_signature_section.dart` — card with masked asterisk text, `AnimatedCrossFade` for reveal/hide transition, `SelectableText` when revealed, copy-to-clipboard `IconButton` with SnackBar feedback, taps open `SignaturePasswordModal`; only rendered for Customer role
- [x] T033 [US3] Add `SettingsSignatureSection` to `SettingsPage` body with `BlocProvider<DigitalSignatureCubit>` wrapper, conditionally rendered only when role is Customer, in `lib/features/home/presentation/pages/settings_page.dart`

---

## Phase 6: US4 — Change Password (P2)

**Story Goal**: Users can change their password via a modal with current/new/confirm fields and validation.  
**Independent Test**: Open modal → submit invalid data → see inline errors. Submit valid data → success feedback and modal closes.

- [x] T034 [US4] Create `ChangePasswordModal` widget in `lib/features/home/presentation/widgets/change_password_modal.dart` — `AlertDialog` with three password TextFields (each with obscureText toggle), validation errors per field, submit button with loading state, general error display, success closes modal; uses `ChangePasswordCubit`
- [x] T035 [US4] Create `SettingsSecuritySection` widget in `lib/features/home/presentation/widgets/settings_security_section.dart` — card section titled "Security & Authentication" with action tiles for Change Password, Logout Current Session, Logout All Devices; taps open corresponding modals/dialogs
- [x] T036 [US4] Add `SettingsSecuritySection` to `SettingsPage` body with `BlocProvider<LogoutCubit>` wrapper in `lib/features/home/presentation/pages/settings_page.dart`

---

## Phase 7: US5 — Logout (P2)

**Story Goal**: Users can log out from current session or all devices, with confirmation only for all-device logout.  
**Independent Test**: Tap Logout Current → session cleared, navigates to Login. Tap Logout All → confirmation dialog appears → confirm → session cleared, navigates to Login.

- [x] T037 [US5] Create `LogoutConfirmationDialog` widget in `lib/features/home/presentation/widgets/logout_confirmation_dialog.dart` — `AlertDialog` with title "Logout All Devices?", message, Confirm/Cancel buttons using `AppColors`
- [x] T038 [US5] Wire Logout Current Session tap in `SettingsSecuritySection` to call `LogoutCubit.logoutCurrent()` then navigate to Login via `context.go(AppRouter.login)` in `lib/features/home/presentation/widgets/settings_security_section.dart`
- [x] T039 [US5] Wire Logout All Devices tap in `SettingsSecuritySection` to show `LogoutConfirmationDialog`, on confirm call `LogoutCubit.logoutAll()` then navigate to Login via `context.go(AppRouter.login)` in `lib/features/home/presentation/widgets/settings_security_section.dart`

---

## Phase 8: US6 — Switch Application Language (P3)

**Story Goal**: Users can switch between EN/AR from Settings and the change persists.  
**Independent Test**: Select Arabic → UI updates immediately. Restart app → language persists.

- [x] T040 [US6] Create `SettingsLanguageSection` widget in `lib/features/home/presentation/widgets/settings_language_section.dart` — card with radio-style EN/AR options, reads current locale from `LocaleCubit`, taps call `localeCubit.changeLocale()`, uses existing `LocaleRepository` for persistence
- [x] T041 [US6] Add `SettingsLanguageSection` to `SettingsPage` body at the bottom in `lib/features/home/presentation/pages/settings_page.dart`

---

## Phase 9: Polish & Cross-Cutting Concerns

- [x] T042 Verify signature auto-hide timer cancels on cubit dispose — test by revealing signature and navigating away, confirm signature is masked when returning to `lib/features/home/presentation/cubit/digital_signature_cubit.dart`
- [x] T043 Verify modal form state clears on dismiss — password fields, error messages, and loading states reset in `SignaturePasswordModal` and `ChangePasswordModal`
- [x] T044 Verify password field obscureText resets to hidden when modals close
- [x] T045 Verify all action buttons disable during loading states — signature submit, change password submit, logout buttons
- [x] T046 Verify signature clears and timer cancels on logout — listen to SessionCubit changes in `DigitalSignatureCubit`
- [x] T047 Verify RTL layout with Arabic language — no overflow, avatar and text align correctly, sections render in logical order
- [x] T048 Run `flutter analyze` and `flutter gen-l10n` — ensure zero errors

---

## Dependency Graph

```
Phase 1 (Setup: localization)
    ↓
Phase 2 (Foundational: data layer + cubits)
    ↓
Phase 3 (US1: Identity Card) ← MVP milestone
    ↓
Phase 4 (US2: Edit Profile) ← MVP complete
    ↓
Phase 5 (US3: Digital Signature) ← depends on Phase 2 cubits
Phase 6 (US4: Change Password) ← depends on Phase 2 cubits
Phase 7 (US5: Logout) ← depends on Phase 2 cubits + US4 security section
    ↓
Phase 8 (US6: Language) ← independent of US3–US5
    ↓
Phase 9 (Polish)
```

US3, US4, US5, and US6 are **independent** of each other after Phase 2. They can be implemented in parallel.

## Parallel Execution Opportunities

**Phase 2**: T004, T005, T007, T010, T011, T012–T015, T018–T023 can all run in parallel (different files, no cross-dependencies until T006/T009/T024).

**Phase 3–4** (US1 + US2): T025 and T029 can be built in parallel since they're independent widgets.

**Phase 5–8** (US3–US6): All four user story phases are independent after Phase 2. Can be assigned to different developers.

## Task Summary

| Phase | Tasks | Story |
|-------|-------|-------|
| Phase 1: Setup | T001–T003 | — |
| Phase 2: Foundational | T004–T024 | — |
| Phase 3: US1 Identity Card | T025–T028 | US1 |
| Phase 4: US2 Edit Profile | T029–T030 | US2 |
| Phase 5: US3 Digital Signature | T031–T033 | US3 |
| Phase 6: US4 Change Password | T034–T036 | US4 |
| Phase 7: US5 Logout | T037–T039 | US5 |
| Phase 8: US6 Language | T040–T041 | US6 |
| Phase 9: Polish | T042–T048 | — |
| **Total** | **48 tasks** | |

### MVP Scope (suggested)
US1 + US2 (Phases 1–4, tasks T001–T030) = **30 tasks** delivering the minimum viable settings experience.
