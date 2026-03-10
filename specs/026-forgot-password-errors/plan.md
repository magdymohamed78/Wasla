# Implementation Plan: Update Forgot Password Endpoint Error Handling

**Branch**: `026-forgot-password-errors` | **Date**: 2026-03-10 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/026-forgot-password-errors/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Update the Forgot Password flow to handle 404 (email not registered) and 403 (inactive account) API responses with toast messages, block navigation on error, and add a static "Don't have an account? Sign Up" link to the page. The existing cubit already maps DioException status codes but only handles 429; this plan adds 404 and 403 mappings, new localization strings, a persistent sign-up link widget in the form, and corresponding unit/widget tests.

## Technical Context

**Language/Version**: Dart (SDK ^3.11.0) / Flutter  
**Primary Dependencies**: flutter_bloc 8.1.6, go_router 14.8.1, dio 5.7.0, intl (any)  
**Storage**: N/A (no new persistence)  
**Testing**: flutter_test, bloc_test 9.1.7, mocktail 1.0.4  
**Target Platform**: Android, iOS  
**Project Type**: Mobile app (Flutter)  
**Performance Goals**: Toast displayed within 1 second of API response  
**Constraints**: Must not regress existing 429/network/server error handling  
**Scale/Scope**: Single page modification (Forgot Password), ~6 files changed

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Constitution is an unpopulated template — no project-specific principles are defined. No gates to evaluate. **PASS**.

## Project Structure

### Documentation (this feature)

```text
specs/026-forgot-password-errors/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── localization/l10n/
│   │   ├── app_en.arb               # Add new localization keys
│   │   └── app_ar.arb               # Add new localization keys
│   └── routing/
│       └── app_router.dart           # Reference only (routes exist)
└── features/
    └── auth/
        ├── data/
        │   └── data_sources/
        │       └── auth_remote_data_source.dart  # No changes (rethrows DioException)
        ├── domain/
        │   ├── repositories/
        │   │   └── auth_repository.dart          # No changes
        │   └── use_cases/
        │       └── forgot_password_use_case.dart  # No changes
        └── presentation/
            ├── cubit/
            │   ├── forgot_password_cubit.dart     # Add 404/403 mappings in _mapDioError
            │   └── forgot_password_state.dart     # No changes needed
            ├── pages/
            │   └── forgot_password_page.dart      # Add 404/403 toast messages in listener
            └── widgets/
                └── forgot_password_form.dart       # Add sign-up link widget below Send button

test/
└── features/
    └── auth/
        └── presentation/
            ├── cubit/
            │   └── forgot_password_cubit_test.dart  # Add 404/403 test cases
            └── pages/
                └── forgot_password_page_test.dart   # Add sign-up link and toast tests
```

**Structure Decision**: The feature fits entirely within the existing `features/auth/` module. No new directories, files, or architectural layers are needed. Changes are limited to the cubit error mapper, the page listener, the form widget, the localization files, and their corresponding tests.

## Complexity Tracking

No constitution violations — section not applicable.
