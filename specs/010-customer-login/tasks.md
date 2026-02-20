# Tasks: Customer Login

**Input**: Design documents from `/specs/010-customer-login/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/login-api.yaml, quickstart.md

**Tests**: Included — plan.md section 8 and research.md R4 define a testing strategy with bloc_test + mocktail.

**Organization**: Tasks grouped by user story for independent implementation and testing. User stories from spec.md in priority order (P1 → P2 → P3).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks in same phase)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Exact file paths included in every task description

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add dev dependencies and shared utilities needed across multiple user stories

- [X] T001 Add bloc_test and mocktail dev dependencies to pubspec.yaml and run flutter pub get
- [X] T002 [P] Create shared email regex validator function in lib/core/utils/validators.dart
- [X] T003 [P] Add validation and error localization keys (emailRequired, emailInvalid, passwordRequired, loginRateLimited, loginSessionExpired) to lib/core/localization/l10n/app_en.arb and lib/core/localization/l10n/app_ar.arb, then run flutter gen-l10n

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Create NEW files that multiple user stories depend on. The core auth architecture exists from 009; this phase adds missing infrastructure.

**⚠️ CRITICAL**: US1 needs HomePlaceholderPage + /home route. US4 needs AuthLocalDataSource. US5 needs ForgotPasswordPlaceholderPage + /forgot-password route.

- [X] T004 [P] Create AuthLocalDataSource abstract class and AuthLocalDataSourceImpl using SharedPreferences (saveToken, getToken, clearToken, saveUser, getUser, clearAll) in lib/features/auth/data/data_sources/auth_local_data_source.dart
- [X] T005 [P] Create HomePlaceholderPage (simple Scaffold with AppBar title "Home") in lib/features/home/presentation/pages/home_placeholder_page.dart
- [X] T006 [P] Create ForgotPasswordPlaceholderPage (simple Scaffold with AppBar title "Forgot Password") in lib/features/auth/presentation/pages/forgot_password_placeholder_page.dart
- [X] T007 Add /home route (HomePlaceholderPage) and /forgot-password route (ForgotPasswordPlaceholderPage) to AppRouter in lib/core/routing/app_router.dart

**Checkpoint**: Foundation ready — all new files created, routes registered. User story implementation can begin.

---

## Phase 3: User Story 1 — Sign In with Email and Password (Priority: P1) 🎯 MVP

**Goal**: Complete the core sign-in flow: successful login navigates to /home dashboard, 429 rate limiting handled, network error retry available.

**Independent Test**: Enter valid credentials → tap Sign In → verify navigation to /home. Enter invalid credentials → verify error snackbar. Simulate 429 → verify "Too many attempts" message.

**Context**: The basic login flow (API call, 401 handling, loading state) already works from 009. This phase completes navigation and edge case handling.

### Implementation for User Story 1

- [X] T008 [P] [US1] Add 429 rate_limited case to _mapDioError() method (check DioException statusCode 429, return 'rate_limited' error key) in lib/features/auth/presentation/cubit/login_cubit.dart
- [X] T009 [P] [US1] Update LoginPage: change success navigation target to AppRouter.home (/home), add retry SnackBarAction to error snackbar, add rate_limited case to _showErrorSnackBar switch in lib/features/auth/presentation/pages/login_page.dart

**Checkpoint**: Core sign-in flow complete — customers can authenticate and reach the home dashboard. MVP is functional.

---

## Phase 4: User Story 2 — Input Validation Feedback (Priority: P1)

**Goal**: Show inline validation error messages beneath email and password fields when the customer submits invalid input.

**Independent Test**: Tap Sign In with empty fields → verify "Email is required" and "Password is required" appear beneath fields. Enter invalid email format → verify "Please enter a valid email address" appears. Fix errors → verify messages clear immediately.

**Context**: Validation follows the hasSubmitted pattern (errors shown only after first submit, then live-validate on input change). Error keys in state → localized strings in UI.

### Implementation for User Story 2

- [X] T010 [US2] Add emailError (String?), passwordError (String?), and hasSubmitted (bool) fields to LoginState; update copyWith and props list in lib/features/auth/presentation/cubit/login_state.dart
- [X] T011 [P] [US2] Add _validateEmail() and _validatePassword() private methods to LoginCubit using validators.dart; integrate validation into login() (set hasSubmitted=true, validate before API call), emailChanged(), and passwordChanged() (re-validate live if hasSubmitted) in lib/features/auth/presentation/cubit/login_cubit.dart
- [X] T012 [P] [US2] Wire inline validation in LoginForm: map state.emailError/state.passwordError keys to localized strings via AppLocalizations, pass to InputDecoration.errorText on email and password TextFormFields in lib/features/auth/presentation/widgets/login_form.dart

**Checkpoint**: Inline validation complete — customers see immediate feedback for invalid inputs.

---

## Phase 5: User Story 3 — Password Visibility Toggle (Priority: P2)

**Goal**: Allow customers to toggle password field visibility between obscured and plain text.

**Independent Test**: Type in password field → tap visibility icon → verify text becomes visible. Tap again → verify text is obscured.

**Context**: Already fully implemented in 009 — LoginCubit.togglePasswordVisibility(), LoginState.obscurePassword, and visibility toggle icon in LoginForm all exist.

### Implementation for User Story 3

- [X] T013 [US3] Verify password visibility toggle: confirm toggle icon switches between visibility/visibility_off icons and obscurePassword state toggles correctly in lib/features/auth/presentation/widgets/login_form.dart

**Checkpoint**: Password toggle verified — no new code needed.

---

## Phase 6: User Story 4 — Remember Me (Priority: P2)

**Goal**: Persist authentication token when "Remember Me" is enabled so customers stay signed in across app sessions. Handle session expiry by clearing stored token and redirecting to login.

**Independent Test**: Sign in with "Remember Me" checked → close app → reopen → verify auto-navigation past login. Wait for token expiry → verify redirect to login with "Session expired" message.

**Context**: Remember Me checkbox UI exists from 009 (LoginCubit.toggleRememberMe, LoginState.rememberMe). This phase adds the persistence layer and auto-login logic.

### Implementation for User Story 4

- [X] T014 [US4] Add getStoredSession() → Future<LoginEntity?> and clearSession() → Future<void> method signatures to AuthRepository interface in lib/features/auth/domain/repositories/auth_repository.dart
- [X] T015 [US4] Modify AuthRepositoryImpl constructor to accept AuthLocalDataSource; implement token/user persistence on login when rememberMe=true, getStoredSession() delegating to local data source, and clearSession() calling clearAll() in lib/features/auth/data/repositories/auth_repository_impl.dart
- [X] T016 [US4] Wire AuthLocalDataSource into DI: instantiate AuthLocalDataSourceImpl with SharedPreferences, pass to AuthRepositoryImpl, update MultiBlocProvider chain in lib/app.dart
- [X] T017 [US4] Add checkAuthStatus() method to LoginCubit for auto-login on app startup (check stored session, emit success if valid); add session expiry handling (on 401 during active session, call clearSession(), emit session_expired error key) in lib/features/auth/presentation/cubit/login_cubit.dart
- [X] T018 [US4] Add redirect guard in AppRouter: check stored token on /home route, redirect to /login if token absent or expired; handle session_expired error key display in LoginPage snackbar in lib/core/routing/app_router.dart

**Checkpoint**: Remember Me fully functional — customers stay signed in across sessions; expired sessions redirect gracefully.

---

## Phase 7: User Story 5 — Navigate to Forgot Password (Priority: P3)

**Goal**: Tapping "Forgot Password?" on the login screen navigates to the password recovery placeholder.

**Independent Test**: On login screen → tap "Forgot Password?" → verify navigation to /forgot-password placeholder page.

**Context**: ForgotPasswordPlaceholderPage and /forgot-password route created in Phase 2. This phase wires the button.

### Implementation for User Story 5

- [X] T019 [US5] Wire Forgot Password TextButton onPressed in LoginForm to navigate to /forgot-password via context.push(AppRouter.forgotPassword) in lib/features/auth/presentation/widgets/login_form.dart

**Checkpoint**: Forgot Password navigation wired — tapping the link reaches the placeholder.

---

## Phase 8: User Story 6 — Navigate to Sign Up (Priority: P3)

**Goal**: Tapping "Don't have an account? Sign Up" navigates to the registration screen.

**Independent Test**: On login screen → tap "Sign Up" link → verify navigation to /register placeholder page.

**Context**: /register route and RegisterPlaceholderPage already exist from 009. This phase verifies the link is wired.

### Implementation for User Story 6

- [X] T020 [US6] Verify Sign Up navigation link in LoginForm navigates to /register route correctly in lib/features/auth/presentation/widgets/login_form.dart

**Checkpoint**: Sign Up navigation verified — no new code needed.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Unit and widget tests for all layers per Constitution Principle X and research.md R4. Final validation.

- [X] T021 [P] Create LoginCubit unit tests (validation logic, login success/failure, 429 handling, toggle visibility, toggle remember me, checkAuthStatus, session expiry) using bloc_test + mocktail in test/features/auth/presentation/cubit/login_cubit_test.dart
- [X] T022 [P] Create LoginUseCase unit tests (delegates to repository correctly) using mocktail in test/features/auth/domain/use_cases/login_use_case_test.dart
- [X] T023 [P] Create AuthRepositoryImpl unit tests (maps data source responses to entities, handles errors, persists token on rememberMe, getStoredSession, clearSession) using mocktail in test/features/auth/data/repositories/auth_repository_impl_test.dart
- [X] T024 [P] Create LoginPage widget tests (renders form, shows validation errors, shows loading, shows error snackbar, navigates on success) using mocktail in test/features/auth/presentation/pages/login_page_test.dart
- [X] T025 Run quickstart.md validation: execute flutter pub get, flutter gen-l10n, flutter test, flutter run and verify no errors per specs/010-customer-login/quickstart.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 (needs dev deps installed)
- **US1 (Phase 3)**: Depends on Phase 2 (needs /home route + HomePlaceholderPage)
- **US2 (Phase 4)**: Depends on Phase 1 (needs validators.dart + l10n keys). Independent of US1.
- **US3 (Phase 5)**: Verification only — can run anytime after Phase 2
- **US4 (Phase 6)**: Depends on Phase 2 (needs AuthLocalDataSource). Independent of US1–US3.
- **US5 (Phase 7)**: Depends on Phase 2 (needs /forgot-password route). Independent of US1–US4.
- **US6 (Phase 8)**: Verification only — can run anytime after Phase 2
- **Polish (Phase 9)**: Depends on all user story phases being complete

### User Story Dependencies

- **US1 (P1)**: Independent — core sign-in flow completion
- **US2 (P1)**: Independent — inline validation only touches state/cubit/form
- **US3 (P2)**: Independent — already implemented, verification only
- **US4 (P2)**: Independent — token persistence layer. Note: US1 acceptance scenario 4 (auto-login) is actually delivered by US4
- **US5 (P3)**: Independent — single navigation wire-up
- **US6 (P3)**: Independent — already implemented, verification only

### Within Each User Story

1. State changes before cubit logic
2. Cubit logic before UI wiring
3. Domain interface before data implementation
4. Data layer before DI wiring
5. All implementation before tests

### Parallel Opportunities

**Phase 1**: T002 and T003 can run in parallel (different files)
**Phase 2**: T004, T005, T006 can run in parallel (all create new files); T007 runs after them
**Phase 3**: T008 and T009 can run in parallel (login_cubit.dart vs login_page.dart)
**Phase 4**: T011 and T012 can run in parallel after T010 (login_cubit.dart vs login_form.dart)
**Phase 9**: T021, T022, T023, T024 can all run in parallel (all create new test files)

**Cross-Phase Parallelism**: After Phase 2, US1 (Phase 3), US2 (Phase 4), US3 (Phase 5), US5 (Phase 7), and US6 (Phase 8) can all start in parallel since they touch different files and have no inter-story dependencies.

---

## Parallel Example: User Story 2

```text
# After T010 (LoginState changes) completes:

# Launch in parallel:
Task T011: "Add validation methods to LoginCubit in lib/features/auth/presentation/cubit/login_cubit.dart"
Task T012: "Wire inline validation in LoginForm in lib/features/auth/presentation/widgets/login_form.dart"
```

## Parallel Example: Cross-Story (after Phase 2)

```text
# After Phase 2 (Foundational) completes, start all independent stories:

# Developer A (or sequential pass 1):
Task T008: [US1] login_cubit.dart (429 handling)
Task T009: [US1] login_page.dart (navigation + retry)

# Developer B (or sequential pass 2):
Task T010: [US2] login_state.dart
Task T011: [US2] login_cubit.dart (validation)
Task T012: [US2] login_form.dart (error display)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (dev deps, validator, l10n keys)
2. Complete Phase 2: Foundational (new files + routes)
3. Complete Phase 3: User Story 1 (sign-in → /home + 429 handling)
4. **STOP and VALIDATE**: Customer can sign in with valid credentials and reach /home
5. This is the minimum viable login feature

### Incremental Delivery

1. Setup + Foundational → Infrastructure ready
2. US1 → Core sign-in works → **MVP** ✓
3. US2 → Inline validation feedback → Better UX ✓
4. US3 → Password toggle verified → Usability check ✓
5. US4 → Remember Me persists sessions → Convenience feature ✓
6. US5 + US6 → Navigation links wired → Full login screen ✓
7. Polish → Tests pass, quality validated → Production-ready ✓

Each story adds value without breaking previous stories.

---

## Notes

- **Existing code from 009**: 13 files provide the working auth foundation. This plan extends, not rewrites.
- **US3 and US6 are verification-only**: Already implemented in 009. Tasks confirm correctness.
- **US4 acceptance scenario overlap**: US1 scenario 4 (auto-login on reopen) is actually delivered by US4 (Remember Me).
- **Login_cubit.dart touched by T008 (US1), T011 (US2), T017 (US4)**: These are in sequential phases, no conflict.
- **Login_form.dart touched by T012 (US2), T013 (US3), T019 (US5), T020 (US6)**: All in sequential phases.
- **AppRouter touched by T007 (Phase 2), T018 (US4)**: Sequential phases, different sections.
- Commit after each task or logical group.
- Stop at any checkpoint to validate the story independently.
