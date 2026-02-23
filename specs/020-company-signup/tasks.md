# Tasks: Customer Portal Sign Up Page

**Input**: Design documents from `/specs/020-company-signup/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/register-api.md, quickstart.md

**Tests**: Not explicitly requested in the feature specification. Test tasks are omitted.

**Organization**: Tasks are grouped by user story (US1–US6) to enable independent implementation and testing.

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Exact file paths included in descriptions

---

## Phase 1: Setup

**Purpose**: Add localization keys for all Sign Up page user-facing text (English + Arabic)

- [X] T001 Add signUp* English localization keys (25 keys) to lib/core/localization/l10n/app_en.arb
- [X] T002 [P] Add signUp* Arabic localization keys (25 keys) to lib/core/localization/l10n/app_ar.arb
- [X] T003 Regenerate localization files with `flutter gen-l10n`

Key list defined in research.md R8. Keys include: signUpTitle, signUpFirstName, signUpLastName, signUpPhoneNumber, signUpEmail, signUpEmailHint, signUpPassword, signUpConfirmPassword, signUpButton, signUpHaveAccount, signUpHaveAccountAction, signUpFirstNameRequired, signUpLastNameRequired, signUpNameTooLong, signUpPhoneTooLong, signUpEmailRequired, signUpEmailInvalid, signUpPasswordRequired, signUpPasswordTooShort, signUpConfirmPasswordRequired, signUpConfirmPasswordMismatch, signUpErrorEmailInUse, signUpErrorServer, signUpErrorNetwork, signUpErrorUnexpected.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Data layer, domain layer, and validation infrastructure required before any presentation work

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T004 [P] Create RegisterRequestModel with toJson() in lib/features/auth/data/models/register_request_model.dart
- [X] T005 [P] Add `register()` abstract method to AuthRepository interface in lib/features/auth/domain/repositories/auth_repository.dart
- [X] T006 [P] Add `validateName()`, `validatePhone()`, `validatePasswordLength()` static methods to Validators in lib/core/utils/validators.dart
- [X] T007 Add `register()` method to AuthRemoteDataSource abstract class and AuthRemoteDataSourceImpl (POST /api/customer-portal/register, returns LoginResponseModel) in lib/features/auth/data/data_sources/auth_remote_data_source.dart
- [X] T008 Add `register()` implementation to AuthRepositoryImpl — trim inputs, call remote, convert to entity, save token and user in lib/features/auth/data/repositories/auth_repository_impl.dart
- [X] T009 [P] Create RegisterUseCase with `call()` method delegating to AuthRepository.register() in lib/features/auth/domain/use_cases/register_use_case.dart

**Dependencies**: T007 depends on T004 (imports RegisterRequestModel). T008 depends on T005+T007. T009 depends on T005. T004, T005, T006 have no dependencies and can run in parallel. T007 and T009 can run in parallel after their respective dependencies.

**Checkpoint**: Data and domain layers ready — presentation layer work can begin

---

## Phase 3: User Story 1 — Successful Account Registration (Priority: P1) 🎯 MVP

**Goal**: User can open the Sign Up page, fill 6 form fields, submit registration, and be navigated to the home screen with a persisted session.

**Independent Test**: Navigate to Sign Up from login, fill all required fields with valid data, tap "Sign Up →", verify navigation to home screen.

### Implementation for User Story 1

- [X] T010 [P] [US1] Create RegisterState (immutable with copyWith), RegisterStatus enum, RegisterErrorCode enum, RegisterErrorCategory enum in lib/features/auth/presentation/cubit/register_state.dart
- [X] T011 [US1] Create RegisterCubit with register() flow, 6 field change handlers, validation methods, _extractErrorCode() for DioException mapping, toggle visibility methods, and _normalizeInput() in lib/features/auth/presentation/cubit/register_cubit.dart
- [X] T012 [P] [US1] Create SignUpPage with Scaffold (AppColors.background), SafeArea, LayoutBuilder, SingleChildScrollView, WaslaLogo + "ASLA" row, card container with BoxDecoration, "Sign Up" title, SignUpForm widget, and BlocListener for RegisterStatus.success → context.go(AppRouter.home) in lib/features/auth/presentation/pages/sign_up_page.dart
- [X] T013 [P] [US1] Create SignUpForm with BlocBuilder, 6 TextFormFields (First Name, Last Name, Phone Number, Email with hint, Password with obscureText, Confirm Password with obscureText), onChanged dispatching to cubit, and PrimaryButton calling cubit.register() in lib/features/auth/presentation/widgets/sign_up_form.dart
- [X] T014 [US1] Replace RegisterPlaceholderPage import with SignUpPage, wrap in BlocProvider\<RegisterCubit\> with RegisterUseCase and AuthRepository injection in lib/core/routing/app_router.dart
- [X] T015 [US1] Delete lib/features/auth/presentation/pages/register_placeholder_page.dart

**Dependencies**: T011 depends on T010 (imports RegisterState). T012 and T013 depend on T011 (import RegisterCubit) but can run in parallel with each other. T014 depends on T012. T015 depends on T014.

**Checkpoint**: Registration happy path works end-to-end. User can register and land on home screen.

---

## Phase 4: User Story 2 — Client-Side Form Validation (Priority: P1)

**Goal**: Validation error messages appear below fields after first submit attempt. Sign Up button is disabled until all required fields pass.

**Independent Test**: Enter invalid data (empty names, bad email, short password, mismatched confirm), verify error messages appear below each field and button stays disabled.

### Implementation for User Story 2

- [X] T016 [US2] Add validation error key-to-localized-message mapping methods (_mapNameError, _mapEmailError, _mapPasswordError, _mapConfirmPasswordError, _mapPhoneError) and wire errorText property on all 6 TextFormFields using RegisterState error fields in lib/features/auth/presentation/widgets/sign_up_form.dart
- [X] T017 [US2] Implement Sign Up button disabled logic — disable PrimaryButton onPressed when status is loading, any required field is empty, or any validation error exists in state, in lib/features/auth/presentation/widgets/sign_up_form.dart

**Checkpoint**: Client-side validation is fully functional. Invalid input is caught before API call.

---

## Phase 5: User Story 3 — Server-Side Error Handling (Priority: P2)

**Goal**: Server rejection messages (409, 400, 500, network) are displayed to the user — inline for field errors, snackbar for general errors — without losing form data.

**Independent Test**: Register with an already-used email, verify "This email is already registered" appears inline below the email field.

### Implementation for User Story 3

- [X] T018 [P] [US3] Add BlocListener to SignUpPage for RegisterStatus.failure with server/network errorCategory — show floating SnackBar with localized error message and retry action in lib/features/auth/presentation/pages/sign_up_page.dart
- [X] T019 [P] [US3] Wire 409 emailAlreadyRegistered error as inline errorText below Email field and 400 validationError server messages below relevant fields using RegisterState.errorCode and serverErrorMessage in lib/features/auth/presentation/widgets/sign_up_form.dart

**Dependencies**: T018 and T019 edit different files, can run in parallel.

**Checkpoint**: All server error scenarios display clear, actionable messages. Form data preserved on error.

---

## Phase 6: User Story 4 — Visual Consistency with Login Page (Priority: P2)

**Goal**: Sign Up page is visually indistinguishable from Login page in style — same background, card, logo, input fields, button, spacing, typography.

**Independent Test**: Place login and sign-up screenshots side by side and confirm matching visual elements.

### Implementation for User Story 4

- [X] T020 [US4] Audit and align SignUpPage and SignUpForm against LoginPage and LoginForm — verify identical BoxDecoration (borderRadius 20, blurRadius 60, offset 0/15), InputDecoration (divider border, brandRed focus, error border, contentPadding), PrimaryButton styling, spacing constants, and Directionality(ltr) on logo row in lib/features/auth/presentation/pages/sign_up_page.dart and lib/features/auth/presentation/widgets/sign_up_form.dart

**Checkpoint**: Visual parity with login page confirmed.

---

## Phase 7: User Story 5 — Password Visibility Toggle (Priority: P3)

**Goal**: Users can toggle password and confirm password visibility independently via eye icons.

**Independent Test**: Tap eye icon on password field, verify text becomes visible. Tap again, verify obscured. Repeat independently for confirm password.

### Implementation for User Story 5

- [X] T021 [US5] Add suffixIcon with IconButton (Icons.visibility_off_outlined / Icons.visibility_outlined) and onPressed calling cubit.togglePasswordVisibility() / cubit.toggleConfirmPasswordVisibility() to Password and Confirm Password TextFormFields in lib/features/auth/presentation/widgets/sign_up_form.dart

**Checkpoint**: Both password fields have independent visibility toggles matching login page eye icon styling.

---

## Phase 8: User Story 6 — Navigation Between Login and Sign Up (Priority: P3)

**Goal**: User can navigate from Sign Up page to Login page via a text link.

**Independent Test**: Tap "Already have an account? Log In" on Sign Up page, verify navigation to Login page.

### Implementation for User Story 6

- [X] T022 [US6] Add "Already have an account? Log In" row with TextButton navigating to AppRouter.login below the form inside the card container in lib/features/auth/presentation/pages/sign_up_page.dart

**Checkpoint**: Bidirectional navigation between Login and Sign Up pages works.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Final verification and cleanup

- [X] T023 [P] Run quickstart.md verification checklist — all 16 items must pass (navigation, form fields, validation, button state, toggle, registration, errors, RTL)
- [X] T024 Code cleanup — remove unused imports, verify no lint warnings from `flutter analyze`, add doc comments to public classes

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Stories (Phase 3–8)**: All depend on Foundational phase completion
  - Must proceed sequentially P1 → P2 → P3 since later stories modify files created in earlier stories
- **Polish (Phase 9)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) — creates all presentation files
- **User Story 2 (P1)**: Depends on US1 — adds error display and button logic to existing form
- **User Story 3 (P2)**: Depends on US1 — adds snackbar listener to page and server error display to form
- **User Story 4 (P2)**: Depends on US1+US2+US3 — audits visual parity after all functional code is in place
- **User Story 5 (P3)**: Depends on US1 — adds eye icons to existing password fields
- **User Story 6 (P3)**: Depends on US1 — adds navigation link to existing page

### Within Each User Story

- State classes before cubits
- Cubits before pages/forms
- Pages and forms can be created in parallel
- Route wiring after page creation
- Placeholder deletion after route wiring

### Parallel Opportunities

```
# Phase 1 — parallel:
T001 (app_en.arb) ‖ T002 (app_ar.arb)

# Phase 2 — batch 1 (parallel):
T004 (RegisterRequestModel) ‖ T005 (AuthRepository) ‖ T006 (Validators)
# Phase 2 — batch 2 (parallel, after batch 1):
T007 (AuthRemoteDataSource) ‖ T009 (RegisterUseCase)
# Phase 2 — batch 3 (sequential):
T008 (AuthRepositoryImpl)

# Phase 3 US1 — batch 1:
T010 (RegisterState)
# Phase 3 US1 — batch 2:
T011 (RegisterCubit)
# Phase 3 US1 — batch 3 (parallel):
T012 (SignUpPage) ‖ T013 (SignUpForm)
# Phase 3 US1 — batch 4:
T014 (app_router) → T015 (delete placeholder)

# Phase 5 US3 — parallel:
T018 (snackbar in page) ‖ T019 (inline errors in form)

# Phase 9 — parallel:
T023 (verification) ‖ T024 (cleanup)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (localization keys)
2. Complete Phase 2: Foundational (data + domain layers)
3. Complete Phase 3: User Story 1 (registration happy path)
4. **STOP and VALIDATE**: User can register and reach home screen
5. Demo/deploy if ready

### Incremental Delivery

1. Setup + Foundational → Infrastructure ready
2. Add US1 → Registration works → **MVP!**
3. Add US2 → Validation errors displayed, button disabled until valid
4. Add US3 → Server error messages shown (409 inline, 500 snackbar)
5. Add US4 → Visual parity verified against login page
6. Add US5 → Password visibility toggles
7. Add US6 → "Already have account?" navigation link
8. Polish → Verification + cleanup

### Key Technical Decisions (from research.md)

| # | Decision |
|---|----------|
| R1 | Reuse LoginEntity + LoginResponseModel for register response (same API schema) |
| R2 | Mixed error display: field-specific inline, general as snackbar |
| R3 | Extend shared Validators class; lazy validation pattern matching login |
| R4 | Separate RegisterCubit + RegisterState (not shared with LoginCubit) |
| R5 | SignUpPage/Form mirrors LoginPage/Form widget structure exactly |
| R6 | Reuse AuthLocalDataSource session persistence (same token + user storage) |
| R7 | Replace placeholder route; BlocProvider in route builder |
| R8 | signUp* prefixed ARB keys for EN + AR localization |

---

## Notes

- [P] tasks = different files, no dependencies on each other
- [USn] label maps task to specific user story for traceability
- Each user story is independently testable after completion
- Commit after each task or logical group
- No new pub dependencies needed — all packages already in pubspec.yaml
- RegisterCubit built complete in US1 (all methods) — later stories only edit presentation files
- LoginEntity and LoginResponseModel reused — no new entity/response model files
