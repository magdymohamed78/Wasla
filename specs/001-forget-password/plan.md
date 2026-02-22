# Implementation Plan: Forget Password Page

**Branch**: `001-forget-password` | **Date**: 2026-02-22 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-forget-password/spec.md`

## Summary

Create a Forget Password page UI for the WASLA Flutter mobile app. The page displays a centered card with logo, illustration, email input with validation, and a Send button that shows a success toast. No API integration required - UI-only implementation following existing project patterns.

## Technical Context

**Language/Version**: Dart 3.11.0 / Flutter 3.11+
**Primary Dependencies**: flutter_bloc 8.1.6, go_router 14.8.1, intl (localization)
**Storage**: N/A (UI-only, no data persistence)
**Testing**: flutter_test, bloc_test 9.1.7, mocktail 1.0.4
**Target Platform**: iOS / Android (mobile)
**Project Type**: Mobile app (Flutter)
**Performance Goals**: 60fps, instant validation feedback
**Constraints**: Mobile-first responsive (320px-1920px), no API calls
**Scale/Scope**: Single page with form validation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Constitution file contains placeholder values. Proceeding with project-standard architecture patterns:
- Clean Architecture: Presentation layer only (page, cubit, widgets)
- Existing theme system: AppColors, AppTypography, AppDimensions
- Existing localization: AppLocalizations pattern
- Existing routing: GoRouter with AppRouter constants

## Project Structure

### Documentation (this feature)

```text
specs/001-forget-password/
├── spec.md              # Feature specification
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (via /speckit.tasks)
```

### Source Code (repository root)

```text
lib/
├── features/
│   └── auth/
│       └── presentation/
│           ├── pages/
│           │   └── forgot_password_page.dart      # Replace placeholder
│           ├── widgets/
│           │   └── forgot_password_form.dart      # Form widget
│           └── cubit/
│               ├── forgot_password_cubit.dart     # State management
│               └── forgot_password_state.dart     # State definition
├── core/
│   ├── theme/
│   │   └── app_dimensions.dart                    # Add new constants if needed
│   ├── localization/
│   │   └── l10n/
│   │       ├── AppLocalizations_en.dart           # Add English strings
│   │       └── AppLocalizations_ar.dart           # Add Arabic strings
│   └── routing/
│       └── app_router.dart                        # Already configured

assets/
└── images/
    └── forget password.png                        # Already exists

test/
└── features/
    └── auth/
        └── presentation/
            ├── pages/
            │   └── forgot_password_page_test.dart
            └── cubit/
                └── forgot_password_cubit_test.dart
```

**Structure Decision**: Follows existing project architecture - Clean Architecture with feature-based folders. The placeholder page already exists and will be replaced.

## Complexity Tracking

No constitution violations. Standard Flutter page implementation using existing patterns.

## Generated Artifacts

| Artifact | Path | Description |
|----------|------|-------------|
| Research | `research.md` | Technical decisions and rationale |
| Data Model | `data-model.md` | State management structure |
| UI Contract | `contracts/ui-contract.md` | Page layout, interactions, accessibility |
| Quickstart | `quickstart.md` | Implementation guide with code examples |

## Post-Design Constitution Check

All gates passed:
- Clean Architecture: Presentation layer only ✓
- Existing patterns: Follows LoginPage structure ✓
- Theme system: Uses AppColors, AppTypography, AppDimensions ✓
- Localization: Uses AppLocalizations pattern ✓
- Testing: Unit tests with flutter_test, bloc_test ✓
