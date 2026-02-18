# Tasks: App Onboarding

**Input**: Design documents from `/specs/001-app-onboarding/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/routes.md ✅, quickstart.md ✅

**Tests**: Not explicitly requested in the feature specification. Test tasks are omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Mobile (Flutter)**: `lib/` for source, `test/` for tests, at repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization, dependency installation, and localization code generation

- [ ] T001 Add flutter_bloc, go_router, flutter_localizations, intl, and shared_preferences dependencies to `pubspec.yaml` and add `generate: true` under the `flutter:` section
- [ ] T002 Create `l10n.yaml` at project root with arb-dir `lib/core/localization/l10n`, template `app_en.arb`, output class `AppLocalizations`, and `nullable-getter: false`
- [ ] T003 [P] Create English ARB file at `lib/core/localization/l10n/app_en.arb` with keys: onboardingLogIn, onboardingNewUser, languageEnglish, languageArabic, supportPageTitle, supportPageDescription
- [ ] T004 [P] Create Arabic ARB file at `lib/core/localization/l10n/app_ar.arb` with translated values for all keys defined in app_en.arb
- [ ] T005 Run `flutter pub get` and `flutter gen-l10n` to install dependencies and generate the `AppLocalizations` class

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented. Includes theming, routing, localization cubit, and reusable widgets.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

### Theme System (Constitution Principle VI)

- [ ] T006 [P] Create `AppColors` with brand red (#E6212B), background, text, and button color constants in `lib/core/theme/app_colors.dart`
- [ ] T007 [P] Create `AppTypography` with text styles for headings, body, and button labels in `lib/core/theme/app_typography.dart`
- [ ] T008 [P] Create `AppDimensions` with spacing, padding, border radius, and icon size constants in `lib/core/theme/app_dimensions.dart`
- [ ] T009 Create `AppTheme` that composes AppColors, AppTypography, and AppDimensions into a `ThemeData` in `lib/core/theme/app_theme.dart` (depends on T006, T007, T008)

### Responsive Utilities (Constitution Principle VIII)

- [ ] T010 [P] Create `ResponsiveUtils` with breakpoints for small phone (360dp), large phone (414dp), and tablet (768dp) in `lib/core/utils/responsive_utils.dart`

### Localization Infrastructure (FR-014, FR-016, FR-017, FR-018, FR-019)

- [ ] T011 [P] Create `LocaleRepository` abstract interface with `getSavedLocale()` and `saveLocale(Locale)` methods in `lib/core/localization/locale_repository.dart`
- [ ] T012 Implement `LocaleRepositoryImpl` using SharedPreferences with key `app_locale`, including validation that falls back to English for unsupported codes, in `lib/core/localization/locale_repository_impl.dart` (depends on T005)
- [ ] T013 [P] Create `LocaleState` class holding current `Locale` in `lib/core/localization/locale_cubit/locale_state.dart`
- [ ] T014 Create `LocaleCubit` with `changeLocale(Locale)` method that persists via LocaleRepository and emits new LocaleState, plus init method that loads persisted locale on startup, in `lib/core/localization/locale_cubit/locale_cubit.dart` (depends on T011, T013)

### Routing Infrastructure (Constitution Principle IV)

- [ ] T015 Create `AppRouter` final class with static route path constants (splash `/`, onboarding `/onboarding`, support `/support`, login `/login`, register `/register`) and static `GoRouter router()` method with all 5 route definitions, including `CustomTransitionPage` with `FadeTransition` for the onboarding route, in `lib/core/routing/app_router.dart` (depends on T005)

### Reusable Widgets (Constitution Principle IX)

- [ ] T016 [P] Create `WaslaLogo` reusable widget displaying the red circle with "W" letter inside, configurable via size parameter, in `lib/core/widgets/wasla_logo.dart` (depends on T006)
- [ ] T017 [P] Create `PrimaryButton` reusable widget with configurable label text and onPressed callback, styled per AppTheme, in `lib/core/widgets/primary_button.dart` (depends on T006, T007)
- [ ] T018 [P] Create `SecondaryButton` reusable widget with configurable label text and onPressed callback, styled per AppTheme, in `lib/core/widgets/secondary_button.dart` (depends on T006, T007)
- [ ] T019 [P] Create `LanguageDropdown` reusable widget that shows a globe icon and opens a dropdown with "English" and "العربية" options, emitting selected Locale via callback, in `lib/core/widgets/language_dropdown.dart` (depends on T006, T007)

### App Entry Point Refactor

- [ ] T020 Create `App` widget in `lib/app.dart` with `MultiRepositoryProvider` providing `LocaleRepositoryImpl`, `MultiBlocProvider` providing `LocaleCubit`, `BlocBuilder<LocaleCubit, LocaleState>` wrapping `MaterialApp.router` with `locale`, `localizationsDelegates`, `supportedLocales`, `routerConfig`, and `AppTheme` (depends on T009, T012, T014, T015)
- [ ] T021 Refactor `lib/main.dart` to initialize `WidgetsFlutterBinding`, `SharedPreferences`, and call `runApp(const App())` — remove old `MyApp` class and imports to `splash_screen.dart` and `home_screen.dart` (depends on T020)
- [ ] T022 Delete obsolete files `lib/splash_screen.dart` and `lib/home_screen.dart` that are replaced by the new feature-based structure (depends on T021)

**Checkpoint**: Foundation ready — theme, routing, localization, and reusable widgets all in place. User story implementation can now begin.

---

## Phase 3: User Story 1 — Animated Splash Screen Experience (Priority: P1) 🎯 MVP

**Goal**: Display a branded animated splash screen with drop-down logo, "W" fade-in, "ASLA" slide-in, and loading dots, then auto-navigate to the onboarding page after 2 seconds.

**Independent Test**: Launch the app → observe the complete animation sequence (circle drops → W fades → ASLA slides → dots animate) → app transitions to onboarding page with fade after 2 seconds.

### Implementation for User Story 1

- [ ] T023 [P] [US1] Create `SplashState` class with `SplashAnimationPhase` enum (initial, animating, completed) in `lib/features/splash/presentation/cubit/splash_state.dart`
- [ ] T024 [US1] Create `SplashCubit` with `startAnimation()` and `onAnimationComplete()` methods that emit phase transitions (initial → animating → completed) in `lib/features/splash/presentation/cubit/splash_cubit.dart` (depends on T023)
- [ ] T025 [P] [US1] Create `AnimatedLogoCircle` stateless widget receiving `Animation<double>` parameter, rendering red circle (#E6212B) with `Transform.translate` on Y-axis using `Curves.bounceOut` in `lib/features/splash/presentation/widgets/animated_logo_circle.dart` (depends on T006)
- [ ] T026 [P] [US1] Create `AnimatedWLetter` stateless widget receiving `Animation<double>` parameter, rendering "W" text with `Opacity` fade using `Curves.easeIn` in `lib/features/splash/presentation/widgets/animated_w_letter.dart` (depends on T007)
- [ ] T027 [P] [US1] Create `AnimatedAslaText` stateless widget receiving `Animation<double>` parameter, rendering "ASLA" with `Transform.translate` on X-axis + `Opacity` using `Curves.easeOutCubic` in `lib/features/splash/presentation/widgets/animated_asla_text.dart` (depends on T006, T007)
- [ ] T028 [P] [US1] Create `LoadingDots` stateful widget with its own repeating `AnimationController` (~600ms), rendering 3 dots with staggered scale+opacity intervals (0.0–0.6, 0.15–0.75, 0.3–0.9), using `Curves.easeInOut` in `lib/features/splash/presentation/widgets/loading_dots.dart` (depends on T006)
- [ ] T029 [US1] Create `SplashPage` as StatefulWidget with `TickerProviderStateMixin`, owning master `AnimationController` (2000ms) with 4 `Interval`-scoped animations (circle 0.0–0.35, W 0.35–0.525, ASLA 0.525–0.70, dots 0.70–1.0), `BlocProvider` for `SplashCubit`, `BlocListener` that calls `context.go('/onboarding')` on `SplashCompleted`, composing all 4 animation widgets + `LoadingDots`, in `lib/features/splash/presentation/pages/splash_page.dart` (depends on T024, T025, T026, T027, T028, T015)

**Checkpoint**: At this point, launching the app shows the full animated splash screen and auto-navigates to `/onboarding` (which shows an empty route until US2 is built). User Story 1 is fully functional and independently testable.

---

## Phase 4: User Story 2 — Multilingual Onboarding Page (Priority: P2)

**Goal**: Display a branded onboarding welcome page with centered Wasla logo, "Log In" and "New User" buttons, and a globe language dropdown that switches the entire app between English and Arabic with persistence.

**Independent Test**: Navigate to the onboarding page → verify logo centered, both buttons visible, globe icon at top-left → tap globe → select Arabic → all text updates to Arabic, layout becomes RTL → close and reopen app → app displays in Arabic.

### Implementation for User Story 2

- [ ] T030 [P] [US2] Create `OnboardingState` class with `OnboardingNavigation` enum (idle, navigateToLogin, navigateToRegister, navigateToSupport) in `lib/features/onboarding/presentation/cubit/onboarding_state.dart`
- [ ] T031 [US2] Create `OnboardingCubit` with `goToLogin()`, `goToRegister()`, `goToSupport()`, and `resetNavigation()` methods emitting navigation state changes in `lib/features/onboarding/presentation/cubit/onboarding_cubit.dart` (depends on T030)
- [ ] T032 [US2] Create `OnboardingHeader` widget rendering the top row with `LanguageDropdown` (start-aligned) and support icon `IconButton` (end-aligned), using `EdgeInsetsDirectional` for RTL support, in `lib/features/onboarding/presentation/widgets/onboarding_header.dart` (depends on T019)
- [ ] T033 [US2] Create `OnboardingPage` composing `OnboardingHeader`, centered `WaslaLogo`, `PrimaryButton` ("Log In" via `AppLocalizations`), `SecondaryButton` ("New User" via `AppLocalizations`), with `BlocProvider` for `OnboardingCubit`, `BlocListener` handling navigation states via `context.go()`/`context.push()`, and `BlocBuilder<LocaleCubit>` wiring `LanguageDropdown` to `LocaleCubit.changeLocale()`, in `lib/features/onboarding/presentation/pages/onboarding_page.dart` (depends on T016, T017, T018, T031, T032, T014)

**Checkpoint**: At this point, the full splash → onboarding flow works. Language switching updates all text immediately, persists across restarts, and RTL layout mirrors correctly. User Stories 1 AND 2 are both independently functional.

---

## Phase 5: User Story 3 — Support Access from Onboarding (Priority: P3)

**Goal**: Enable navigation from the onboarding page's support icon to a Support page with help/contact information, with back navigation returning to onboarding with preserved state.

**Independent Test**: On the onboarding page → tap the support icon → app navigates to the Support page with help content → tap back → returns to onboarding with language selection preserved.

### Implementation for User Story 3

- [ ] T034 [US3] Create `SupportPage` with localized title via `AppLocalizations.supportPageTitle`, localized description via `AppLocalizations.supportPageDescription`, `AppBar` with back button, styled per `AppTheme`, using `EdgeInsetsDirectional` for RTL support, in `lib/features/support/presentation/pages/support_page.dart` (depends on T006, T007, T009)
- [ ] T035 [US3] Create placeholder `LoginPlaceholderPage` with centered "Login — Coming Soon" text and back navigation in `lib/features/auth/presentation/pages/login_placeholder_page.dart` (depends on T009)
- [ ] T036 [US3] Create placeholder `RegisterPlaceholderPage` with centered "Register — Coming Soon" text and back navigation in `lib/features/auth/presentation/pages/register_placeholder_page.dart` (depends on T009)
- [ ] T037 [US3] Wire `SupportPage`, `LoginPlaceholderPage`, and `RegisterPlaceholderPage` into `AppRouter.router()` route builders in `lib/core/routing/app_router.dart` (depends on T034, T035, T036, T015)

**Checkpoint**: All 3 user stories are now complete. Full flow: splash → onboarding (with language switch + RTL) → support (with back nav) / login placeholder / register placeholder.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final cleanup, validation, and quality assurance across all stories

- [ ] T038 Verify all widgets use `AppColors`, `AppTypography`, and `AppDimensions` — no hard-coded colors, fonts, or spacing anywhere in `lib/` (Constitution Principle VI audit)
- [ ] T039 Verify all padding and alignment use directional variants (`EdgeInsetsDirectional`, `AlignmentDirectional`, `start`/`end`) for RTL correctness across all files in `lib/features/` and `lib/core/widgets/`
- [ ] T040 Run the complete quickstart.md verification checklist: splash animation sequence, onboarding layout, language switch, language persistence, support navigation, and placeholder routes
- [ ] T041 Run `flutter analyze` and fix any lint warnings or errors across the entire project

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup (T005 specifically) — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Foundational completion (T006, T007, T015 specifically)
- **US2 (Phase 4)**: Depends on Foundational completion (T014, T016, T017, T018, T019 specifically). Can run in parallel with US1 if team capacity allows
- **US3 (Phase 5)**: Depends on Foundational completion (T009, T015). Can run in parallel with US1/US2
- **Polish (Phase 6)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) — No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) — No dependencies on US1
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) — No dependencies on US1/US2, but onboarding header wiring (T032) references the support icon which also maps to T037

### Within Each User Story

- State classes before Cubits
- Cubits before pages
- Sub-widgets (animation widgets, header) before the page that composes them
- Story complete before moving to next priority

### Parallel Opportunities

**Phase 2 (Foundational) — up to 4 parallel streams:**
- Stream A: T006 + T007 + T008 → T009
- Stream B: T010 (independent)
- Stream C: T011 + T013 → T014 | T012 (after T005)
- Stream D: T016 + T017 + T018 + T019 (after T006/T007)

**Phase 3 (US1) — up to 4 parallel streams:**
- Stream A: T025 (logo circle)
- Stream B: T026 (W letter)
- Stream C: T027 (ASLA text)
- Stream D: T028 (loading dots)
- Then: T029 (composes all)

**Phase 4 (US2) — up to 2 parallel streams:**
- Stream A: T030 → T031
- Stream B: T032
- Then: T033 (composes all)

**Phase 5 (US3) — up to 3 parallel streams:**
- Stream A: T034 (support page)
- Stream B: T035 (login placeholder)
- Stream C: T036 (register placeholder)
- Then: T037 (wiring)

---

## Parallel Example: User Story 1

```text
# Launch all animation sub-widgets in parallel (different files, no dependencies):
T025: AnimatedLogoCircle in lib/features/splash/presentation/widgets/animated_logo_circle.dart
T026: AnimatedWLetter in lib/features/splash/presentation/widgets/animated_w_letter.dart
T027: AnimatedAslaText in lib/features/splash/presentation/widgets/animated_asla_text.dart
T028: LoadingDots in lib/features/splash/presentation/widgets/loading_dots.dart

# Then compose them in the page (depends on all above):
T029: SplashPage in lib/features/splash/presentation/pages/splash_page.dart
```

## Parallel Example: User Story 2

```text
# Launch state + header in parallel:
T030: OnboardingState in lib/features/onboarding/presentation/cubit/onboarding_state.dart
T032: OnboardingHeader in lib/features/onboarding/presentation/widgets/onboarding_header.dart

# Then cubit (depends on state):
T031: OnboardingCubit in lib/features/onboarding/presentation/cubit/onboarding_cubit.dart

# Then compose in page (depends on all above):
T033: OnboardingPage in lib/features/onboarding/presentation/pages/onboarding_page.dart
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001–T005)
2. Complete Phase 2: Foundational (T006–T022)
3. Complete Phase 3: User Story 1 (T023–T029)
4. **STOP and VALIDATE**: Launch app → splash animation plays → navigates to onboarding route
5. Demo if ready — splash screen alone delivers brand identity value

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add User Story 1 → Splash animation working → Demo (MVP!)
3. Add User Story 2 → Onboarding with multilingual → Demo
4. Add User Story 3 → Support + placeholders → Demo
5. Polish → Final quality pass
6. Each story adds value without breaking previous stories

### Parallel Team Strategy

With 3 developers after Foundational is complete:

- Developer A: User Story 1 (T023–T029) — splash animation
- Developer B: User Story 2 (T030–T033) — onboarding page
- Developer C: User Story 3 (T034–T037) — support + placeholders

All 3 stories can proceed simultaneously since they work on different feature directories.

---

## Notes

- [P] tasks = different files, no dependencies on incomplete tasks
- [US#] label maps each task to its specific user story
- No test tasks included — tests were not requested in the feature spec
- The existing `lib/splash_screen.dart` and `lib/home_screen.dart` are deleted in T022 after the new entry point is in place
- All file paths are absolute from repository root (`lib/`)
- Commit after each task or logical group
- Stop at any checkpoint to validate the story independently
