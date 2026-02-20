# Implementation Plan: Login Error Response Handling

**Branch**: `011-login-error-handling` | **Date**: 2026-02-20 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/011-login-error-handling/spec.md`

## Summary

Map all backend login endpoint error responses (400, 401, 429, 500) plus network failures to user-visible snackbar messages on the login screen. The existing `LoginCubit._extractErrorMessage()` partially handles errors but needs to be updated to match the exact error contracts from `error-responses.md`, add a friendlier 400 message, add a 15-second cooldown for 429 rate-limiting, and set snackbar duration to 4 seconds.

## Technical Context

**Language/Version**: Dart 3.11 / Flutter (latest stable)
**Primary Dependencies**: flutter_bloc 8.1.6, dio 5.7.0, go_router 14.8.1, flutter_localizations
**Storage**: SharedPreferences (session persistence only, not affected by this feature)
**Testing**: flutter_test, bloc_test 9.1.7, mocktail 1.0.4
**Target Platform**: Android & iOS (cross-platform Flutter)
**Project Type**: Mobile
**Performance Goals**: Error messages displayed <1s after server response
**Constraints**: Snackbar auto-dismiss at 4 seconds; 429 cooldown at 15 seconds
**Scale/Scope**: Single login screen - modifies ~4 existing files, no new files required

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project constitution (`constitution.md`) is an unfilled template with no project-specific principles defined. **No gates to enforce.** The existing codebase follows Clean Architecture (data/domain/presentation layers with Cubit state management), and this feature continues that pattern with no structural changes.

**Pre-Phase-0 Status**: PASS (no constraints defined)

## Project Structure

### Documentation (this feature)

```text
specs/011-login-error-handling/
+-- plan.md              # This file
+-- research.md          # Phase 0 output
+-- data-model.md        # Phase 1 output
+-- quickstart.md        # Phase 1 output
+-- contracts/           # Phase 1 output
+-- tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/features/auth/
+-- data/
|   +-- data_sources/
|   |   +-- auth_local_data_source.dart
|   |   +-- auth_remote_data_source.dart      # No changes needed
|   +-- models/
|   |   +-- login_request_model.dart
|   |   +-- login_response_model.dart
|   +-- repositories/
|       +-- auth_repository_impl.dart
+-- domain/
|   +-- entities/
|   |   +-- login_entity.dart
|   +-- repositories/
|   |   +-- auth_repository.dart
|   +-- use_cases/
|       +-- login_use_case.dart
+-- presentation/
    +-- cubit/
    |   +-- login_cubit.dart                   # Update: error mapping & 429 cooldown
    |   +-- login_state.dart                   # Update: add error category & cooldown fields
    +-- pages/
    |   +-- login_page.dart                    # Update: snackbar duration & conditional retry
    +-- widgets/
        +-- login_form.dart                    # Update: disable button during 429 cooldown

test/features/auth/                            # New: unit & widget tests
+-- presentation/
    +-- cubit/
    |   +-- login_cubit_test.dart
    +-- pages/
        +-- login_page_test.dart
```

**Structure Decision**: Follows the existing Clean Architecture layout. Changes are scoped to the presentation layer (cubit, state, page, form). No new architectural layers or packages needed.

## Complexity Tracking

> No constitution violations to justify - constitution is undefined.
