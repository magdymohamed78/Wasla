# Implementation Plan: App Onboarding

**Branch**: `001-app-onboarding` | **Date**: 2026-02-17 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-app-onboarding/spec.md`

## Summary

Implement a branded animated splash screen with a drop-down logo animation sequence and a multilingual onboarding welcome page with language switching (English/Arabic), language persistence, and navigation triggers to Login, Registration, and Support screens. The existing `splash_screen.dart` will be replaced entirely. The architecture follows Clean Architecture with feature-based modularization, Cubit state management, go_router for centralized navigation, and Flutter intl for localization.

## Technical Context

**Language/Version**: Dart (null-safe), SDK ^3.11.0  
**Framework**: Flutter (latest stable)  
**Primary Dependencies**: flutter_bloc (Cubit), go_router, flutter_localizations, intl, shared_preferences  
**Storage**: shared_preferences (language persistence)  
**Testing**: flutter_test, bloc_test, mocktail  
**Target Platform**: Android (primary), iOS (secondary)  
**Project Type**: Mobile  
**Performance Goals**: 60fps animation, <500ms navigation response, <1s language switch  
**Constraints**: Offline-capable (no backend needed), RTL support for Arabic  
**Scale/Scope**: 3 screens (Splash, Onboarding, Support placeholder), 2 languages

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Principle | Status | Evidence |
|---|-----------|--------|----------|
| I | Clean Architecture | ✅ PASS | Three layers defined: presentation (widgets, cubits, pages), domain (entities, use cases, repository interfaces), data (models, repository impls, data sources) |
| II | Feature-Based Modular Structure | ✅ PASS | Features: `splash`, `onboarding`, `support`. Core: `theme`, `routing`, `localization`, `widgets` |
| III | Cubit State Management | ✅ PASS | SplashCubit (animation state → navigation trigger), OnboardingCubit (language state), LocaleCubit (app-wide language) |
| IV | Navigation Separation | ✅ PASS | go_router AppRouter in `core/routing/`. Splash → Onboarding transition via Cubit state listened by router. No `Navigator.push` in widgets |
| V | Figma Design Compliance | ✅ PASS | Spec references Figma-matching pixel-perfect layout. SC-004 enforces zero deviation |
| VI | Centralized Theming | ✅ PASS | AppColors (#E6212B brand red), AppTypography, AppDimensions defined in `core/theme/` |
| VII | Widget Purity | ✅ PASS | All business logic in Cubits/use cases. Widgets receive data via BlocBuilder/BlocListener |
| VIII | Responsive Design | ✅ PASS | ResponsiveUtils breakpoints defined. Onboarding layout tested at 360dp, 414dp, 768dp |
| IX | Widget Reusability | ✅ PASS | Reusable: WaslaLogo, PrimaryButton, SecondaryButton, LanguageDropdown in `core/widgets/` |
| X | Testable & Maintainable Code | ✅ PASS | All dependencies injected. Abstract repository interfaces. Cubits independently testable |

**Gate Result**: ✅ ALL PASS — Proceed to Phase 0.

### Post-Design Re-Check (after Phase 1)

| # | Principle | Status | Post-Design Evidence |
|---|-----------|--------|---------------------|
| I | Clean Architecture | ✅ PASS | `LocaleRepository` abstract interface in data-model.md, `LocaleRepositoryImpl` with SharedPreferences in data layer, Cubits in presentation |
| II | Feature-Based Modular Structure | ✅ PASS | `features/splash/`, `features/onboarding/`, `features/support/` each with `presentation/` subtree. Core in `core/theme/`, `core/routing/`, `core/localization/`, `core/widgets/` |
| III | Cubit State Management | ✅ PASS | `SplashCubit`, `OnboardingCubit`, `LocaleCubit` with immutable state classes defined in data-model.md. Injected via `BlocProvider` |
| IV | Navigation Separation | ✅ PASS | `AppRouter` with static route constants in contracts/routes.md. `BlocListener` triggers navigation. No direct `Navigator.push` anywhere |
| V | Figma Design Compliance | ✅ PASS | SC-004 enforces zero deviation. Theme constants centralized |
| VI | Centralized Theming | ✅ PASS | `core/theme/` has `app_colors.dart`, `app_typography.dart`, `app_dimensions.dart`. Brand color #E6212B documented |
| VII | Widget Purity | ✅ PASS | Animation widgets are `StatelessWidget` receiving `Animation<double>` params. All logic in Cubits |
| VIII | Responsive Design | ✅ PASS | `core/utils/responsive_utils.dart` in structure. 3 breakpoints required |
| IX | Widget Reusability | ✅ PASS | `core/widgets/` has 4 reusable widgets: WaslaLogo, PrimaryButton, SecondaryButton, LanguageDropdown |
| X | Testable & Maintainable Code | ✅ PASS | Abstract `LocaleRepository`, DI throughout, test directory structure defined |

**Post-Design Gate Result**: ✅ ALL PASS — No violations. No complexity tracking entries needed.

## Project Structure

### Documentation (this feature)

```text
specs/001-app-onboarding/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── routes.md
└── tasks.md             # Phase 2 output (NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_dimensions.dart
│   │   └── app_theme.dart
│   ├── routing/
│   │   └── app_router.dart
│   ├── localization/
│   │   ├── app_localizations.dart
│   │   ├── l10n/
│   │   │   ├── intl_en.arb
│   │   │   └── intl_ar.arb
│   │   └── locale_cubit/
│   │       ├── locale_cubit.dart
│   │       └── locale_state.dart
│   ├── widgets/
│   │   ├── wasla_logo.dart
│   │   ├── primary_button.dart
│   │   ├── secondary_button.dart
│   │   └── language_dropdown.dart
│   └── utils/
│       └── responsive_utils.dart
├── features/
│   ├── splash/
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── splash_cubit.dart
│   │       │   └── splash_state.dart
│   │       ├── pages/
│   │       │   └── splash_page.dart
│   │       └── widgets/
│   │           ├── animated_logo_circle.dart
│   │           ├── animated_w_letter.dart
│   │           ├── animated_asla_text.dart
│   │           └── loading_dots.dart
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── onboarding_cubit.dart
│   │       │   └── onboarding_state.dart
│   │       ├── pages/
│   │       │   └── onboarding_page.dart
│   │       └── widgets/
│   │           └── onboarding_header.dart
│   └── support/
│       └── presentation/
│           └── pages/
│               └── support_page.dart
├── main.dart
└── app.dart

test/
├── features/
│   ├── splash/
│   │   └── presentation/
│   │       └── cubit/
│   │           └── splash_cubit_test.dart
│   └── onboarding/
│       └── presentation/
│           └── cubit/
│               └── onboarding_cubit_test.dart
└── core/
    └── localization/
        └── locale_cubit_test.dart
```

**Structure Decision**: Mobile Flutter project using feature-based Clean Architecture per Constitution Principle II. The `splash` feature has no domain/data layers since it has no business logic beyond animation timing—only a presentation layer with a Cubit controlling animation state. The `onboarding` feature also has only a presentation layer for this scope. The `core/localization/` module holds the app-wide `LocaleCubit` since language is a cross-cutting concern shared by all features.

## Complexity Tracking

> No constitution violations detected. This section is intentionally empty.
