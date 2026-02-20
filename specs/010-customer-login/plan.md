# Implementation Plan: Customer Login

**Branch**: `010-customer-login` | **Date**: 2026-02-19 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/010-customer-login/spec.md`

## Summary

Implement the Customer Login feature enabling email/password authentication against `POST /api/customer-portal/login`. The existing `009-customer-login` implementation provides a working foundation (entity, repository, cubit, UI). This plan addresses **gaps from the clarified specification**: inline form validation with error messages beneath fields, secure token persistence for "Remember Me" using SharedPreferences behind an abstract interface, navigation to a main/home dashboard placeholder, Forgot Password navigation, 429 rate-limit handling, session-expired redirect with token cleanup, and comprehensive unit/widget tests.

### Clarification Decisions Incorporated

| Clarification | Decision | Impact on Plan |
|---------------|----------|----------------|
| Post-login destination | Main/home dashboard (placeholder if not built) | FR-009: Add `/home` route + `HomePlaceholderPage` |
| Client-side rate limiting | None; rely on server-side (handle 429) | Add 429 → `rate_limited` error key in Cubit |
| Token expiry with "Remember Me" | Redirect to login + "Session expired" message + clear token | Add session-expired handling in `AuthLocalDataSource.clearAll()` |
| Token storage security | App-sandbox (SharedPreferences behind abstract interface) | FR-017: `AuthLocalDataSource` abstraction, no `flutter_secure_storage` needed |

## Technical Context

**Language/Version**: Dart (null-safe), SDK ^3.11.0  
**Primary Dependencies**: flutter_bloc ^8.1.6, go_router ^14.8.1, dio ^5.7.0, shared_preferences ^2.3.3  
**Storage**: shared_preferences (token persistence via abstract `AuthLocalDataSource` interface)  
**Testing**: flutter_test, bloc_test (to add), mocktail (to add)  
**Target Platform**: Android (primary), iOS (secondary) — mobile app  
**Project Type**: Mobile (Flutter)  
**Performance Goals**: Login response displayed within 30 seconds on stable connection; validation feedback <1s  
**Constraints**: Responsive across 360dp, 414dp, 768dp; LTR + RTL layouts; offline-graceful; handle 429 rate limiting  
**Scale/Scope**: Single feature module (`lib/features/auth/`) with ~13 existing files, ~6 new/modified files

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Principle | Status | Notes |
|---|-----------|--------|-------|
| I | Clean Architecture (NON-NEGOTIABLE) | **PASS** | Existing layers: `data/` → `domain/` → `presentation/`. New `AuthLocalDataSource` follows data layer. Validation in Cubit (presentation). |
| II | Feature-Based Modular Structure (NON-NEGOTIABLE) | **PASS** | All code under `lib/features/auth/{data,domain,presentation}/`. Shared validator in `core/utils/`. |
| III | Cubit State Management (NON-NEGOTIABLE) | **PASS** | `LoginCubit` emits immutable `LoginState`. New validation + 429 states extend same pattern. |
| IV | Navigation Separation (NON-NEGOTIABLE) | **PASS** | Navigation via `BlocListener` in `LoginPage`, not in widgets. `AppRouter` centralized. Dashboard + Forgot Password routes added to `AppRouter`. |
| V | Figma Design Compliance (NON-NEGOTIABLE) | **PASS** | Spec references Figma as design source. Implementation must match pixel-perfect. |
| VI | Centralized Theming (NON-NEGOTIABLE) | **PASS** | All styling from `AppColors`, `AppTypography`, `AppDimensions`. No hard-coded values. |
| VII | Widget Purity | **PASS** | `LoginForm` is pure presentation. Business logic in `LoginCubit`. Error key → l10n mapping stays in widget layer. |
| VIII | Responsive Design | **PASS** | `LayoutBuilder` in `LoginPage`. Spec defines 360dp/414dp/768dp breakpoints. |
| IX | Widget Reusability | **PASS** | Reusable `PrimaryButton`, `WaslaLogo` from `core/widgets/`. Shared `validators.dart` in `core/utils/`. |
| X | Testable & Maintainable Code | **PASS** | Dependencies injected. Abstract interfaces used. Full test suite planned with `bloc_test` + `mocktail`. |

**Gate Result**: PASS — No violations. Proceed to Phase 0.

## Project Structure

### Documentation (this feature)

```text
specs/010-customer-login/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── login-api.yaml   # OpenAPI contract for POST /api/customer-portal/login
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart          # (existing) centralized colors
│   │   ├── app_dimensions.dart      # (existing) centralized spacing
│   │   └── app_typography.dart      # (existing) centralized text styles
│   ├── routing/
│   │   └── app_router.dart          # (existing, MODIFY) add /home, /forgot-password routes
│   ├── widgets/
│   │   ├── primary_button.dart      # (existing) reusable button
│   │   └── wasla_logo.dart          # (existing) reusable logo
│   └── utils/
│       └── validators.dart          # (NEW) email validation utility
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── data_sources/
│   │   │   │   ├── auth_remote_data_source.dart    # (existing)
│   │   │   │   └── auth_local_data_source.dart     # (NEW) token persistence via SharedPreferences
│   │   │   ├── models/
│   │   │   │   ├── login_request_model.dart         # (existing)
│   │   │   │   └── login_response_model.dart        # (existing)
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart        # (existing, MODIFY) accept AuthLocalDataSource; persist token on Remember Me
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── login_entity.dart                # (existing)
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart             # (existing)
│   │   │   └── use_cases/
│   │   │       └── login_use_case.dart              # (existing)
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── login_cubit.dart                 # (existing, MODIFY) add validation logic, 429 handling
│   │       │   └── login_state.dart                 # (existing, MODIFY) add emailError, passwordError, hasSubmitted
│   │       ├── pages/
│   │       │   ├── login_page.dart                  # (existing, MODIFY) add retry action, session-expired handling
│   │       │   └── forgot_password_placeholder_page.dart  # (NEW) placeholder
│   │       └── widgets/
│   │           └── login_form.dart                  # (existing, MODIFY) add inline validation errorText
│   └── home/
│       └── presentation/
│           └── pages/
│               └── home_placeholder_page.dart       # (NEW) dashboard placeholder
test/
└── features/
    └── auth/
        ├── data/
        │   ├── data_sources/
        │   │   └── auth_remote_data_source_test.dart   # (NEW)
        │   └── repositories/
        │       └── auth_repository_impl_test.dart      # (NEW)
        ├── domain/
        │   └── use_cases/
        │       └── login_use_case_test.dart             # (NEW)
        └── presentation/
            ├── cubit/
            │   └── login_cubit_test.dart                # (NEW)
            └── pages/
                └── login_page_test.dart                 # (NEW)
```

**Structure Decision**: Mobile (Flutter) with existing Clean Architecture feature module at `lib/features/auth/`. New files add local data source for token persistence, a shared validator utility, placeholder pages for post-login dashboard and forgot password, and comprehensive tests. All new code follows the established modular structure per Constitution Principle II.

## Post-Design Constitution Re-Check

*Re-evaluated after Phase 1 design artifacts (data-model.md, contracts/, quickstart.md) were generated.*

| # | Principle | Status | Design Verification |
|---|-----------|--------|---------------------|
| I | Clean Architecture (NON-NEGOTIABLE) | **PASS** | `AuthLocalDataSource` (abstract + impl) in data layer. `LoginCubit` orchestrates domain use case. No layer violations in quickstart.md file assignments. |
| II | Feature-Based Modular Structure (NON-NEGOTIABLE) | **PASS** | All auth files under `lib/features/auth/`. Dashboard placeholder under `lib/features/home/`. Shared validator in `lib/core/utils/`. |
| III | Cubit State Management (NON-NEGOTIABLE) | **PASS** | data-model.md confirms immutable `LoginState` with `copyWith`. New fields (`emailError`, `passwordError`, `hasSubmitted`) follow existing pattern. 429 and session-expired error keys fit `errorMessage` field. |
| IV | Navigation Separation (NON-NEGOTIABLE) | **PASS** | quickstart.md confirms navigation via `BlocListener` in `LoginPage`. New routes (`/home`, `/forgot-password`) added to centralized `AppRouter`. Session-expired redirect uses `AppRouter` guard. |
| V | Figma Design Compliance (NON-NEGOTIABLE) | **PASS** | Spec references Figma. Inline validation error placement matches design intent. No design decisions contradict Figma compliance. |
| VI | Centralized Theming (NON-NEGOTIABLE) | **PASS** | quickstart.md references `AppColors`, `AppTypography`, `AppDimensions` for all styling. No hard-coded values in design. |
| VII | Widget Purity | **PASS** | `LoginForm` remains pure presentation. Error key → localized string mapping stays in widget layer. Business logic in `LoginCubit`. |
| VIII | Responsive Design | **PASS** | `LayoutBuilder` pattern preserved. Spec breakpoints (360dp/414dp/768dp) apply to all new UI elements (placeholder pages, validation messages). |
| IX | Widget Reusability | **PASS** | Existing `PrimaryButton`, `WaslaLogo` reused. New `validators.dart` shared utility. Placeholder pages follow consistent patterns. |
| X | Testable & Maintainable Code | **PASS** | Abstract `AuthLocalDataSource` enables mocking. Test plan covers cubit, use case, repository, and widget layers. `bloc_test` + `mocktail` as dev deps. |

**Post-Design Gate Result**: PASS — All 10 principles verified against design artifacts. No violations.

## Complexity Tracking

> No violations found — no entries needed.
