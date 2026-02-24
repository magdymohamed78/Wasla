# Implementation Plan: Login Remember Me & Refresh Token

**Branch**: `023-login-remember-me` | **Date**: 2026-02-24 | **Spec**: [spec.md](spec.md)  
**Input**: Feature specification from `/specs/023-login-remember-me/spec.md`

## Summary

Make the existing "Remember Me" checkbox functional by sending `rememberMe` to the login API, storing tokens securely (FlutterSecureStorage), and implementing a refresh token flow for auto-login on app reopen. Add a Dio `QueuedInterceptorsWrapper` for transparent mid-session token refresh. Expand the splash screen to check auth state before navigating. Migrate legacy SharedPreferences data by clearing it on first post-update launch.

## Technical Context

**Language/Version**: Dart SDK ^3.11.0, Flutter (latest stable)  
**Primary Dependencies**: flutter_bloc 8.1.6, go_router 14.8.1, dio 5.7.0, shared_preferences 2.3.3, flutter_secure_storage ^9.2.4 (new)  
**Storage**: FlutterSecureStorage (encrypted, Keystore/Keychain) for tokens; SharedPreferences for locale prefs  
**Testing**: flutter_test, bloc_test 9.1.7, mocktail 1.0.4  
**Target Platform**: Android (minSdk 21) + iOS  
**Project Type**: Mobile app (Flutter)  
**Performance Goals**: Splash auth check completes within 3 seconds; transparent mid-session refresh with no user-visible delay  
**Constraints**: Zero plain-text token storage; offline-resilient (no token clearing on network errors)  
**Scale/Scope**: ~15 screens, single API backend at `waslacrm.runasp.net`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

No project-specific constitution has been defined (`.specify/memory/constitution.md` contains only the template). All gates pass trivially — no violations to check.

**Pre-design**: PASS (no constraints defined)  
**Post-design**: PASS (no constraints defined)

## Project Structure

### Documentation (this feature)

```text
specs/023-login-remember-me/
├── plan.md              # This file
├── research.md          # Phase 0: 10 research decisions
├── data-model.md        # Phase 1: entities, state transitions, relationships
├── quickstart.md        # Phase 1: implementation overview and file map
├── contracts/
│   └── api.md           # Phase 1: API endpoint contracts + storage keys
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── networking/
│   │   └── auth_interceptor.dart          # NEW: QueuedInterceptorsWrapper
│   └── routing/
│       └── app_router.dart                # MODIFIED: add GlobalKey<NavigatorState>
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── data_sources/
│   │   │   │   ├── auth_local_data_source.dart          # MODIFIED: extend interface
│   │   │   │   ├── secure_auth_local_data_source.dart   # NEW: FlutterSecureStorage impl
│   │   │   │   ├── in_memory_auth_local_data_source.dart # NEW: Map-based impl
│   │   │   │   └── auth_remote_data_source.dart         # MODIFIED: add refreshToken()
│   │   │   ├── models/
│   │   │   │   ├── login_request_model.dart             # MODIFIED: add rememberMe
│   │   │   │   ├── login_response_model.dart            # MODIFIED: add refreshToken fields
│   │   │   │   ├── refresh_token_request_model.dart     # NEW
│   │   │   │   └── refresh_token_response_model.dart    # NEW
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart            # MODIFIED: rememberMe, refreshToken
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── login_entity.dart                    # MODIFIED: add refreshToken fields
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart                 # MODIFIED: update signatures
│   │   │   └── use_cases/
│   │   │       └── login_use_case.dart                  # MODIFIED: add rememberMe param
│   │   └── presentation/
│   │       └── cubit/
│   │           ├── login_cubit.dart                      # MODIFIED: pass rememberMe
│   │           └── login_state.dart                      # UNCHANGED
│   └── splash/
│       └── presentation/
│           ├── cubit/
│           │   ├── splash_cubit.dart                     # MODIFIED: auth check + two-signal gate
│           │   └── splash_state.dart                     # MODIFIED: add SplashAuthStatus
│           └── pages/
│               └── splash_page.dart                     # MODIFIED: BlocConsumer + retry overlay
├── app.dart                                              # MODIFIED: wire interceptor, secure storage, splash cubit
└── main.dart                                             # MODIFIED: legacy data cleanup

test/
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── models/                                   # Tests for updated/new models
    │   │   ├── data_sources/                             # Tests for secure + in-memory data sources
    │   │   └── repositories/                             # Tests for updated repository
    │   └── presentation/
    │       └── cubit/                                    # Tests for updated login cubit
    ├── splash/
    │   └── presentation/
    │       └── cubit/                                    # Tests for expanded splash cubit
    └── core/
        └── networking/                                   # Tests for auth interceptor
```

**Structure Decision**: Follows existing Flutter Clean Architecture with feature-based module structure. New files are placed within existing directories. The only new directory is `lib/core/networking/` for the Dio interceptor.

## Complexity Tracking

> No constitution violations to justify. No complexity tracking needed.
