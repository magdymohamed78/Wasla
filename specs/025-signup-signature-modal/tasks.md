# Tasks: Registration Digital Signature Modal

**Input**: Design documents from `/specs/025-signup-signature-modal/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/ ✅
**Tests**: Not explicitly requested — no test tasks generated.
**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Exact file paths included in all descriptions

---

## Phase 1: Setup

**Purpose**: Add the one new direct dependency required for file I/O.

- [X] T001 Add `path_provider: ^2.1.0` to `dependencies` in `pubspec.yaml` and run `flutter pub get`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Extend the data layer and registration Cubit to carry `digitalSignature` through the stack. ALL user story phases depend on this phase being complete.

⚠️ **CRITICAL**: No user story work can begin until this phase is complete.

- [X] T002 Add nullable `digitalSignature: String?` field to `LoginEntity` constructor, copyWith-equivalent, and all named parameters in `lib/features/auth/domain/entities/login_entity.dart`
- [X] T003 [P] Add `digitalSignature: String?` field to `LoginResponseModel` in `lib/features/auth/data/models/login_response_model.dart`, update `fromJson` to read `json['digitalSignature'] as String?`, and update `toEntity()` to pass `digitalSignature: digitalSignature`
- [X] T004 [P] Add `digitalSignature: String?` field to `RegisterState` class and its `copyWith` method in `lib/features/auth/presentation/cubit/register_state.dart`
- [X] T005 Add `missingSignature` value to `RegisterErrorCode` enum in `lib/features/auth/presentation/cubit/register_state.dart`
- [X] T006 Update `RegisterCubit.register()` in `lib/features/auth/presentation/cubit/register_cubit.dart` to pass `digitalSignature: user.digitalSignature` in the success `emit`, and emit `RegisterStatus.failure` with `errorCode: RegisterErrorCode.missingSignature` when `user.digitalSignature` is null or empty

**Checkpoint**: `digitalSignature` flows from API response → `LoginResponseModel` → `LoginEntity` → `RegisterState.digitalSignature`. `RegisterCubit` correctly gates on missing signature. All existing login and registration error paths unchanged.

---

## Phase 3: User Story 1 — View Digital Signature After Registration (Priority: P1) 🎯 MVP

**Goal**: Modal appears immediately after successful registration, displays the signature in a selectable scrollable area with a guidance message, and blocks navigation until conditions are met.

**Independent Test**: Complete a new user registration. Verify modal appears automatically, displays the opaque signature text in a selectable scrollable area, shows the guidance message about keeping the signature safe, and cannot be dismissed by back button or tapping outside.

### Implementation for User Story 1

- [X] T007 [P] [US1] Create `SignatureModalStatus` enum (`idle`, `downloading`, `downloaded`, `downloadError`) and `SignatureModalState` class with fields `signature: String`, `status: SignatureModalStatus`, `errorMessage: String?` and a `copyWith` method in `lib/features/auth/presentation/cubit/signature_modal_state.dart`
- [X] T008 [P] [US1] Create `SignatureModalCubit extends Cubit<SignatureModalState>` with constructor `SignatureModalCubit(String signature)` initializing state with `SignatureModalState(signature: signature, status: SignatureModalStatus.idle)` in `lib/features/auth/presentation/cubit/signature_modal_cubit.dart`
- [X] T009 [US1] Create `DigitalSignatureModal` stateless widget in `lib/features/auth/presentation/widgets/digital_signature_modal.dart` with: non-dismissible `AlertDialog` (`barrierDismissible: false`, `WillPopScope` blocking back), guidance message text (from localization key), `SelectableText` in a scrollable container showing `state.signature` in plaintext, a disabled download icon button placeholder, and a disabled OK `ElevatedButton`
- [X] T010 [US1] Update `SignUpPage` `BlocListener` in `lib/features/auth/presentation/pages/sign_up_page.dart` to show `DigitalSignatureModal` via `showDialog` (with `BlocProvider` for `SignatureModalCubit`) when `state.status == RegisterStatus.success` and `state.digitalSignature` is non-empty, replacing the direct `context.go(AppRouter.registerSuccess)` call

**Checkpoint**: User Story 1 is independently testable — modal appears after registration, displays signature in a scrollable selectable area with guidance message, cannot be dismissed without using the OK button.

---

## Phase 4: User Story 2 — Download Digital Signature as a File (Priority: P2)

**Goal**: Tapping the download icon saves the signature as `wasla_digital_signature.txt` in the app documents directory. On success the OK button is enabled; on failure an inline error is shown and OK stays disabled.

**Independent Test**: With the modal open (signature visible), tap the download icon. Verify `wasla_digital_signature.txt` appears in the app documents directory (via ADB or Files app) containing the exact signature string. Verify OK button becomes enabled after success and remains disabled after a simulated failure.

### Implementation for User Story 2

- [X] T011 [US2] Add `downloadSignature()` async method to `SignatureModalCubit` in `lib/features/auth/presentation/cubit/signature_modal_cubit.dart`: emit `downloading` → use `path_provider`'s `getApplicationDocumentsDirectory()` and `dart:io` `File.writeAsString()` to write `state.signature` to `wasla_digital_signature.txt` → emit `downloaded` on success or `downloadError` with error message on exception
- [X] T012 [US2] Update `DigitalSignatureModal` in `lib/features/auth/presentation/widgets/digital_signature_modal.dart` to wire the download icon button: show `CircularProgressIndicator` when `status == downloading`, call `context.read<SignatureModalCubit>().downloadSignature()` on tap when `status == idle` or `status == downloadError`, and disable the icon (greyed) when `status == downloaded`
- [X] T013 [US2] Update `DigitalSignatureModal` in `lib/features/auth/presentation/widgets/digital_signature_modal.dart` to show inline error text below the text area when `status == downloadError` (display `state.errorMessage`), and clear it when the download icon is tapped again

**Checkpoint**: User Story 2 is independently testable — download icon saves the file, OK button enables on success, error message shows on failure with retry available via the download icon.

---

## Phase 5: User Story 3 — Close Modal and Navigate to Registration Success (Priority: P3)

**Goal**: OK button is enabled only after successful download. Pressing OK closes the modal and navigates to `/register-success`. The signature is not retained after the modal closes.

**Independent Test**: After downloading, tap OK. Verify the modal closes and the `/register-success` screen is shown. Attempt to tap OK before download — verify it is not tappable. Verify the signature is not accessible after modal closes (cubit disposed).

### Implementation for User Story 3

- [X] T014 [US3] Update `DigitalSignatureModal` in `lib/features/auth/presentation/widgets/digital_signature_modal.dart` to: redact the signature text area when `status == downloaded` (replace displayed text with `'•' * state.signature.length` or a fixed mask string), enable the OK `ElevatedButton` only when `status == downloaded`, and invoke the `onOkPressed` callback when OK is tapped
- [X] T015 [US3] Update `SignUpPage` `showDialog` call in `lib/features/auth/presentation/pages/sign_up_page.dart` to pass `onOkPressed` callback that calls `Navigator.of(context).pop()` then `context.go(AppRouter.registerSuccess)`, ensuring navigation to `/register-success` only occurs after OK is pressed

**Checkpoint**: All three user stories are fully functional — modal appears, download works with gate enforcement, redaction occurs after download, OK navigates to the success screen.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Localization strings, missing-signature error handling in the UI, and accessibility.

- [X] T016 [P] Add localization keys for the modal guidance message, download error message, and OK button label to the ARB localization files in `lib/l10n/` (both Arabic and English entries)
- [X] T017 [P] Update `SignUpPage._mapErrorCodeToMessage` in `lib/features/auth/presentation/pages/sign_up_page.dart` to handle `RegisterErrorCode.missingSignature` and return the appropriate localized error string
- [X] T018 Add `Semantics` labels to the download icon button and OK button in `lib/features/auth/presentation/widgets/digital_signature_modal.dart` for screen-reader accessibility
- [X] T019 Run the full quickstart regression check from `specs/025-signup-signature-modal/quickstart.md` Section 8: verify login flow, forgot-password flow, and registration failure paths are unaffected

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 — **BLOCKS all user stories**
- **User Story Phases (3, 4, 5)**: All depend on Phase 2 completion
  - US1 (Phase 3) must complete before US2 (Phase 4) — `DigitalSignatureModal` widget must exist before download wiring
  - US2 (Phase 4) must complete before US3 (Phase 5) — download state must exist before OK-gate and redaction logic
- **Polish (Phase 6)**: Depends on Phase 5 completion

### User Story Dependencies

- **US1 (P1)**: Depends on Phase 2 only. No dependency on US2 or US3.
- **US2 (P2)**: Depends on US1 (requires `SignatureModalCubit` and `DigitalSignatureModal` scaffolding from T007–T010).
- **US3 (P3)**: Depends on US2 (requires `downloaded` status from `downloadSignature()`).

### Within Each Phase

- T002, T003, T004 can run in parallel (different files, no shared dependency)
- T005 must follow T004 (same file as RegisterState)
- T006 must follow T002 and T004 (reads `LoginEntity.digitalSignature` and `RegisterState`)
- T007, T008 can run in parallel (different new files)
- T009 must follow T007, T008 (widget depends on state/cubit types)
- T010 must follow T009 (sign_up_page needs modal widget)
- T011 must follow T008 (adds method to cubit)
- T012, T013 can run in parallel (both update the same widget — coordinate if solo; parallel if pair)
- T014 must follow T012 (OK button depends on `downloaded` status from download wiring)
- T015 must follow T014 (navigation wired after OK button is enabled)
- T016, T017 can run in parallel (different files)
- T018, T019 can run in parallel (independent)

### Parallel Execution Examples

**Phase 2 — Maximum parallelism (3 workers):**
```
Worker 1: T002 (login_entity.dart)
Worker 2: T003 (login_response_model.dart)
Worker 3: T004 → T005 → T006 (register_state.dart → register_cubit.dart)
```

**Phase 3 — Parallel start:**
```
Worker 1: T007 (signature_modal_state.dart)
Worker 2: T008 (signature_modal_cubit.dart)
→ Both complete → Worker 1: T009 → T010
```

**Phase 6 — Full parallelism:**
```
Worker 1: T016 (l10n ARB files)
Worker 2: T017 (sign_up_page error mapping)
Worker 3: T018 (accessibility) → T019 (regression)
```

---

## Implementation Strategy

**MVP Scope (Phase 1 + 2 + 3)**: Complete US1 first. This delivers a working modal that displays the signature and blocks navigation — independently demonstrable and testable without download functionality.

**Incremental delivery order**:
1. Phase 1 + 2 → Data layer ready, no UI change visible yet
2. Phase 3 (US1) → Modal appears with signature displayed, OK always disabled
3. Phase 4 (US2) → Download works, OK enables on success
4. Phase 5 (US3) → Redaction + navigation complete — full feature working end-to-end
5. Phase 6 → Polish, localization, accessibility

**Total tasks**: 19
**Tasks by user story**: US1 = 4, US2 = 3, US3 = 2
**Setup + Foundational**: 6
**Polish**: 4
**Parallel opportunities identified**: Phase 2 (T002/T003/T004 parallel), Phase 3 (T007/T008 parallel), Phase 6 (T016/T017/T018 parallel)
