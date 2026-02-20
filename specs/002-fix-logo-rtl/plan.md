# Implementation Plan: Fix Logo RTL Alignment

**Branch**: `006-fix-logo-rtl` | **Date**: 2026-02-19 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/006-fix-logo-rtl/spec.md`

## Summary

Ensure the Wasla logo group (`_LogoGroup`) on the onboarding page remains centered with its internal content order (circle "W" → "ASLA") reading left-to-right in both LTR and RTL modes. The current implementation already uses `Directionality(textDirection: TextDirection.ltr)` to prevent internal mirroring and wraps the logo in `Center`. This plan verifies correctness, adds widget tests to lock down the behavior, and documents the pattern for future branding elements.

## Technical Context

**Language/Version**: Dart (null-safe), SDK ^3.11.0  
**Framework**: Flutter (latest stable)  
**Primary Dependencies**: flutter_bloc (Cubit), go_router, flutter_localizations, intl  
**Storage**: N/A (no data changes)  
**Testing**: flutter_test  
**Target Platform**: Android (primary), iOS (secondary)  
**Project Type**: Mobile  
**Performance Goals**: 60fps, no layout rebuild jank during language switch  
**Constraints**: RTL support for Arabic must remain intact for all non-branding elements  
**Scale/Scope**: 1 file modified (`onboarding_page.dart`), 1 test file added

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Principle | Status | Evidence |
|---|-----------|--------|----------|
| I | Clean Architecture | ✅ PASS | Change is purely in presentation layer (widget layout). No domain or data layer impact |
| II | Feature-Based Modular Structure | ✅ PASS | Changes scoped to `features/onboarding/presentation/`. No cross-feature impact |
| III | Cubit State Management | ✅ PASS | No Cubit changes. Existing `LocaleCubit` and `OnboardingCubit` unaffected |
| IV | Navigation Separation | ✅ PASS | No navigation changes |
| V | Figma Design Compliance | ✅ PASS | Logo centered position matches Figma. Internal LTR order matches brand guidelines |
| VI | Centralized Theming | ✅ PASS | Uses existing `AppColors`, `AppDimensions`. No hard-coded values introduced |
| VII | Widget Purity | ✅ PASS | `_LogoGroup` is a pure presentation widget. No business logic |
| VIII | Responsive Design | ✅ PASS | `FittedBox(fit: BoxFit.scaleDown)` already handles scaling on small screens |
| IX | Widget Reusability | ✅ PASS | `_LogoGroup` is a private widget within onboarding. Core `WaslaLogo` widget unaffected |
| X | Testable & Maintainable Code | ✅ PASS | Adding widget tests improves testability. `Directionality` wrapper documents intent |

**Gate Result**: ✅ ALL PASS — Proceed to Phase 0.

### Post-Design Re-Check (after Phase 1)

| # | Principle | Status | Post-Design Evidence |
|---|-----------|--------|---------------------|
| I | Clean Architecture | ✅ PASS | No domain or data layer changes. Only presentation layer widget verification and test addition |
| II | Feature-Based Modular Structure | ✅ PASS | Changes in `features/onboarding/presentation/`. Test in `test/features/onboarding/presentation/`. No cross-feature impact |
| III | Cubit State Management | ✅ PASS | No Cubit changes. `LocaleCubit` and `OnboardingCubit` remain untouched |
| IV | Navigation Separation | ✅ PASS | No navigation changes. All routing stays in `AppRouter` |
| V | Figma Design Compliance | ✅ PASS | Logo centered position and LTR internal order match Figma brand guidelines. Confirmed in research.md R3 |
| VI | Centralized Theming | ✅ PASS | Uses existing `AppColors.brandRed`, `AppColors.background`. No hard-coded values |
| VII | Widget Purity | ✅ PASS | `_LogoGroup` remains a pure presentation widget with no business logic |
| VIII | Responsive Design | ✅ PASS | `FittedBox(fit: BoxFit.scaleDown)` already handles scaling. No new responsive concerns |
| IX | Widget Reusability | ✅ PASS | Core `WaslaLogo` widget in `core/widgets/` unchanged. `_LogoGroup` is appropriately scoped as private |
| X | Testable & Maintainable Code | ✅ PASS | Adding widget tests for RTL behavior. Intent-documenting `Directionality` wrapper preserved |

**Post-Design Gate Result**: ✅ ALL PASS — No violations. No complexity tracking entries needed.

## Project Structure

### Documentation (this feature)

```text
specs/006-fix-logo-rtl/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (empty — no API contracts for this feature)
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
└── features/
    └── onboarding/
        └── presentation/
            └── pages/
                └── onboarding_page.dart   # _LogoGroup widget (verify/harden)

test/
└── features/
    └── onboarding/
        └── presentation/
            └── pages/
                └── onboarding_page_test.dart  # NEW: RTL logo alignment tests
```

**Structure Decision**: Mobile app structure following existing feature-based modular layout. Changes are isolated to a single presentation file and one new test file.
