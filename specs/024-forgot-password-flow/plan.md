# Implementation Plan: Forgot Password Flow – UI + API Implementation

**Branch**: `024-forgot-password-flow` | **Date**: 2026-03-05 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/024-forgot-password-flow/spec.md`

## Summary

Implement a three-screen forgot password flow (Forgot Password → OTP Verification → Change Password) with full API integration against `POST /api/Auth/forgot-password`, `POST /api/Auth/resend-otp`, and `POST /api/Auth/reset-password`. The existing UI-only `ForgotPasswordCubit` and `ForgotPasswordPage` will be refactored to call the real API. Two new screens (OTP Verification, Change Password) with their own Cubits will be created. New request models, repository methods, use cases, and routes will be added following the project's established Clean Architecture pattern.

## Technical Context

**Language/Version**: Dart 3.x / Flutter SDK ^3.11.0  
**Primary Dependencies**: flutter_bloc ^8.1.6 (Cubit pattern), go_router ^14.8.1, dio ^5.7.0, flutter_localizations  
**Storage**: N/A for this feature (email/OTP held in-memory via route params and cubit state)  
**Testing**: flutter_test, bloc_test ^9.1.7, mocktail ^1.0.4  
**Target Platform**: Android & iOS (mobile)  
**Project Type**: Mobile app (Flutter cross-platform)  
**Performance Goals**: Form validation < 100ms, API call feedback (loading indicator) immediate, 60fps UI  
**Constraints**: All state is in-memory; app kill loses flow progress. 60-second UI resend timer. Rate limit: 5 req/60s/IP per endpoint.  
**Scale/Scope**: 3 new screens, 3 new cubits, 3 new request models, 3 new use cases, 3 new repository methods, 3 new data source methods, 2 new routes

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Constitution file (`.specify/memory/constitution.md`) contains a blank template with no project-specific principles or gates defined. **PASS** — no violations possible against an empty constitution.

## Project Structure

### Documentation (this feature)

```text
specs/024-forgot-password-flow/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (OpenAPI fragments)
│   ├── forgot-password.yaml
│   ├── reset-password.yaml
│   └── resend-otp.yaml
└── tasks.md             # Phase 2 output (NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── routing/
│   │   └── app_router.dart              # MODIFY — add OTP & change-password routes
│   └── utils/
│       └── validators.dart              # MODIFY — add validateOtp, validatePasswordMatch
├── features/
│   └── auth/
│       ├── data/
│       │   ├── data_sources/
│       │   │   └── auth_remote_data_source.dart   # MODIFY — add 3 API methods
│       │   ├── models/
│       │   │   ├── forgot_password_request_model.dart  # NEW
│       │   │   ├── reset_password_request_model.dart   # NEW
│       │   │   └── resend_otp_request_model.dart       # NEW
│       │   └── repositories/
│       │       └── auth_repository_impl.dart      # MODIFY — add 3 method impls
│       ├── domain/
│       │   ├── repositories/
│       │   │   └── auth_repository.dart           # MODIFY — add 3 abstract methods
│       │   └── use_cases/
│       │       ├── forgot_password_use_case.dart   # NEW
│       │       ├── reset_password_use_case.dart    # NEW
│       │       └── resend_otp_use_case.dart        # NEW
│       └── presentation/
│           ├── cubit/
│           │   ├── forgot_password_cubit.dart      # MODIFY — integrate real API
│           │   ├── forgot_password_state.dart       # MODIFY — add loading/failure states
│           │   ├── otp_verification_cubit.dart      # NEW
│           │   ├── otp_verification_state.dart      # NEW
│           │   ├── change_password_cubit.dart       # NEW
│           │   └── change_password_state.dart       # NEW
│           ├── pages/
│           │   ├── forgot_password_page.dart        # MODIFY — navigate to OTP on success
│           │   ├── otp_verification_page.dart       # NEW
│           │   └── change_password_page.dart        # NEW
│           └── widgets/
│               ├── forgot_password_form.dart        # MODIFY — loading/error states
│               ├── otp_input_field.dart             # NEW — 6-box OTP widget
│               ├── otp_verification_form.dart       # NEW
│               └── change_password_form.dart        # NEW

test/
└── features/
    └── auth/
        ├── data/
        │   ├── data_sources/
        │   │   └── auth_remote_data_source_test.dart  # MODIFY — test 3 new methods
        │   └── repositories/
        │       └── auth_repository_impl_test.dart     # MODIFY — test 3 new methods
        ├── domain/
        │   └── use_cases/
        │       ├── forgot_password_use_case_test.dart  # NEW
        │       ├── reset_password_use_case_test.dart   # NEW
        │       └── resend_otp_use_case_test.dart       # NEW
        └── presentation/
            └── cubit/
                ├── forgot_password_cubit_test.dart     # MODIFY — test real API flow
                ├── otp_verification_cubit_test.dart    # NEW
                └── change_password_cubit_test.dart     # NEW
```

**Structure Decision**: Follows the existing Flutter Clean Architecture pattern with feature-based organization (`data/domain/presentation` layers). All new files go under `lib/features/auth/` matching the existing auth feature structure. New cubits are created locally in their pages (same pattern as existing `ForgotPasswordCubit`).

## Complexity Tracking

> No constitution violations — table not applicable.
