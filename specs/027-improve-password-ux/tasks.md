# Tasks: Enhance Password Field UX

**Input**: Design documents from `/specs/027-improve-password-ux/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/, quickstart.md

**Tests**: No explicit TDD/test-first requirement in the feature specification, so implementation tasks below focus on deliverable behavior and acceptance validation.

**Organization**: Tasks are grouped by user story to enable independent implementation and validation.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare dependencies and localization assets needed by password feedback UI.

- [x] T001 Add `flutter_password_strength_meter` dependency in pubspec.yaml
- [x] T002 [P] Add password-feedback localization keys in lib/core/localization/l10n/app_en.arb and lib/core/localization/l10n/app_ar.arb
- [x] T003 Regenerate localization outputs in lib/core/localization/l10n/AppLocalizations.dart, lib/core/localization/l10n/AppLocalizations_en.dart, and lib/core/localization/l10n/AppLocalizations_ar.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Implement reusable password-feedback primitives required by all stories.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [x] T004 Add reusable password-rule helper functions and canonical special-char set in lib/core/utils/validators.dart
- [x] T005 [P] Create password feedback models/enums in lib/features/auth/presentation/widgets/password_feedback_models.dart
- [x] T006 Create reusable PasswordRulesWidget API shell in lib/features/auth/presentation/widgets/password_rules_widget.dart
- [x] T007 [P] Create strength score band mapper (weak/medium/strong thresholds) in lib/features/auth/presentation/widgets/password_strength_mapper.dart

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - Real-Time Password Guidance (Priority: P1) 🎯 MVP

**Goal**: Show rule-by-rule password guidance directly under the Sign Up password field with real-time and blur-aware visual states.

**Independent Test**: In Sign Up, type and delete password characters and verify four rule indicators update instantly; unmet rules are grey while typing, red after blur, and met rules are green.

### Implementation for User Story 1

- [x] T008 [US1] Implement checklist row rendering and per-rule evaluation in lib/features/auth/presentation/widgets/password_rules_widget.dart
- [x] T009 [US1] Implement neutral/typing/blurred rule visual-state mapping in lib/features/auth/presentation/widgets/password_rules_widget.dart
- [x] T010 [US1] Insert PasswordRulesWidget directly under password TextFormField in lib/features/auth/presentation/widgets/sign_up_form.dart
- [x] T011 [US1] Pass state.password and blur/touch interaction state via BlocBuilder in lib/features/auth/presentation/widgets/sign_up_form.dart

**Checkpoint**: User Story 1 should be fully functional and independently verifiable.

---

## Phase 4: User Story 2 - Understand Password Strength (Priority: P2)

**Goal**: Add live strength meter and weak helper text with canonical score thresholds and color mapping.

**Independent Test**: Enter weak/medium/strong passwords in Sign Up and verify score band mapping, colors, hidden-on-empty behavior, and immediate weak helper text.

### Implementation for User Story 2

- [x] T012 [US2] Add password strength meter below rules list and hide it when password is empty in lib/features/auth/presentation/widgets/sign_up_form.dart
- [x] T013 [P] [US2] Apply canonical strength thresholds and color mapping in lib/features/auth/presentation/widgets/password_strength_mapper.dart
- [x] T014 [US2] Show weak helper text immediately for non-empty weak passwords in lib/features/auth/presentation/widgets/sign_up_form.dart
- [x] T015 [US2] Wire localized labels/messages for strength and helper text in lib/features/auth/presentation/widgets/sign_up_form.dart and lib/features/auth/presentation/widgets/password_rules_widget.dart

**Checkpoint**: User Stories 1 and 2 both work independently in Sign Up.

---

## Phase 5: User Story 3 - Preserve Existing Form Experience (Priority: P3)

**Goal**: Keep layout stable while making password feedback components reusable for login/reset contexts.

**Independent Test**: Compare Sign Up before/after behavior on supported sizes and verify only password section changed; verify new widget API is reusable without coupling to RegisterCubit internals.

### Implementation for User Story 3

- [x] T016 [US3] Preserve existing spacing and section boundaries while integrating password feedback in lib/features/auth/presentation/widgets/sign_up_form.dart
- [x] T017 [US3] Generalize PasswordRulesWidget input API for reuse in login/reset flows in lib/features/auth/presentation/widgets/password_rules_widget.dart
- [x] T018 [P] [US3] Create reusable PasswordFeedbackSection composition widget in lib/features/auth/presentation/widgets/password_feedback_section.dart
- [x] T019 [US3] Replace inline Sign Up password feedback block with PasswordFeedbackSection in lib/features/auth/presentation/widgets/sign_up_form.dart
- [x] T020 [US3] Keep existing submission and validation flow behavior intact while wiring feedback state in lib/features/auth/presentation/cubit/register_cubit.dart and lib/features/auth/presentation/cubit/register_state.dart

**Checkpoint**: All user stories should be functional without layout regressions.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency, validation, and implementation documentation updates.

- [x] T021 [P] Update implementation validation checklist in specs/027-improve-password-ux/quickstart.md
- [x] T022 Perform final design-token consistency pass in lib/features/auth/presentation/widgets/password_rules_widget.dart and lib/features/auth/presentation/widgets/sign_up_form.dart
- [x] T023 [P] Record RTL/LTR and small-screen overflow verification notes in specs/027-improve-password-ux/quickstart.md
- [x] T024 Sync final package/localization artifact references in pubspec.yaml and lib/core/localization/l10n/AppLocalizations.dart

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; starts immediately.
- **Foundational (Phase 2)**: Depends on Phase 1; blocks all user stories.
- **User Story Phases (Phase 3-5)**: Depend on Phase 2 completion.
- **Polish (Phase 6)**: Depends on completion of the selected user stories.

### User Story Dependencies

- **US1 (P1)**: Starts immediately after Foundational; no dependency on other stories.
- **US2 (P2)**: Starts after Foundational; can run independently but touches shared Sign Up feedback area.
- **US3 (P3)**: Starts after Foundational; finalizes reusable composition and regression-safe integration.

### Recommended Delivery Order

- Sequential MVP-first: US1 -> US2 -> US3.
- Parallel-capable team: US2 can start after US1 widget API stabilizes; US3 can start after US1 integration baseline is merged.

---

## Parallel Opportunities

- **Setup**: T002 can run in parallel with T001 after dependency decision is finalized.
- **Foundational**: T005 and T007 can run in parallel after T004 starts helper contract definition.
- **US2**: T013 can run in parallel with T012 because threshold mapping is isolated in a separate file.
- **US3**: T018 can run in parallel with T016/T017 because it is a new file-level composition.
- **Polish**: T021 and T023 can run in parallel as documentation validation tasks.

---

## Parallel Example: User Story 1

```bash
# US1 parallel-friendly split after foundational completion:
Task: "Implement checklist row rendering and per-rule evaluation in lib/features/auth/presentation/widgets/password_rules_widget.dart"
Task: "Prepare Sign Up insertion point for PasswordRulesWidget in lib/features/auth/presentation/widgets/sign_up_form.dart"
```

## Parallel Example: User Story 2

```bash
# US2 parallel work:
Task: "Apply canonical strength thresholds and color mapping in lib/features/auth/presentation/widgets/password_strength_mapper.dart"
Task: "Add strength meter and weak helper text rendering in lib/features/auth/presentation/widgets/sign_up_form.dart"
```

## Parallel Example: User Story 3

```bash
# US3 parallel work:
Task: "Create reusable PasswordFeedbackSection composition widget in lib/features/auth/presentation/widgets/password_feedback_section.dart"
Task: "Generalize PasswordRulesWidget API for reuse in lib/features/auth/presentation/widgets/password_rules_widget.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (US1).
3. Validate US1 independently in Sign Up.
4. Demo/ship MVP slice.

### Incremental Delivery

1. Deliver US1 for real-time checklist guidance.
2. Deliver US2 for strength and helper feedback.
3. Deliver US3 for reusability and regression-safe integration.
4. Finish with Phase 6 polish and validation records.

### Parallel Team Strategy

1. Team completes Setup + Foundational together.
2. One developer handles Sign Up integration tasks while another finalizes threshold mapping/localization wiring.
3. Reusability composition work starts once initial US1 baseline is stable.

---

## Notes

- Task format follows strict checklist syntax with IDs, optional `[P]`, and `[US#]` labels for story tasks.
- All tasks include concrete file paths.
- Tests were not added as explicit tasks because the feature specification did not request a TDD/test-first workflow.
