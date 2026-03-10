# Tasks: Update Forgot Password Endpoint Error Handling

**Input**: Design documents from `/specs/026-forgot-password-errors/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Not explicitly requested in the feature specification. Tests included based on existing test coverage patterns in the codebase.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Localization & Infrastructure)

**Purpose**: Add localization keys so generated code is available for all subsequent tasks

- [X] T001 [P] Add English localization keys (`forgotPasswordNotRegistered`, `forgotPasswordInactiveAccount`, `forgotPasswordSignUp`, `forgotPasswordSignUpAction`, `forgotPasswordContactSupport`) in `lib/core/localization/l10n/app_en.arb`
- [X] T002 [P] Add Arabic localization keys (`forgotPasswordNotRegistered`, `forgotPasswordInactiveAccount`, `forgotPasswordSignUp`, `forgotPasswordSignUpAction`, `forgotPasswordContactSupport`) in `lib/core/localization/l10n/app_ar.arb`
- [X] T003 Run `flutter gen-l10n` to regenerate localization classes

**Checkpoint**: Localization keys available for use in all subsequent tasks

---

## Phase 2: User Story 1 — Unregistered Email Feedback (Priority: P1) 🎯 MVP

**Goal**: When the API returns 404, show a toast "Email not registered. Please sign up first." and block navigation. Add a static "Don't have an account? Sign Up" link below the Send button that navigates to the Sign Up page.

**Independent Test**: Enter a non-existent email → verify toast appears, no navigation occurs, tap "Sign Up" link → navigates to Sign Up page.

### Implementation for User Story 1

- [X] T004 [US1] Add `404 → 'notFound'` case in `_mapDioError` method in `lib/features/auth/presentation/cubit/forgot_password_cubit.dart`
- [X] T005 [US1] Add `'notFound'` case in page-level `_mapErrorMessage` function to return `localizations.forgotPasswordNotRegistered` in `lib/features/auth/presentation/pages/forgot_password_page.dart`
- [X] T006 [US1] Add `'notFound'` case in form-level `_mapErrorMessage` method in `lib/features/auth/presentation/widgets/forgot_password_form.dart`
- [X] T007 [US1] Add static `_SignUpLink` widget below `_SubmitButton` in the `ForgotPasswordForm` Column in `lib/features/auth/presentation/widgets/forgot_password_form.dart` — uses `forgotPasswordSignUp`/`forgotPasswordSignUpAction` localization keys and navigates to `AppRouter.register` via `context.push`

**Checkpoint**: User Story 1 is complete — 404 returns toast, user stays on page, sign-up link always visible and navigable

---

## Phase 3: User Story 2 — Inactive Account Feedback (Priority: P2)

**Goal**: When the API returns 403, show a toast "Account exists but is inactive — please contact support." with a "Contact Support" action button that navigates to the Support page. Block navigation to the next screen.

**Independent Test**: Submit an email for an inactive account → verify toast appears with "Contact Support" button, no navigation occurs, tap button → navigates to Support page.

### Implementation for User Story 2

- [X] T008 [US2] Add `403 → 'inactive'` case in `_mapDioError` method in `lib/features/auth/presentation/cubit/forgot_password_cubit.dart`
- [X] T009 [US2] Handle `'inactive'` error key in the `BlocListener` in `lib/features/auth/presentation/pages/forgot_password_page.dart` — show a snackbar with message `localizations.forgotPasswordInactiveAccount` and a `SnackBarAction` labeled `localizations.forgotPasswordContactSupport` that calls `context.push(AppRouter.support)`
- [X] T010 [US2] Add `'inactive'` case in page-level `_mapErrorMessage` function in `lib/features/auth/presentation/pages/forgot_password_page.dart`
- [X] T011 [US2] Add `'inactive'` case in form-level `_mapErrorMessage` method in `lib/features/auth/presentation/widgets/forgot_password_form.dart`

**Checkpoint**: User Story 2 is complete — 403 returns toast with "Contact Support" action button, user stays on page, tapping button navigates to Support page

---

## Phase 4: User Story 3 — Successful Password Reset (Non-Regression) (Priority: P1)

**Goal**: Verify the existing happy path (200 → navigate to Change Password) continues to work without regression.

**Independent Test**: Submit a registered, active email → verify navigation to Change Password page occurs.

### Implementation for User Story 3

No implementation tasks — the happy path is already implemented. Verification is covered by existing tests and the regression test in Phase 5.

**Checkpoint**: Existing 200 OK flow confirmed unaffected by new error handling

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Tests, regression validation, and final verification

- [X] T012 [P] Add bloc_test for 404 DioException → emits `failure` state with `errorMessage='notFound'` in `test/features/auth/presentation/cubit/forgot_password_cubit_test.dart`
- [X] T013 [P] Add bloc_test for 403 DioException → emits `failure` state with `errorMessage='inactive'` in `test/features/auth/presentation/cubit/forgot_password_cubit_test.dart`
- [X] T014 [P] Add widget test verifying "Sign Up" link is always visible on the Forgot Password page in `test/features/auth/presentation/pages/forgot_password_page_test.dart`
- [X] T015 [P] Add widget test verifying "Sign Up" link navigates to the Sign Up page route in `test/features/auth/presentation/pages/forgot_password_page_test.dart`
- [X] T016 [P] Add widget test verifying 403 snackbar shows "Contact Support" action button and tapping it navigates to Support page in `test/features/auth/presentation/pages/forgot_password_page_test.dart`
- [X] T017 Run full test suite (`flutter test`) to confirm no regressions across all existing tests
- [X] T018 Run quickstart.md validation — verify all steps in `specs/026-forgot-password-errors/quickstart.md` execute successfully

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately. T003 depends on T001+T002.
- **User Story 1 (Phase 2)**: Depends on Phase 1 (localization keys must exist)
- **User Story 2 (Phase 3)**: Depends on Phase 1. Can run in parallel with Phase 2 (different status codes, but same files so sequential is safer).
- **User Story 3 (Phase 4)**: No implementation — verification only after Phase 2+3.
- **Polish (Phase 5)**: Depends on Phases 2 and 3 being complete.

### Within Each User Story

- Cubit error mapping (T004/T008) before page/form message mapping (T005-T007/T009-T011)
- Page-level and form-level mappings can be done in parallel [P] since they're in different files but share the same error key dependency

### Parallel Opportunities

- T001 and T002 (ARB files) can run in parallel
- T012, T013, T014, T015, T016 (all tests) can run in parallel
- Within US1: T005 and T006 can run in parallel after T004 is complete
- Within US2: T009 and T010 can run in parallel after T008 is complete

---

## Parallel Example: Phase 1 (Setup)

```
# These two tasks modify different files — run in parallel:
T001: Add English localization keys in app_en.arb
T002: Add Arabic localization keys in app_ar.arb

# Then sequentially:
T003: Run flutter gen-l10n (depends on T001 + T002)
```

## Parallel Example: Phase 5 (Tests)

```
# All four test tasks modify different test groups — run in parallel:
T011: bloc_test for 404 in forgot_password_cubit_test.dart
T012: bloc_test for 403 in forgot_password_cubit_test.dart
T013: Widget test for sign-up link visibility in forgot_password_page_test.dart
T014: Widget test for sign-up link navigation in forgot_password_page_test.dartT016: Widget test for 403 toast Contact Support button in forgot_password_page_test.dart```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T003)
2. Complete Phase 2: User Story 1 (T004-T007)
3. **STOP and VALIDATE**: Test 404 handling and sign-up link independently
4. Deploy/demo if ready

### Full Feature

5. Complete Phase 3: User Story 2 (T008-T011)
6. Complete Phase 5: Tests and regression (T012-T018)
7. **DONE**: All acceptance scenarios verified
