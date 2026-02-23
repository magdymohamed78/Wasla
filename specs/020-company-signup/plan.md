# Implementation Plan: Customer Portal Sign Up Page

**Branch**: `020-company-signup` | **Date**: 2026-02-23 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/020-company-signup/spec.md`

## Summary

Implement a customer registration page at the existing `/register` route, replacing the current `RegisterPlaceholderPage` with a full Sign Up form (First Name, Last Name, Phone Number, Email, Password, Confirm Password). The page integrates with `POST /api/customer-portal/register` following Clean Architecture patterns established by the login feature: data layer (RegisterRequestModel, remote data source), domain layer (RegisterUseCase, AuthRepository extension), and presentation layer (RegisterCubit/State, SignUpPage, SignUpForm). On success, the user session is persisted and the user navigates to the home screen.

## Technical Context

**Language/Version**: Dart SDK ^3.11.0, Flutter 3.11+ (latest stable)
**Primary Dependencies**: flutter_bloc 8.1.6, go_router 14.8.1, dio 5.7.0, shared_preferences 2.3.3, flutter_localizations + intl
**Storage**: SharedPreferences (session token + user data persistence via AuthLocalDataSource)
**Testing**: flutter_test, bloc_test 9.1.7, mocktail 1.0.4
**Target Platform**: Android (primary), iOS (secondary) — mobile
**Project Type**: Mobile app (Flutter)
**Performance Goals**: Client-side validation < 300ms, form submission round-trip < 3s on typical network
**Constraints**: Must match login page visual design exactly; RTL (Arabic) support required; min screen width 320px
**Scale/Scope**: Single feature addition (~15 new files) within existing auth feature module

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Constitution is a template (not customized for this project). No project-specific gates defined. The following implicit gates derived from codebase conventions are applied:

| Gate | Status | Notes |
|------|--------|-------|
| Clean Architecture layers | ✅ PASS | Feature follows data/domain/presentation separation matching login |
| Cubit-based state management | ✅ PASS | RegisterCubit follows LoginCubit pattern |
| No business logic in presentation | ✅ PASS | RegisterCubit handles all logic; page/form are pure presentation |
| Repository interface abstraction | ✅ PASS | AuthRepository extended with register() method |
| Localization for all user-facing text | ✅ PASS | All strings via AppLocalizations ARB keys |
| RTL support | ✅ PASS | Uses EdgeInsetsDirectional, start/end alignment where needed |

## Project Structure

### Documentation (this feature)

```text
specs/020-company-signup/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── register-api.md  # API contract for POST /api/customer-portal/register
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── localization/
│   │   └── l10n/
│   │       ├── app_en.arb            # + signUp* keys
│   │       └── app_ar.arb            # + signUp* keys (Arabic)
│   ├── routing/
│   │   └── app_router.dart           # Update: RegisterPlaceholderPage → SignUpPage
│   └── utils/
│       └── validators.dart           # + validateName(), validatePhone(), validatePasswordLength(), validateConfirmPassword()
├── features/
│   └── auth/
│       ├── data/
│       │   ├── data_sources/
│       │   │   └── auth_remote_data_source.dart  # + register() method
│       │   ├── models/
│       │   │   └── register_request_model.dart   # NEW
│       │   └── repositories/
│       │       └── auth_repository_impl.dart     # + register() implementation
│       ├── domain/
│       │   ├── repositories/
│       │   │   └── auth_repository.dart          # + register() abstract method
│       │   └── use_cases/
│       │       └── register_use_case.dart        # NEW
│       └── presentation/
│           ├── cubit/
│           │   ├── register_cubit.dart           # NEW
│           │   └── register_state.dart           # NEW
│           ├── pages/
│           │   ├── register_placeholder_page.dart # DELETED (replaced)
│           │   └── sign_up_page.dart              # NEW
│           └── widgets/
│               └── sign_up_form.dart              # NEW

test/
└── features/
    └── auth/
        ├── data/
        │   ├── data_sources/
        │   │   └── auth_remote_data_source_test.dart  # + register tests
        │   └── repositories/
        │       └── auth_repository_impl_test.dart     # + register tests
        ├── domain/
        │   └── use_cases/
        │       └── register_use_case_test.dart        # NEW
        └── presentation/
            └── cubit/
                └── register_cubit_test.dart           # NEW
```

**Structure Decision**: Extends the existing `auth` feature module following the same Clean Architecture pattern used by login. No new feature modules needed — registration is part of the authentication domain. Reuses `LoginEntity` and `LoginResponseModel` since the register endpoint returns the same `CustomerLoginResultDto`.

## Complexity Tracking

> No constitution violations. No complexity justifications needed.
