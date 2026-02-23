# Implementation Plan: Fix Login Navigation to Home Screen

**Branch**: `019-fix-login-navigation` | **Date**: 2026-02-23 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/019-fix-login-navigation/spec.md`

## Summary

After a successful login, the app fails to navigate to the Home screen. The backend confirms success and the cubit emits `LoginStatus.success`, but the Home route's redirect guard calls `getStoredSession()` → `getUser()`, which returns `null` because `AuthLocalDataSourceImpl.getUser()` incorrectly requires `customerId` to be non-null — despite the domain entity (`LoginEntity.customerId`) and API response model (`LoginResponseModel.customerId`) both declaring it as `int?` (nullable). The redirect guard then bounces the user back to `/login`, creating an invisible redirect loop.

### Root Cause

**`AuthLocalDataSourceImpl.getUser()`** (line 62-78) has this guard:

```dart
if (token == null || userId == null || customerId == null || ...)  return null;
```

But `customerId` is legitimately nullable per the domain model. When the API returns `customerId: null`, `saveUser()` correctly calls `sharedPreferences.remove(_customerIdKey)`, so on read-back `customerId` is `null` → the entire method returns `null` → the home route guard redirects to `/login`.

### Fix Strategy

1. Make `getUser()` treat `customerId` as optional (consistent with `LoginEntity`)
2. Also handle `leadId` which is similarly nullable but not persisted at all currently
3. Verify the home route guard works correctly with the fixed session

## Technical Context

**Language/Version**: Dart 3.11 / Flutter  
**Primary Dependencies**: flutter_bloc 8.1.6, go_router 14.8.1, dio 5.7.0, shared_preferences 2.3.3  
**Storage**: SharedPreferences (on-device key-value store)  
**Testing**: flutter_test, bloc_test 9.1.7, mocktail 1.0.4  
**Target Platform**: Android, iOS  
**Project Type**: Mobile app (Flutter)  
**Performance Goals**: Navigation within 2 seconds of login response  
**Constraints**: Offline session persistence, no redirect loops  
**Scale/Scope**: Single feature bug fix — 3 files affected

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The constitution file is a blank template with no project-specific rules defined yet. No gates to evaluate. Proceeding with standard software engineering best practices.

**Result**: PASS (no constraints defined)

## Project Structure

### Documentation (this feature)

```text
specs/019-fix-login-navigation/
├── plan.md              # This file
├── research.md          # Phase 0: root cause analysis & GoRouter redirect patterns
├── data-model.md        # Phase 1: entity/storage field alignment
├── quickstart.md        # Phase 1: developer onboarding for this fix
├── contracts/           # Phase 1: N/A (no API changes — bug is client-side only)
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (affected files)

```text
lib/
├── features/auth/
│   ├── data/
│   │   └── data_sources/
│   │       └── auth_local_data_source.dart    # PRIMARY FIX: getUser() null-check
│   ├── domain/
│   │   └── entities/
│   │       └── login_entity.dart              # Reference: nullable fields
│   └── presentation/
│       ├── cubit/
│       │   └── login_cubit.dart               # Verify: save → emit ordering
│       └── pages/
│           └── login_page.dart                # Verify: BlocListener navigation
├── core/
│   └── routing/
│       └── app_router.dart                    # SECONDARY FIX: home redirect guard
test/
└── features/auth/
    └── (new tests for session persistence with nullable fields)
```

**Structure Decision**: Existing Flutter Clean Architecture structure. No new directories needed. Changes are surgical fixes to existing files.

## Complexity Tracking

No violations to justify. This is a minimal bug fix within the existing architecture.
