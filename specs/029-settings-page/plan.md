# Implementation Plan: Settings Page (Lead & Customer)

**Branch**: `029-settings-page` | **Date**: 2026-04-15 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/029-settings-page/spec.md`

## Summary

Replace the current empty Lead and Customer Settings page stubs with a full-featured card-based Settings page supporting both roles. The page includes a profile identity card with avatar initials, Edit Profile navigation, Digital Signature reveal with password verification and 60-second auto-hide, Change Password with validation, Logout (current/all devices), and Language switching. Implementation follows the existing Clean Architecture pattern with dedicated Cubits per feature action, extending the existing `CustomerPortalRemoteDataSource` and `SessionCubit` where needed.

## Technical Context

**Language/Version**: Dart 3.11 (Flutter stable, null-safe)
**Primary Dependencies**: `flutter_bloc`, `go_router`, `dio`, `flutter_localizations` (all existing — no new packages)
**Storage**: Existing session storage via `SessionCubit`; language via existing `LocaleCubit`/`SharedPreferences`
**Testing**: `flutter_test`, `bloc_test`, `mocktail`
**Target Platform**: Flutter mobile app (Android/iOS)
**Project Type**: Single Flutter mobile application with feature modules
**Performance Goals**: Signature reveal within 3s, auto-hide within 60s +/- 2s, all actions responsive with loading indicators
**Constraints**: Follow existing design tokens (AppColors, AppTypography, AppDimensions), reuse existing `Validators` and `LocaleCubit`, no new third-party packages, support LTR/RTL
**Scale/Scope**: One page with 4 feature cubits, extending 2 existing data sources and the session layer

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Gate 1 - Architecture Compliance: PASS. Networking/API calls in data layer, use cases for business logic, cubits for state, widgets for presentation only.
- Gate 2 - Folder Structure: PASS. Work expands existing `features/home/data` and `features/home/presentation` for settings; new cubits in presentation layer; auth change-password in `features/auth`.
- Gate 3 - State Management: PASS. Uses Cubit with immutable state models; no `setState` for app-state orchestration.
- Gate 4 - Theme Usage: PASS. All UI uses `AppColors`, `AppTypography`, and `AppDimensions` tokens.
- Gate 5 - Design Match: PASS. Card-based layout consistent with existing app patterns.
- Gate 6 - No Logic in Widgets: PASS. Validation in Cubit/Validators, timer management in Cubit, API calls in use cases.
- Gate 7 - Responsiveness: PASS. Card layout adapts to phone screen sizes with proper padding and spacing.
- Gate 8 - Code Quality: PASS. Dedicated state handling per action, error isolation, form cleanup on dismiss.
- Gate 9 - Package Check: PASS. No new packages required; all functionality achieved with existing dependencies.

## Project Structure

### Documentation (this feature)

```text
specs/029-settings-page/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
|   `-- settings-api-contract.md
`-- checklists/
    `-- requirements.md
```

### Source Code (repository root)

```text
lib/
|-- core/
|   |-- localization/
|   |   |-- l10n/
|   |   |   |-- app_en.arb          (updated)
|   |   |   `-- app_ar.arb          (updated)
|   |   `-- locale_cubit/           (reused as-is)
|   |-- networking/                 (reused as-is)
|   |-- routing/
|   |   `-- app_router.dart         (no new routes needed)
|   |-- theme/                      (reused as-is)
|   |-- utils/
|   |   `-- validators.dart         (reused as-is)
|   `-- widgets/                    (reused as-is)
|-- features/
|   |-- auth/
|   |   |-- data/
|   |   |   |-- data_sources/
|   |   |   |   `-- auth_remote_data_source.dart  (add changePassword method)
|   |   |   `-- repositories/
|   |   |       `-- auth_repository_impl.dart      (add changePassword)
|   |   |-- domain/
|   |   |   |-- repositories/
|   |   |   |   `-- auth_repository.dart           (add changePassword)
|   |   |   `-- use_cases/
|   |   |       `-- change_password_use_case.dart  (new)
|   |   `-- presentation/
|   |       `-- cubit/
|   |           |-- change_password_cubit.dart     (new - settings-specific)
|   |           `-- change_password_state.dart     (new - settings-specific)
|   `-- home/
|       |-- data/
|       |   |-- data_sources/
|       |   |   `-- customer_portal_remote_data_source.dart  (add 3 methods)
|       |   |-- models/
|       |   |   `-- customer_portal_models.dart               (add DTO)
|       |   `-- repositories/
|       |       `-- customer_portal_repository_impl.dart      (add 3 methods)
|       |-- domain/
|       |   |-- repositories/
|       |   |   `-- customer_portal_repository.dart           (add 3 methods)
|       |   `-- use_cases/
|       |       |-- reveal_signature_use_case.dart            (new)
|       |       |-- logout_use_case.dart                      (new)
|       |       `-- logout_all_use_case.dart                  (new)
|       `-- presentation/
|           |-- cubit/
|           |   |-- settings_cubit.dart                       (new)
|           |   |-- settings_state.dart                       (new)
|           |   |-- digital_signature_cubit.dart              (new)
|           |   |-- digital_signature_state.dart              (new)
|           |   |-- logout_cubit.dart                         (new)
|           |   `-- logout_state.dart                         (new)
|           |-- pages/
|           |   |-- lead_settings_page.dart                   (rewrite)
|           |   |-- customer_settings_page.dart               (rewrite)
|           |   `-- settings_page.dart                        (new - shared implementation)
|           `-- widgets/
|               |-- settings_identity_card.dart               (new)
|               |-- settings_edit_profile_section.dart        (new)
|               |-- settings_signature_section.dart           (new)
|               |-- signature_password_modal.dart             (new)
|               |-- settings_security_section.dart            (new)
|               |-- change_password_modal.dart                (new)
|               |-- logout_confirmation_dialog.dart           (new)
|               `-- settings_language_section.dart            (new)
`-- app.dart                                                  (register new dependencies)
```

**Structure Decision**: Settings reuses the existing `home` feature module for data/domain layers (customer portal data source, repository, use cases). Auth-specific change-password extends the `auth` feature. Presentation widgets are new under `home/presentation/widgets/` and `home/presentation/cubit/`. Both `LeadSettingsPage` and `CustomerSettingsPage` are thin wrappers that delegate to a shared `SettingsPage` widget with role-specific configuration.

## Complexity Tracking

No constitutional violations identified. No new packages required.

## Phase 0 Research Output

- Completed: [research.md](./research.md)
- All technical unknowns resolved, including:
  - Reuse of `LocaleCubit` for language switching (no new cubit needed)
  - Signature timer lifecycle management in `DigitalSignatureCubit`
  - Change password as separate use case from existing OTP flow
  - Logout API integration via existing `CustomerPortalRemoteDataSource`
  - Smooth signature reveal/hide via `AnimatedCrossFade`
  - Copy feedback via existing SnackBar pattern
  - 403 error message parsing strategy

## Phase 1 Design Output

- Completed: [data-model.md](./data-model.md)
- Completed: [contracts/settings-api-contract.md](./contracts/settings-api-contract.md)
- Completed: [quickstart.md](./quickstart.md)

## Post-Design Constitution Check

- Gate 1 - Architecture Compliance: PASS. All API calls in data sources, business logic in use cases/cubits, UI in widgets.
- Gate 2 - Folder Structure: PASS. New files follow existing feature-first module layout.
- Gate 3 - State Management: PASS. Four dedicated cubits with immutable states; timer managed in cubit lifecycle.
- Gate 4 - Theme Usage: PASS. Quickstart and contracts mandate shared theme token usage.
- Gate 5 - Design Match: PASS. Card-based layout matches existing app patterns (OnboardingHeader, CompanyDetailsHeaderSection).
- Gate 6 - No Logic in Widgets: PASS. Validation in Validators + Cubit, timer in Cubit, navigation in Cubit callbacks.
- Gate 7 - Responsiveness: PASS. Card layout with AppDimensions padding adapts to screen sizes.
- Gate 8 - Code Quality: PASS. Per-action state isolation, form cleanup, error handling with graceful degradation.
- Gate 9 - Package Check: PASS. No new packages; all functionality from existing dependencies.
