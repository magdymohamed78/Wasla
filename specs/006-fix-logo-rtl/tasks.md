# Tasks: Fix Logo RTL Alignment

**Input**: Design documents from `/specs/006-fix-logo-rtl/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/, quickstart.md

**Tests**: Included — plan.md explicitly scopes widget tests to lock down RTL behavior and prevent regressions.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Phase 1: Setup

**Purpose**: Verify existing implementation and prepare test infrastructure

- [X] T001 Verify `_LogoGroup` in `lib/features/onboarding/presentation/pages/onboarding_page.dart` uses `Directionality(textDirection: TextDirection.ltr)` wrapper and is wrapped in `Center` — confirm no code change needed for logo positioning
- [X] T002 Create test directory structure at `test/features/onboarding/presentation/pages/` and empty test file `onboarding_page_test.dart` with flutter_test imports

---

## Phase 2: User Story 1 — Logo Stays LTR-Aligned in RTL Mode (Priority: P1) 🎯 MVP

**Goal**: Confirm and lock down that the Wasla logo group remains centered with internal LTR content order in both LTR and RTL modes.

**Independent Test**: Switch the app language to Arabic on the onboarding page and confirm the logo stays centered with "W" on the left and "ASLA" on the right.

### Tests for User Story 1

- [X] T003 [P] [US1] Write widget test verifying `_LogoGroup` renders "W" text with `dx` less than "ASLA" text `dx` when ambient direction is LTR, in `test/features/onboarding/presentation/pages/onboarding_page_test.dart`
- [X] T004 [P] [US1] Write widget test verifying `_LogoGroup` renders "W" text with `dx` less than "ASLA" text `dx` when ambient direction is RTL (wrapped in `Directionality(textDirection: TextDirection.rtl)`), in `test/features/onboarding/presentation/pages/onboarding_page_test.dart`
- [X] T005 [US1] Write widget test verifying `Directionality.of(context)` inside the logo subtree equals `TextDirection.ltr` regardless of ambient direction, in `test/features/onboarding/presentation/pages/onboarding_page_test.dart`

### Implementation for User Story 1

- [X] T006 [US1] Add dartdoc comment to `_LogoGroup` class in `lib/features/onboarding/presentation/pages/onboarding_page.dart` documenting the `Directionality(textDirection: TextDirection.ltr)` pattern and why it exists (brand elements must not mirror in RTL)

**Checkpoint**: At this point, User Story 1 is verified — logo stays LTR-aligned in both directions with tests locking down the behavior.

---

## Phase 3: User Story 2 — Textual Content Properly Mirrors in RTL (Priority: P2)

**Goal**: Confirm that all non-branding UI elements on the onboarding page (header, buttons, spacing) continue to mirror correctly in RTL mode alongside the logo fix.

**Independent Test**: Switch app to Arabic and verify header elements swap sides, button text displays in Arabic with RTL alignment, and directional spacing mirrors correctly.

### Tests for User Story 2

- [X] T007 [P] [US2] Write widget test verifying the onboarding header language selector and support icon swap positions when ambient direction is RTL vs LTR, in `test/features/onboarding/presentation/pages/onboarding_page_test.dart`
- [X] T008 [P] [US2] Write widget test verifying button labels render localized Arabic text and respond to RTL text direction when locale is Arabic, in `test/features/onboarding/presentation/pages/onboarding_page_test.dart`

**Checkpoint**: Both user stories verified — logo stays fixed, all other elements mirror correctly in RTL.

---

## Phase 4: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and cleanup

- [X] T009 Run all tests via `flutter test test/features/onboarding/presentation/pages/onboarding_page_test.dart` and confirm all pass
- [ ] T010 Run quickstart.md manual verification steps (launch app → switch to Arabic → verify logo → verify header → switch back to English → verify no flicker) *(manual — requires human execution)*

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **User Story 1 (Phase 2)**: Depends on T002 (test file created)
- **User Story 2 (Phase 3)**: Depends on T002 (test file created). Independent of User Story 1
- **Polish (Phase 4)**: Depends on all previous phases

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Setup — no dependencies on other stories
- **User Story 2 (P2)**: Can start after Setup — independent of User Story 1

### Within Each User Story

- Tests written first (T003–T005 for US1, T007–T008 for US2)
- Implementation/documentation tasks follow (T006)
- Tests marked [P] within the same story can run in parallel

### Parallel Opportunities

- T003 and T004 can run in parallel (independent test cases in same file)
- T007 and T008 can run in parallel (independent test cases in same file)
- User Story 1 and User Story 2 test tasks can proceed in parallel after T002 completes
- T001 and T002 can run in parallel (independent: verification vs file creation)

---

## Parallel Example: User Story 1

```bash
# Launch all US1 tests together (T003, T004 — parallel, different test cases):
Task: "Widget test: W.dx < ASLA.dx in LTR ambient direction"
Task: "Widget test: W.dx < ASLA.dx in RTL ambient direction"

# Then sequential:
Task: "Widget test: Directionality.of(context) == TextDirection.ltr inside logo"
Task: "Add dartdoc comment to _LogoGroup"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (verify + create test file)
2. Complete Phase 2: User Story 1 (tests + documentation)
3. **STOP and VALIDATE**: Run tests, manually verify logo in both LTR and RTL
4. Merge if ready — logo behavior is locked down

### Incremental Delivery

1. Complete Setup → Infrastructure ready
2. Add User Story 1 → Test independently → Logo verified (MVP!)
3. Add User Story 2 → Test independently → Full RTL compliance verified
4. Polish → All tests pass, manual verification complete

---

## Notes

- [P] tasks = different test cases or files, no dependencies
- [Story] label maps task to specific user story for traceability
- The current code already satisfies all functional requirements — tasks focus on verification, testing, and documentation
- No data model, Cubit, or navigation changes required
- Commit after each task or logical group
- Total tasks: 10 (2 setup, 4 US1, 2 US2, 2 polish)
