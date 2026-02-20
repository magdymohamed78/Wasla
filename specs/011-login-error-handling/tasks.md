# Tasks: Login Error Response Handling

**Input**: Design documents from `/specs/011-login-error-handling/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Not explicitly requested in spec — test tasks are omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Mobile (Flutter)**: `lib/features/auth/presentation/` for source, `test/features/auth/` for tests

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: No new project setup needed — this feature modifies existing files only. This phase establishes the foundational state and enum that all user stories depend on.

- [X] T001 Add `LoginErrorCategory` enum (`credentials`, `accountLink`, `rateLimit`, `server`, `network`) to `lib/features/auth/presentation/cubit/login_state.dart`
- [X] T002 Add `errorCategory`, `isRateLimited`, and `rateLimitRemainingSeconds` fields to `LoginState` class and update `copyWith()` in `lib/features/auth/presentation/cubit/login_state.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core error mapping infrastructure in `LoginCubit` that ALL user stories depend on.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T003 Split the combined 400/401 branch in `_extractErrorMessage()` into separate `case 400` and `case 401` handlers in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T004 Refactor `_extractErrorMessage()` to return both error message and `LoginErrorCategory` (e.g., return a record `({String message, LoginErrorCategory category})`) in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T005 Update `login()` method's catch block to emit `errorCategory` alongside `errorMessage` when calling `state.copyWith()` in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T006 Update `emailChanged()` and `passwordChanged()` to clear `errorCategory`, `isRateLimited`, and `rateLimitRemainingSeconds` when resetting status to `initial` in `lib/features/auth/presentation/cubit/login_cubit.dart`

**Checkpoint**: Foundation ready — error category is emitted with every failure state. User story implementation can now begin.

---

## Phase 3: User Story 1 — Display Invalid Credentials Error (Priority: P1) 🎯 MVP

**Goal**: Map HTTP 401 to snackbar message "Invalid credentials or inactive account." with no retry button.

**Independent Test**: Enter wrong credentials → snackbar shows correct message, no retry button, Sign In stays enabled.

### Implementation for User Story 1

- [X] T007 [US1] Update `case 401` in `_extractErrorMessage()` to return message `"Invalid credentials or inactive account."` with category `credentials` in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T008 [US1] Update `_showErrorSnackBar()` to hide the Retry button when `errorCategory` is `credentials` in `lib/features/auth/presentation/pages/login_page.dart`
- [X] T009 [US1] Change snackbar `duration` from `Duration(seconds: 5)` to `Duration(seconds: 4)` in `lib/features/auth/presentation/pages/login_page.dart`

**Checkpoint**: HTTP 401 → correct snackbar message, no retry, 4-second dismiss. MVP functional.

---

## Phase 4: User Story 2 — Display Unlinked Account Error (Priority: P1)

**Goal**: Map HTTP 400 to friendly message "Your account is not fully set up. Please contact support for help." with no retry button.

**Independent Test**: Log in with unlinked account → snackbar shows friendly message with support guidance.

### Implementation for User Story 2

- [X] T010 [US2] Update `case 400` in `_extractErrorMessage()` to return hardcoded message `"Your account is not fully set up. Please contact support for help."` with category `accountLink` (ignoring server message) in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T011 [US2] Ensure `_showErrorSnackBar()` hides Retry button when `errorCategory` is `accountLink` in `lib/features/auth/presentation/pages/login_page.dart`

**Checkpoint**: HTTP 400 → friendly message with support guidance, no retry.

---

## Phase 5: User Story 3 — Handle Rate Limiting (Priority: P1)

**Goal**: Map HTTP 429 to rate-limit message, disable Sign In button for 15 seconds with countdown timer.

**Independent Test**: Trigger 429 → snackbar shows rate-limit message, Sign In disabled for 15s, re-enables after cooldown.

### Implementation for User Story 3

- [X] T012 [US3] Update `case 429` in `_extractErrorMessage()` to return message `"Too many login attempts. Please try again later."` with category `rateLimit` in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T013 [US3] Add `Timer? _cooldownTimer` field and `_startRateLimitCooldown()` method that starts a `Timer.periodic(Duration(seconds: 1))` counting down from 15, emitting updated `rateLimitRemainingSeconds` each tick, and setting `isRateLimited: false` when reaching 0, in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T014 [US3] Call `_startRateLimitCooldown()` from the `login()` catch block when a 429 error category is detected, and emit `isRateLimited: true, rateLimitRemainingSeconds: 15` in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T015 [US3] Override `close()` to cancel `_cooldownTimer` before calling `super.close()` in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T016 [US3] Add guard in `login()` to return early if `state.isRateLimited == true` in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T017 [US3] Disable Sign In button when `state.isRateLimited == true` by adding an `isRateLimited` condition to the `onPressed` null check in `lib/features/auth/presentation/widgets/login_form.dart`
- [X] T018 [US3] Ensure `_showErrorSnackBar()` hides Retry button when `errorCategory` is `rateLimit` in `lib/features/auth/presentation/pages/login_page.dart`

**Checkpoint**: HTTP 429 → rate-limit message, 15-second cooldown with button disable, auto-re-enable.

---

## Phase 6: User Story 4 — Handle Unexpected Server Errors (Priority: P2)

**Goal**: Map HTTP 500 (and unknown status codes) to generic error message with retry button.

**Independent Test**: Simulate 500 → snackbar shows generic error with retry button that re-submits login.

### Implementation for User Story 4

- [X] T019 [US4] Update `case 500` (and 502, 503) in `_extractErrorMessage()` to return message `"An unexpected error occurred. Please try again later."` with category `server` in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T020 [US4] Update the `default` case in `_extractErrorMessage()` to return the generic fallback message with category `server` for unknown status codes in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T021 [US4] Update the catch-all `catch (e, stackTrace)` block in `login()` to emit category `server` with generic message for non-DioException errors in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T022 [US4] Ensure `_showErrorSnackBar()` shows the Retry button when `errorCategory` is `server` in `lib/features/auth/presentation/pages/login_page.dart`
- [X] T023 [US4] Handle malformed/empty response bodies — if `responseData` is null or not a Map, use generic fallback with category `server` in `lib/features/auth/presentation/cubit/login_cubit.dart`

**Checkpoint**: HTTP 500, unknown codes, and malformed responses → generic error with retry.

---

## Phase 7: User Story 5 — Handle Network Connectivity Errors (Priority: P2)

**Goal**: Map network failures to specific network error message with retry button.

**Independent Test**: Disable network → snackbar shows "No internet connection..." with retry button.

### Implementation for User Story 5

- [X] T024 [US5] Unify all network-related `DioExceptionType` cases (`connectionError`, `connectionTimeout`, `sendTimeout`, `receiveTimeout`) to return message `"No internet connection. Please check your network and try again."` with category `network` in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T025 [US5] Update the `DioExceptionType.unknown` case to check for `SocketException`/`Connection refused` and return network category with the network error message in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [X] T026 [US5] Ensure `_showErrorSnackBar()` shows the Retry button when `errorCategory` is `network` in `lib/features/auth/presentation/pages/login_page.dart`

**Checkpoint**: All network failures → network-specific message with retry. All 5 user stories complete.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Error handling edge cases and validation across all user stories.

- [X] T027 [P] Update `BlocListener.listenWhen` in `LoginPage` to pass `errorCategory` to `_showErrorSnackBar()` by reading it from `state.errorCategory` in `lib/features/auth/presentation/pages/login_page.dart`
- [X] T028 [P] Ensure `ScaffoldMessenger.of(context).clearSnackBars()` is called before showing new snackbar (already in place — verify FR-013) in `lib/features/auth/presentation/pages/login_page.dart`
- [X] T029 Verify error messages display correctly in RTL layout by checking `Directionality` is inherited (FR-014) in `lib/features/auth/presentation/pages/login_page.dart`
- [X] T030 Run quickstart.md manual verification scenarios (all 6 test cases)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 — BLOCKS all user stories
- **User Stories (Phases 3–7)**: All depend on Phase 2 completion
  - US1 (Phase 3), US2 (Phase 4), US3 (Phase 5) can proceed in parallel after Phase 2
  - US4 (Phase 6), US5 (Phase 7) can proceed in parallel after Phase 2
- **Polish (Phase 8)**: Depends on all user story phases being complete

### User Story Dependencies

- **US1 (P1)**: After Phase 2 — no dependencies on other stories
- **US2 (P1)**: After Phase 2 — no dependencies on other stories
- **US3 (P1)**: After Phase 2 — no dependencies on other stories
- **US4 (P2)**: After Phase 2 — no dependencies on other stories
- **US5 (P2)**: After Phase 2 — no dependencies on other stories

### Within Each User Story

- Cubit changes before UI changes (state must emit before page can react)
- Error mapping before display logic

### Parallel Opportunities

- T001 and T002 are sequential (same file, T002 depends on T001's enum)
- T003–T006 are sequential (same file, dependent changes)
- Within Phase 3: T007 before T008/T009 (state before UI)
- Within Phase 5: T012 → T013 → T014 → T015 → T016 (sequential, same file); T017 and T018 parallel (different files)
- Within Phase 6: T019/T020/T021/T023 sequential (same file); T022 parallel (different file)
- Within Phase 7: T024/T025 sequential (same file); T026 parallel (different file)
- T027, T028, T029 can run in parallel (different concerns, same file but independent sections)

---

## Parallel Example: User Story 3 (Rate Limiting)

```bash
# Sequential in cubit (same file):
T012 → T013 → T014 → T015 → T016

# Then parallel (different files):
T017 (login_form.dart)  |  T018 (login_page.dart)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Add `LoginErrorCategory` enum and state fields (T001–T002)
2. Complete Phase 2: Refactor `_extractErrorMessage()` to return category (T003–T006)
3. Complete Phase 3: Map 401 error and update snackbar (T007–T009)
4. **STOP and VALIDATE**: Enter wrong credentials → snackbar shows "Invalid credentials or inactive account." with no retry, auto-dismisses in 4 seconds

### Incremental Delivery

1. Setup + Foundational (T001–T006) → Error category infrastructure ready
2. Add US1 (T007–T009) → 401 credentials error handled → **MVP!**
3. Add US2 (T010–T011) → 400 unlinked account error handled
4. Add US3 (T012–T018) → 429 rate-limit with cooldown handled
5. Add US4 (T019–T023) → 500 server errors with retry handled
6. Add US5 (T024–T026) → Network errors with retry handled
7. Polish (T027–T030) → Edge cases and validation
8. Each story adds value without breaking previous stories

### Suggested Single-Developer Flow

Because most tasks modify the same 4 files, the practical flow is:
1. T001–T006: All state + cubit foundation changes
2. T007, T010, T012–T016, T019–T021, T023–T025: All cubit error mapping (one pass through `_extractErrorMessage()`)
3. T008–T009, T011, T018, T022, T026–T029: All login_page.dart snackbar changes (one pass)
4. T017: login_form.dart button disable
5. T030: Manual verification

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- No new files added to `lib/` — all changes modify existing presentation-layer files
- 4 files modified: `login_state.dart`, `login_cubit.dart`, `login_page.dart`, `login_form.dart`
- Commit after each phase or logical group
- Stop at any checkpoint to validate story independently
