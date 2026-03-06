# Tasks: Forgot Password Flow – UI + API Implementation

**Input**: Design documents from `/specs/024-forgot-password-flow/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Not explicitly requested in the feature specification — test tasks are omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add shared utilities, route constants, and localization keys needed by all user stories

- [x] T001 Add otpVerification and changePassword static route path constants in lib/core/routing/app_router.dart
- [x] T002 [P] Add validateOtp (exactly 6 digits) and validatePasswordMatch (returns error if mismatch) methods to lib/core/utils/validators.dart
- [x] T003 [P] Add English localization keys for all three forgot password flow screens (OTP screen title/description/timer/resend/verify, Change Password screen title/description/fields/confirm, error messages for rate-limit/network/expired-OTP/password-policy, success toast) in lib/core/localization/app_en.arb
- [x] T004 [P] Add Arabic localization keys matching T003 in lib/core/localization/app_ar.arb

---

## Phase 2: Foundational (Data + Domain Layer)

**Purpose**: Request models, data source methods, repository contracts, and use cases that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T005 [P] Create ForgotPasswordRequestModel with email field and toJson() in lib/features/auth/data/models/forgot_password_request_model.dart
- [x] T006 [P] Create ResendOtpRequestModel with email field and toJson() in lib/features/auth/data/models/resend_otp_request_model.dart
- [x] T007 [P] Create ResetPasswordRequestModel with email, otp, newPassword, confirmNewPassword fields and toJson() in lib/features/auth/data/models/reset_password_request_model.dart
- [x] T008 Add forgotPassword(), resendOtp(), resetPassword() methods using Dio POST with debugPrint logging following existing login() pattern in lib/features/auth/data/data_sources/auth_remote_data_source.dart
- [x] T009 Add forgotPassword(), resendOtp(), resetPassword() abstract method signatures to lib/features/auth/domain/repositories/auth_repository.dart
- [x] T010 Implement forgotPassword(), resendOtp(), resetPassword() delegating to AuthRemoteDataSource in lib/features/auth/data/repositories/auth_repository_impl.dart
- [x] T011 [P] Create ForgotPasswordUseCase with call({required String email}) returning Future<void> in lib/features/auth/domain/use_cases/forgot_password_use_case.dart
- [x] T012 [P] Create ResendOtpUseCase with call({required String email}) returning Future<void> in lib/features/auth/domain/use_cases/resend_otp_use_case.dart
- [x] T013 [P] Create ResetPasswordUseCase with call({required String email, otp, newPassword, confirmNewPassword}) returning Future<void> in lib/features/auth/domain/use_cases/reset_password_use_case.dart

**Checkpoint**: Foundation ready — all data/domain layers in place; user story implementation can now begin

---

## Phase 3: User Story 1 — Request OTP via Email (Priority: P1) 🎯 MVP

**Goal**: User enters email on the Forgot Password screen, presses Send, API is called, and user navigates to OTP Verification screen with email passed forward.

**Independent Test**: Navigate from Login → Forgot Password, enter a valid email, press Send, verify navigation to OTP screen with email carried through.

### Implementation for User Story 1

- [x] T014 [US1] Update ForgotPasswordStatus enum to include loading and failure values, add errorMessage field, update copyWith() in lib/features/auth/presentation/cubit/forgot_password_state.dart
- [x] T015 [US1] Refactor ForgotPasswordCubit: inject ForgotPasswordUseCase via constructor, replace Future.delayed stub in submit() with real API call, add DioException handling for 429 and network errors following LoginCubit error pattern in lib/features/auth/presentation/cubit/forgot_password_cubit.dart
- [x] T016 [US1] Update ForgotPasswordForm: show CircularProgressIndicator on Send button during loading state, display error message below form on failure, disable button during API call in lib/features/auth/presentation/widgets/forgot_password_form.dart
- [x] T017 [US1] Update ForgotPasswordPage BlocListener: replace snackbar-on-success with navigation to OTP screen via context.push(AppRouter.otpVerification, extra: email) on success state in lib/features/auth/presentation/pages/forgot_password_page.dart

**Checkpoint**: User Story 1 fully functional — user can request OTP and navigate to Screen B

---

## Phase 4: User Story 2 — Verify OTP Code (Priority: P1)

**Goal**: User enters 6-digit OTP on the verification screen with a 60-second countdown timer, can resend OTP, and navigates to Change Password screen with email and OTP passed forward.

**Independent Test**: Enter a 6-digit OTP, press Verify, verify navigation to Change Password screen. Test resend by waiting for timer to expire and pressing Resend OTP.

### Implementation for User Story 2

- [x] T018 [P] [US2] Create OtpVerificationState with email, otpDigits (List<String>), status enum (initial/success/failure), timerRemainingSeconds, isResending, errorMessage, derived canResend and isComplete getters, and copyWith() in lib/features/auth/presentation/cubit/otp_verification_state.dart
- [x] T019 [US2] Create OtpVerificationCubit with: init(email) to start 60s Timer.periodic countdown, digitEntered(index, value) for auto-advance, digitRemoved(index) for backspace, pasteOtp(String) to fill all 6 boxes, verify() to emit success with concatenated OTP, resendOtp() calling ResendOtpUseCase with DioException handling for 429, timer cancel in close() — in lib/features/auth/presentation/cubit/otp_verification_cubit.dart
- [x] T020 [P] [US2] Create OtpInputField stateful widget with 6 TextFormField controllers and FocusNodes: auto-advance on digit entry, backspace moves to previous box, paste detection fills all 6 boxes, visual states (default/focused/filled/error borders), ~40-44px square sizing with ~10-12px gap, onChanged and onCompleted callbacks — in lib/features/auth/presentation/widgets/otp_input_field.dart
- [x] T021 [US2] Create OtpVerificationForm using BlocBuilder: render OtpInputField wired to cubit, countdown timer text below OTP boxes, Resend OTP text button visible only when canResend is true, Verify button disabled until isComplete, loading indicator on Resend button when isResending — in lib/features/auth/presentation/widgets/otp_verification_form.dart
- [x] T022 [US2] Create OtpVerificationPage: BlocProvider creating OtpVerificationCubit with ResendOtpUseCase and email from route extra, BlocListener navigating to Change Password screen on success via context.push(AppRouter.changePassword, extra: {email, otp}), error SnackBar on failure, page layout matching auth screen pattern (background, logo, white card) — in lib/features/auth/presentation/pages/otp_verification_page.dart
- [x] T023 [US2] Add GoRoute entry for otpVerification path with builder extracting email from GoRouterState.extra and constructing OtpVerificationPage in lib/core/routing/app_router.dart

**Checkpoint**: User Stories 1 AND 2 fully functional — user can request OTP and verify it

---

## Phase 5: User Story 3 — Set New Password (Priority: P1)

**Goal**: User enters new password and confirmation on the Change Password screen, presses Confirm, API resets the password, success toast shown, and user navigates to Login screen.

**Independent Test**: Enter matching valid passwords (≥6 chars), press Confirm, verify success toast appears and navigation to Login screen occurs.

### Implementation for User Story 3

- [x] T024 [P] [US3] Create ChangePasswordState with email, otp, newPassword, confirmPassword, obscureNewPassword, obscureConfirmPassword, newPasswordError, confirmPasswordError, status enum (initial/loading/success/failure), errorMessage, errorType enum (otpExpired/passwordPolicy/rateLimit/network/server), hasSubmitted, copyWith() — in lib/features/auth/presentation/cubit/change_password_state.dart
- [x] T025 [US3] Create ChangePasswordCubit with: init(email, otp), newPasswordChanged(), confirmPasswordChanged(), toggleNewPasswordVisibility(), toggleConfirmPasswordVisibility(), submit() calling ResetPasswordUseCase, DioException handling differentiating 400 errors (inspect ProblemDetails detail field for OTP-related text → errorType.otpExpired vs passwordPolicy), 429 → rateLimit, network errors → network type — in lib/features/auth/presentation/cubit/change_password_cubit.dart
- [x] T026 [US3] Create ChangePasswordForm using BlocBuilder: changepassword.png illustration at top, "New Password" and "Confirm Password" TextFormFields with eye icon toggles for visibility, inline validation errors (min 6 chars, passwords must match), red border on error fields, Confirm button disabled until both fields valid and matching, CircularProgressIndicator on button during loading — in lib/features/auth/presentation/widgets/change_password_form.dart
- [x] T027 [US3] Create ChangePasswordPage: BlocProvider creating ChangePasswordCubit with ResetPasswordUseCase, email and otp from route extra, BlocListener handling success (show "Password reset successfully" SnackBar then context.go(AppRouter.login) to clear stack), otpExpired error (show error SnackBar then Future.delayed 2-3s then context.go(AppRouter.forgotPassword)), passwordPolicy error (stay on screen, inline error shown via state), page layout matching auth screen pattern — in lib/features/auth/presentation/pages/change_password_page.dart
- [x] T028 [US3] Add GoRoute entry for changePassword path with builder extracting email and otp from GoRouterState.extra and constructing ChangePasswordPage in lib/core/routing/app_router.dart

**Checkpoint**: All three P1 user stories fully functional — complete forgot password flow works end-to-end

---

## Phase 6: User Story 4 — Form Validation and Error Handling Polish (Priority: P2)

**Goal**: Ensure consistent, polished validation feedback, loading state behavior, and error handling across all three screens.

**Independent Test**: Enter various invalid inputs across all three screens and verify appropriate inline errors appear, buttons stay disabled until valid, and all API errors produce user-friendly messages.

### Implementation for User Story 4

- [x] T029 [US4] Add input normalization (trim whitespace, Arabic-to-Western digit conversion, Unicode control character stripping) to ForgotPasswordCubit.submit() following LoginCubit._normalizeInput pattern in lib/features/auth/presentation/cubit/forgot_password_cubit.dart
- [x] T030 [P] [US4] Add input normalization for OTP digits (Arabic-to-Western digit conversion) in OtpVerificationCubit.digitEntered() and pasteOtp() in lib/features/auth/presentation/cubit/otp_verification_cubit.dart
- [x] T031 [P] [US4] Ensure consistent error SnackBar styling (SnackBarBehavior.floating, AppColors.error background, 4-second duration, rounded corners) across all three page BlocListeners in lib/features/auth/presentation/pages/forgot_password_page.dart, lib/features/auth/presentation/pages/otp_verification_page.dart, and lib/features/auth/presentation/pages/change_password_page.dart

**Checkpoint**: All user stories complete with polished validation and error handling

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and code quality

- [x] T032 Verify complete navigation flow works end-to-end with GoRouter data passing: login → /forgot-password → /otp-verification (email extra) → /change-password (email+otp extra) → /login (stack cleared) in lib/core/routing/app_router.dart
- [x] T033 Run `flutter analyze` on all new and modified files and fix any lint warnings or static analysis errors

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational (Phase 2) completion
- **User Story 2 (Phase 4)**: Depends on Foundational (Phase 2) completion; functionally depends on US1 for email data flow, but can be built independently
- **User Story 3 (Phase 5)**: Depends on Foundational (Phase 2) completion; functionally depends on US2 for email+OTP data flow, but can be built independently
- **User Story 4 (Phase 6)**: Depends on US1, US2, and US3 being implemented (refines their output)
- **Polish (Phase 7)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (P1)**: Can start after Phase 2 — no dependencies on other stories
- **US2 (P1)**: Can start after Phase 2 — uses email from US1 but page receives it via route param, so buildable independently
- **US3 (P1)**: Can start after Phase 2 — uses email+OTP from US2 but page receives them via route params, so buildable independently
- **US4 (P2)**: Depends on US1, US2, US3 — refines error handling and validation polish across all three screens

### Within Each User Story

- State class before Cubit (cubit imports state)
- Cubit before Form widget (form uses BlocBuilder)
- Widget before Page (page renders widget)
- Page before Route entry (route builder references page class)

### Parallel Opportunities

**Phase 1**: T001 + T002 + T003 + T004 — all different files, fully parallel  
**Phase 2**: T005 + T006 + T007 (3 request models) — parallel, then T008 → T009 → T010 (sequential), then T011 + T012 + T013 (3 use cases) — parallel  
**Phase 3**: T014 → T015 → T016 → T017 (sequential within US1)  
**Phase 4**: T018 + T020 (state and widget are independent files) — parallel, then T019 → T021 → T022 → T023 (sequential)  
**Phase 5**: T024 (state) — then T025 → T026 → T027 → T028 (sequential)  
**Phase 6**: T029 + T030 + T031 — T029 and T030 are parallel (different cubits), T031 is parallel (different files)  
**Cross-story**: Once Phase 2 completes, US1/US2/US3 can theoretically proceed in parallel since they touch different files

---

## Parallel Example: Phase 2 (Foundational)

```text
# Batch 1 — Launch all request models in parallel:
T005: Create ForgotPasswordRequestModel in lib/features/auth/data/models/forgot_password_request_model.dart
T006: Create ResendOtpRequestModel in lib/features/auth/data/models/resend_otp_request_model.dart
T007: Create ResetPasswordRequestModel in lib/features/auth/data/models/reset_password_request_model.dart

# Batch 2 — Sequential data layer wiring (single file each):
T008: Add 3 methods to AuthRemoteDataSource
T009: Add 3 abstract methods to AuthRepository
T010: Implement 3 methods in AuthRepositoryImpl

# Batch 3 — Launch all use cases in parallel:
T011: Create ForgotPasswordUseCase in lib/features/auth/domain/use_cases/forgot_password_use_case.dart
T012: Create ResendOtpUseCase in lib/features/auth/domain/use_cases/resend_otp_use_case.dart
T013: Create ResetPasswordUseCase in lib/features/auth/domain/use_cases/reset_password_use_case.dart
```

## Parallel Example: User Story 2

```text
# Batch 1 — State and widget are independent files:
T018: Create OtpVerificationState in otp_verification_state.dart
T020: Create OtpInputField widget in otp_input_field.dart

# Batch 2 — Sequential (cubit depends on state):
T019: Create OtpVerificationCubit in otp_verification_cubit.dart

# Batch 3 — Sequential (form depends on cubit + widget):
T021: Create OtpVerificationForm in otp_verification_form.dart

# Batch 4 — Sequential (page depends on form):
T022: Create OtpVerificationPage in otp_verification_page.dart
T023: Add GoRoute entry in app_router.dart
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL — blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Email entry → Send → API call → Navigate to OTP screen
5. This proves the data layer works end-to-end

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add User Story 1 → Email → OTP navigation works (MVP!)
3. Add User Story 2 → OTP entry → Change Password navigation works
4. Add User Story 3 → Password reset → Login redirect works (Full flow!)
5. Add User Story 4 → Polish validation and error handling
6. Each story adds the next screen in the sequential flow

### Suggested MVP Scope

User Story 1 alone demonstrates the data layer (API integration), modified cubit (real API call replacing stub), and navigation (Screen A → Screen B). This is the minimum viable proof that the architecture works.

---

## Notes

- [P] tasks = different files, no dependencies on incomplete tasks in the same batch
- [US1/US2/US3/US4] label maps task to specific user story for traceability
- All cubits follow the LoginCubit pattern: status enum, DioException handling, Timer.periodic for countdowns
- All request models follow the LoginRequestModel pattern: final fields, constructor, toJson()
- All use cases follow the LoginUseCase pattern: constructor takes AuthRepository, call() method
- All pages follow the ForgotPasswordPage pattern: local BlocProvider, BlocListener for navigation/errors
- GoRouter `extra` parameter is used for data passing (email, OTP) — no path/query params for security
- `context.go()` is used for login redirect and expired-OTP redirect to clear the navigation stack
- `context.push()` is used for forward navigation (Screen A → B → C) to allow back navigation
- Commit after each task or logical group
- Stop at any checkpoint to validate the story independently
