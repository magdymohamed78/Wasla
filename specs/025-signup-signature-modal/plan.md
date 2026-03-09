# Implementation Plan: Registration Digital Signature Modal

**Branch**: `025-signup-signature-modal` | **Date**: March 9, 2026 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/025-signup-signature-modal/spec.md`

## Summary

After the user completes registration the API already returns a `digitalSignature` field in the `CustomerLoginResultDto` response. A modal dialog must intercept the existing post-registration navigation, display the signature in a selectable scrollable text area, allow the user to download it as a `.txt` file, redact it after download, and only then enable the OK button that navigates to `/register-success`.

The implementation extends the existing Clean Architecture auth feature: `LoginEntity` and `LoginResponseModel` gain a `digitalSignature` field; a new `SignatureModalCubit` drives the modal state; a new `DigitalSignatureModal` widget is shown as a dialog from `SignUpPage`; and `path_provider` is added as a direct dependency for cross-platform file I/O.

## Technical Context

**Language/Version**: Dart (SDK ^3.11.0), Flutter
**Primary Dependencies**: flutter_bloc ^8.1.6, go_router ^14.8.1, dio ^5.7.0, path_provider (transitive  promote to direct dependency)
**Storage**: No persistent storage for signature. File I/O only (write `.txt` to device documents directory via `path_provider`)
**Testing**: flutter_test, bloc_test ^9.1.7, mocktail ^1.0.4
**Target Platform**: iOS & Android mobile app
**Project Type**: Mobile app (Flutter)
**Performance Goals**: Modal must appear within the same frame as the registration success state emission; file write is I/O-bound but the file is a single short string  no latency concern
**Constraints**: Digital signature must not be retained in app state after modal dismissal. Download gate must reset on every modal open. Path_provider documents directory used (no WRITE_EXTERNAL_STORAGE permission needed for Android 10+)
**Scale/Scope**: Single modal screen; 3 new/updated files minimum; 2 existing files updated

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project constitution is currently an unfilled template with no ratified principles. No constitution gates apply. This plan proceeds without constitution violations.

**Post-design re-check**: No violations introduced. Implementation uses existing patterns (Clean Architecture, Cubit, go_router) without introducing new abstractions. The `path_provider` addition is a focused, minimal dependency for the specific file-write operation required.

## Project Structure

### Documentation (this feature)

```text
specs/025-signup-signature-modal/
 plan.md              # This file
 research.md          # Phase 0 output
 data-model.md        # Phase 1 output
 quickstart.md        # Phase 1 output
 contracts/           # Phase 1 output
    registration-api.md
 tasks.md             # Phase 2 output (not created by /speckit.plan)
```

### Source Code (repository root)

```text
# Flutter Mobile App  Option 3 (Mobile)

lib/features/auth/
 data/
    models/
        login_response_model.dart     # UPDATE: add digitalSignature field
 domain/
    entities/
        login_entity.dart             # UPDATE: add digitalSignature field
 presentation/
     cubit/
        register_state.dart           # UPDATE: add digitalSignature field
        register_cubit.dart           # UPDATE: pass signature through success state
        signature_modal_cubit.dart    # NEW: download gate + redaction state
        signature_modal_state.dart    # NEW: enum + state class
     pages/
        sign_up_page.dart             # UPDATE: show modal before navigating
     widgets/
         digital_signature_modal.dart  # NEW: full modal widget

pubspec.yaml                              # UPDATE: add path_provider dependency

test/features/auth/
 cubit/
    signature_modal_cubit_test.dart  # NEW: unit tests for modal cubit
 widgets/
     digital_signature_modal_test.dart # NEW: widget test for modal
```

**Structure Decision**: Single Flutter mobile project (Option 3). All changes are contained within the existing `lib/features/auth/` module following the established Clean Architecture layout. No new layers, modules, or top-level directories required.
