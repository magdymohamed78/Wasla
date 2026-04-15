# Quickstart: Settings Page (Lead & Customer)

## 1) Add localization keys
1. Add all new localization keys from the contract to `app_en.arb` and `app_ar.arb`.
2. Run `flutter gen-l10n` to regenerate localization classes.
3. Verify generated `AppLocalizations` contains all new getters.

## 2) Extend data layer (API calls)
1. Add three new methods to `CustomerPortalRemoteDataSource`:
   - `revealDigitalSignature({required String password})` → `POST /api/customer-portal/my/digital-signature`
   - `logout()` → `POST /api/customer-portal/logout`
   - `logoutAll()` → `POST /api/customer-portal/logout-all`
2. Add corresponding DTOs in `customer_portal_models.dart` for signature response.
3. Add three new methods to `CustomerPortalRepository` interface and its implementation.
4. Create `ChangePasswordRemoteDataSource` (or add to `AuthRemoteDataSource`) for `POST /api/Auth/change-password`.
5. Create `ChangePasswordRepository` interface and implementation.
6. Add corresponding use cases: `RevealDigitalSignatureUseCase`, `LogoutUseCase`, `LogoutAllUseCase`, `ChangePasswordUseCase`.

## 3) Register dependencies in `app.dart`
1. Register new repository implementations, use cases, and cubits in the DI container.
2. Ensure new data sources receive the existing `Dio` instance.

## 4) Implement settings cubits
1. `SettingsCubit` — reads `SessionCubit` state, exposes `SettingsUserIdentity` (firstName, lastName, role, initials, fullName).
2. `DigitalSignatureCubit` — manages `SignatureRevealState` (hidden/revealed/locked), owns 60-second auto-hide `Timer`.
3. `ChangePasswordCubit` — manages `ChangePasswordFormState`, runs validation via `Validators`, calls use case.
4. `LogoutCubit` — manages `LogoutActionState`, calls logout/logout-all use cases then triggers `SessionCubit.logout()`.

## 5) Implement Settings page widgets
1. Replace both `LeadSettingsPage` and `CustomerSettingsPage` stubs with a single shared `SettingsPage` widget (or keep separate pages that both use shared widgets).
2. Build `SettingsIdentityCard` (CB-001): circular avatar with initials + full name.
3. Build `SettingsEditProfileSection` (CB-002): card with title, subtitle, chevron, tap navigates to role-specific profile page.
4. Build `SettingsSignatureSection` (CB-003): card with masked/revealed text, `AnimatedCrossFade` transition, copy button when revealed. Only rendered for Customer role.
5. Build `SignaturePasswordModal` (CB-004): dialog with password field, show/hide toggle, submit button, error text.
6. Build `SettingsSecuritySection` (CB-006): card section with three action tiles.
7. Build `ChangePasswordModal` (CB-005): dialog with three password fields, show/hide toggles, validation, submit.
8. Build `LogoutAllConfirmationDialog` (CB-006a): `AlertDialog` with confirm/cancel.
9. Build `SettingsLanguageSection` (CB-007): radio-style EN/AR options, delegates to existing `LocaleCubit`.
10. Assemble all sections in the `SettingsPage` scaffold (CB-008).

## 6) Wire routing
1. `DiscoveryShellPage` already routes Lead → `LeadSettingsPage` and Customer → `CustomerSettingsPage`.
2. Ensure Edit Profile taps navigate correctly:
   - Lead → `context.go(AppRouter.leadProfile)`
   - Customer → `context.go(AppRouter.customerProfile)`
3. Post-logout navigation: `context.go(AppRouter.login)`.

## 7) Handle edge cases and state cleanup
1. Signature timer cancellation on cubit `close()`.
2. Signature clear on logout (listen to `SessionCubit` changes).
3. Modal form state reset on dismiss.
4. Password field visibility reset on modal close.
5. Action button disabling during loading states.

## 8) Validate quality gates
1. Verify theme token usage only (AppColors, AppTypography, AppDimensions).
2. Verify RTL layout with Arabic language.
3. Verify role-based section visibility (no signature section for Lead).
4. Verify signature auto-hide after 60 seconds.
5. Verify 403 lock message display.
6. Verify change password validation matches registration rules.
7. Verify both logout flows clear session and navigate to Login.
8. Run `flutter analyze` and `flutter gen-l10n`.
9. Run targeted widget and cubit tests.
