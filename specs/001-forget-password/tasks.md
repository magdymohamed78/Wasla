# Tasks: Forget Password Page

**Input**: Design documents from `/specs/001-forget-password/`
**Prerequisites**: plan.md, spec.md, data-model.md, contracts/ui-contract.md, quickstart.md

**Tests**: Not explicitly requested in spec. Test tasks are included for completeness but marked as optional.

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

Flutter mobile app structure:
- `lib/` - Source code
- `test/` - Test files
- `assets/` - Static assets

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add localization keys and verify asset availability

- [x] T001 Verify illustration asset exists at `assets/images/forget password.png`
- [x] T002 [P] Add English localization keys to `lib/core/localization/l10n/AppLocalizations_en.dart`
- [x] T003 [P] Add Arabic localization keys to `lib/core/localization/l10n/AppLocalizations_ar.dart`
- [x] T004 Add abstract getters to `lib/core/localization/l10n/AppLocalizations.dart`

---

## Phase 2: Foundational (State Management)

**Purpose**: Create Cubit and State classes that all user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T005 Create ForgotPasswordStatus enum and ForgotPasswordState class in `lib/features/auth/presentation/cubit/forgot_password_state.dart`
- [x] T006 Create ForgotPasswordCubit with emailChanged, submit, resetAfterToast methods in `lib/features/auth/presentation/cubit/forgot_password_cubit.dart`

**Checkpoint**: State management ready - UI implementation can now begin

---

## Phase 3: User Story 1 - Request Password Reset (Priority: P1) 🎯 MVP

**Goal**: User navigates from Login page, enters valid email, clicks Send, sees success toast

**Independent Test**: Navigate to page via "Forgot Password?" link, enter valid email, click Send, verify toast appears

### Tests for User Story 1 (OPTIONAL)

- [x] T007 [P] [US1] Create widget test for page rendering in `test/features/auth/presentation/pages/forgot_password_page_test.dart`
- [x] T008 [P] [US1] Create cubit test for submit flow in `test/features/auth/presentation/cubit/forgot_password_cubit_test.dart`

### Implementation for User Story 1

- [x] T009 [US1] Create ForgotPasswordForm widget with email field and Send button in `lib/features/auth/presentation/widgets/forgot_password_form.dart`
- [x] T010 [US1] Create ForgotPasswordPage with BlocProvider, BlocListener for toast, centered card layout in `lib/features/auth/presentation/pages/forgot_password_page.dart`
- [x] T011 [US1] Implement success toast display using ScaffoldMessenger.showSnackBar
- [x] T012 [US1] Add WASLA logo header with WaslaLogo widget
- [x] T013 [US1] Add illustration with Image.asset and errorBuilder for graceful degradation

**Checkpoint**: User Story 1 complete - basic page flow works independently

---

## Phase 4: User Story 2 - Form Validation Feedback (Priority: P2)

**Goal**: User sees clear error messages for empty and invalid email inputs, Send button disabled when invalid

**Independent Test**: Enter empty/invalid emails and verify appropriate error messages appear, verify button state changes

### Tests for User Story 2 (OPTIONAL)

- [x] T014 [P] [US2] Add validation error tests to `test/features/auth/presentation/cubit/forgot_password_cubit_test.dart`

### Implementation for User Story 2

- [x] T015 [US2] Implement real-time email validation using Validators.validateEmail in cubit emailChanged method
- [x] T016 [US2] Display validation error below email field in ForgotPasswordForm
- [x] T017 [US2] Disable Send button when email is empty or invalid (light gray background)
- [x] T018 [US2] Enable Send button only when email is valid (red background)
- [x] T019 [US2] Disable button during toast display to prevent duplicate submissions

**Checkpoint**: User Story 2 complete - validation feedback works independently

---

## Phase 5: User Story 3 - Responsive Mobile Experience (Priority: P3)

**Goal**: Page displays correctly on all screen sizes from 320px mobile to 1920px desktop

**Independent Test**: View page on various screen sizes, verify card remains centered and properly sized

### Tests for User Story 3 (OPTIONAL)

- [x] T020 [P] [US3] Add responsive layout tests to `test/features/auth/presentation/pages/forgot_password_page_test.dart`

### Implementation for User Story 3

- [x] T021 [US3] Use LayoutBuilder + ConstrainedBox for responsive card centering
- [x] T022 [US3] Set card max-width to 400px with 24px padding
- [x] T023 [US3] Make illustration responsive with fixed height and center alignment
- [x] T024 [US3] Add SingleChildScrollView for small screen scrolling
- [x] T025 [US3] Apply 20px border-radius and soft shadow to card container

**Checkpoint**: User Story 3 complete - responsive design works independently

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Accessibility, keyboard navigation, and final refinements

- [x] T026 [P] Add autofocus to email field on page load
- [x] T027 [P] Add autofillHints for email field
- [x] T028 Add Enter key submission support via textInputAction
- [x] T029 [P] Add semantic labels for accessibility (logo, illustration, button)
- [x] T030 Verify all localization keys work in both English and Arabic
- [x] T031 Run `flutter analyze` and fix any issues
- [x] T032 Run `flutter test` and verify all tests pass

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-5)**: All depend on Foundational phase completion
  - User stories can proceed sequentially in priority order (P1 → P2 → P3)
- **Polish (Phase 6)**: Depends on User Story 1 being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - MVP
- **User Story 2 (P2)**: Builds on US1 - validation enhances the email field
- **User Story 3 (P3)**: Enhances US1 layout - responsive design

### Within Each User Story

- Tests (optional) before implementation
- Form widget before page widget
- Page widget before integration
- Story complete before moving to next priority

### Parallel Opportunities

- T002, T003 (English and Arabic localizations) can run in parallel
- T007, T008 (test files) can run in parallel
- T014, T020 (additional test tasks) can run in parallel
- T026, T027, T029 (polish tasks in different areas) can run in parallel

---

## Parallel Example: Phase 1

```bash
# Launch localization tasks together:
Task: "Add English localization keys to lib/core/localization/l10n/AppLocalizations_en.dart"
Task: "Add Arabic localization keys to lib/core/localization/l10n/AppLocalizations_ar.dart"
```

## Parallel Example: User Story 1 Tests

```bash
# Launch tests together:
Task: "Create widget test in test/features/auth/presentation/pages/forgot_password_page_test.dart"
Task: "Create cubit test in test/features/auth/presentation/cubit/forgot_password_cubit_test.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (localization keys)
2. Complete Phase 2: Foundational (Cubit/State)
3. Complete Phase 3: User Story 1 (basic page flow)
4. **STOP and VALIDATE**: Navigate to page, enter valid email, see toast
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → State management ready
2. Add User Story 1 → Test toast flow → Deploy (MVP!)
3. Add User Story 2 → Test validation → Deploy
4. Add User Story 3 → Test responsive → Deploy
5. Polish → Accessibility + final checks → Deploy

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Tests are optional - spec did not explicitly request TDD
- The existing `forgot_password_placeholder_page.dart` will be replaced
- Routing already configured in `app_router.dart` (no changes needed)
- Asset `assets/images/forget password.png` already exists
- Use existing `Validators.validateEmail` from `lib/core/utils/validators.dart`
- Use existing theme: `AppColors`, `AppTypography`, `AppDimensions`
- Use existing widgets: `WaslaLogo`, `PrimaryButton` pattern
