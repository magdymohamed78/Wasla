# Tasks: Fix Login Navigation to Home Screen

**Input**: Design documents from `/specs/019-fix-login-navigation/`  
**Prerequisites**: plan.md ✓, spec.md ✓, research.md ✓, data-model.md ✓, quickstart.md ✓

**Tests**: Not explicitly requested in the feature specification. Test tasks are omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup

**Purpose**: No new project setup needed — this is a bug fix in an existing codebase. This phase ensures the working environment is ready.

- [X] T001 Verify clean build with `flutter analyze` and `flutter test` from repository root

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core fix that unblocks all user stories — the `getUser()` null-check bug

**⚠️ CRITICAL**: This is the primary bug fix. No user story validation is possible until this is complete.

- [X] T002 Fix `getUser()` to treat `customerId` as optional in `lib/features/auth/data/data_sources/auth_local_data_source.dart` — remove `customerId == null` from the required-fields null check (line ~69) and pass `customerId` as nullable to the `LoginEntity` constructor

**Checkpoint**: After T002, the session read-back correctly returns a valid `LoginEntity` even when `customerId` is null. The redirect loop is broken.

---

## Phase 3: User Story 1 — Successful Login Navigates to Home (Priority: P1) 🎯 MVP

**Goal**: After entering valid credentials and receiving a successful backend response, the user is automatically navigated to the Home screen.

**Independent Test**: Log in with valid credentials → Home screen appears → back button does NOT return to login.

### Implementation for User Story 1

- [X] T003 [US1] Verify navigation listener fires on `LoginStatus.success` in `lib/features/auth/presentation/pages/login_page.dart` — confirm `context.go(AppRouter.home)` is called (already implemented; manual QA verification after T002)
- [X] T004 [US1] Verify session save completes before success emit in `lib/features/auth/presentation/cubit/login_cubit.dart` — confirm `await _authRepository.saveSession(user)` precedes `emit(state.copyWith(status: LoginStatus.success))` (already correct; code review verification)
- [ ] T005 [US1] Manual QA: run the app, log in with valid credentials, and confirm navigation to Home screen within 2 seconds of response
- [ ] T006 [US1] Manual QA: on Home screen after login, press system back button and confirm user is NOT returned to login screen

**Checkpoint**: User Story 1 is fully functional — login → home navigation works end-to-end.

---

## Phase 4: User Story 2 — Session Persistence After Navigation (Priority: P2)

**Goal**: After login and navigation to Home, the stored session is complete and valid, preventing redirect loops from the route guard.

**Independent Test**: Log in → arrive at Home → verify stored session contains token, userId, firstName, lastName, email. Verify route guard does NOT redirect back to login.

### Implementation for User Story 2

- [X] T007 [US2] Verify Home route redirect guard in `lib/core/routing/app_router.dart` — confirm `getStoredSession()` returns non-null with the fixed `getUser()` from T002 (code review + manual QA)
- [ ] T008 [US2] Manual QA: after successful login and navigation to Home, force-close and reopen the app — confirm the app recognizes the persisted session (does not show login again)

**Checkpoint**: Session is fully persisted and route guard recognizes it — no redirect loops.

---

## Phase 5: User Story 3 — Loading Indicator During Login (Priority: P3)

**Goal**: A loading indicator is visible during the login request, and the login button is disabled to prevent duplicate submissions.

**Independent Test**: Press login button → see loading state → button disabled → navigation or error clears the indicator.

### Implementation for User Story 3

- [X] T009 [US3] Verify loading state is shown during login in `lib/features/auth/presentation/widgets/login_form.dart` — confirm the button is disabled when `state.status == LoginStatus.loading` (already implemented; code review verification)
- [ ] T010 [US3] Manual QA: press login button and verify loading indicator appears until navigation completes or error is shown
- [ ] T011 [US3] Manual QA: rapid-tap the login button and confirm only one request is processed (no duplicate submissions)

**Checkpoint**: Loading feedback works correctly through the full login → navigate flow.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and cleanup

- [X] T012 Run `flutter analyze` to confirm no new warnings or errors
- [X] T013 Run `flutter test` to confirm all existing tests still pass
- [ ] T014 Run quickstart.md verification steps end-to-end

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Setup — **BLOCKS all user stories**
- **User Story 1 (Phase 3)**: Depends on Foundational (T002)
- **User Story 2 (Phase 4)**: Depends on Foundational (T002) — can run in parallel with US1
- **User Story 3 (Phase 5)**: Depends on Foundational (T002) — can run in parallel with US1/US2
- **Polish (Phase 6)**: Depends on all user stories being verified

### User Story Dependencies

- **User Story 1 (P1)**: Depends only on T002 (foundational fix). No dependencies on other stories.
- **User Story 2 (P2)**: Depends only on T002. Independent of US1 but validates the same fix from a different angle.
- **User Story 3 (P3)**: Depends only on T002. Fully independent — verifies pre-existing loading behavior through the now-working flow.

### Within Each User Story

- Code review / verification tasks before manual QA tasks
- Manual QA confirms the behavioral outcome

### Parallel Opportunities

After T002 is complete, all three user stories (Phases 3-5) can be verified in parallel since they touch different aspects of the same fix:

```text
T002 (foundational fix) ──┬── US1: T003, T004, T005, T006  (navigation works)
                          ├── US2: T007, T008              (session persists)
                          └── US3: T009, T010, T011         (loading indicator)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete T001: Verify clean build
2. Complete T002: Fix `getUser()` null check **(THE FIX)**
3. Complete T003-T006: Verify login → home navigation
4. **STOP and VALIDATE**: Login navigation works
5. Proceed to US2/US3 for completeness

### Summary

- **Total tasks**: 14
- **Actual code change**: 1 task (T002) — surgical one-file fix
- **Verification tasks**: 10 tasks (code review + manual QA)
- **Build validation**: 3 tasks (T001, T012, T013)

---

## Notes

- This is a **bug fix**, not a feature build — the primary code change is a single null-check correction in `auth_local_data_source.dart`
- Most tasks are verification/QA because the navigation, state management, and session save logic are already correctly implemented
- The root cause (documented in research.md) is a field nullability mismatch: `customerId` is `int?` in the domain entity but treated as required in `getUser()`
- No API changes, no new dependencies, no architectural modifications
- Commit after T002 (the fix) and again after full verification (T014)
