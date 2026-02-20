# Quickstart: Customer Login

**Feature**: 010-customer-login  
**Prerequisites**: Flutter SDK ^3.11.0, Dart null-safe  
**Last Updated**: 2026-02-19 (post-clarification)

## What Already Exists

The `009-customer-login` implementation built the core Clean Architecture foundation. All data/domain/presentation layers are in place with a working login flow.

**Existing files** (13 total in `lib/features/auth/`):
- Domain: `LoginEntity`, `AuthRepository` (interface), `LoginUseCase`
- Data: `LoginRequestModel`, `LoginResponseModel`, `AuthRemoteDataSourceImpl`, `AuthRepositoryImpl`
- Presentation: `LoginCubit`, `LoginState`, `LoginPage`, `LoginForm`
- Integration: Routes in `AppRouter`, DI wiring in `app.dart`

## What This Plan Adds

### 1. Inline Form Validation (FR-001 to FR-006)

**Files to modify**:
- `lib/features/auth/presentation/cubit/login_state.dart` — Add `emailError`, `passwordError`, `hasSubmitted` fields
- `lib/features/auth/presentation/cubit/login_cubit.dart` — Add `_validateEmail()`, `_validatePassword()` methods; modify `login()`, `emailChanged()`, `passwordChanged()` to emit validation errors
- `lib/features/auth/presentation/widgets/login_form.dart` — Pass `state.emailError`/`state.passwordError` to `InputDecoration.errorText`
- `lib/core/utils/validators.dart` — **NEW** — Shared email regex validator

**Pattern**: Errors shown only after first submit attempt (`hasSubmitted` flag). Error keys (not strings) in state → localized in UI.

### 2. Token Persistence for "Remember Me" (FR-012, FR-017)

**Files to create**:
- `lib/features/auth/data/data_sources/auth_local_data_source.dart` — **NEW** — Abstract + impl using `SharedPreferences`

**Files to modify**:
- `lib/features/auth/data/repositories/auth_repository_impl.dart` — Accept `AuthLocalDataSource`; persist token on login when "Remember Me" enabled
- `lib/app.dart` — Wire `AuthLocalDataSource` into DI; add auto-login check on startup

### 3. Post-Login Dashboard Route (FR-009 — clarification)

**Files to create**:
- `lib/features/home/presentation/pages/home_placeholder_page.dart` — **NEW** — Placeholder dashboard screen

**Files to modify**:
- `lib/core/routing/app_router.dart` — Add `/home` route pointing to `HomePlaceholderPage`
- `lib/features/auth/presentation/pages/login_page.dart` — On `LoginStatus.success`, navigate to `AppRouter.home`

### 4. Forgot Password Navigation (FR-013)

**Files to modify**:
- `lib/features/auth/presentation/widgets/login_form.dart` — Wire `onPressed` for "Forgot Password?" to navigate via `AppRouter`
- `lib/core/routing/app_router.dart` — Add `/forgot-password` route (placeholder page)

### 5. 429 Rate Limit Handling (clarification)

**Files to modify**:
- `lib/features/auth/presentation/cubit/login_cubit.dart` — Add `429` case to `_mapDioError()`, emit `rate_limited` error key; optionally parse `Retry-After` header
- `lib/features/auth/presentation/pages/login_page.dart` — Handle `rate_limited` error key in `_showErrorSnackBar` switch

**Pattern**: No client-side rate limiting. Server responds with 429 + `Retry-After` header. Cubit maps to error key; UI displays localized "too many attempts" message.

### 6. Session Expiry Handling (clarification)

**Files to modify**:
- `lib/features/auth/presentation/cubit/login_cubit.dart` — On 401 from auto-login or API call, emit `session_expired` error key
- `lib/features/auth/data/data_sources/auth_local_data_source.dart` — Add `clearToken()` method
- `lib/core/routing/app_router.dart` — Add redirect guard: if token invalid/expired → redirect to `/login`
- `lib/features/auth/presentation/pages/login_page.dart` — Handle `session_expired` error key, show "Session expired, please log in again" snackbar

**Pattern**: Even with "Remember Me", expired server token clears local storage and redirects to login with informational message.

### 7. Network Error Retry (FR-011)

**Files to modify**:
- `lib/features/auth/presentation/pages/login_page.dart` — Add retry action to error snackbar

### 8. Tests

**Files to create** (all NEW):
- `test/features/auth/presentation/cubit/login_cubit_test.dart`
- `test/features/auth/domain/use_cases/login_use_case_test.dart`
- `test/features/auth/data/repositories/auth_repository_impl_test.dart`
- `test/features/auth/presentation/pages/login_page_test.dart`

**Dev dependencies to add**: `bloc_test`, `mocktail`

### 9. Localization Keys

**Files to modify**: `lib/core/localization/l10n/app_en.arb`, `lib/core/localization/l10n/app_ar.arb` — Add validation error message keys, `loginRateLimited`, `loginSessionExpired`.

## Build & Run

```bash
# Install dependencies (including any new dev deps)
flutter pub get

# Generate l10n files after adding new ARB keys
flutter gen-l10n

# Run tests
flutter test

# Run the app
flutter run
```

## Architecture Diagram

```
LoginPage (BlocListener for navigation + error snackbar)
    └── LoginForm (BlocBuilder for form state)
            └── LoginCubit (validation + auth orchestration)
                    └── LoginUseCase (business rule delegation)
                            └── AuthRepository (interface)
                                    └── AuthRepositoryImpl
                                            ├── AuthRemoteDataSource (Dio → API)
                                            └── AuthLocalDataSource (SharedPreferences → token)
```

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Manual validation over `formz` | 2-field form doesn't justify the dependency |
| Error keys in Cubit state | Single source of truth; localization stays in UI |
| `hasSubmitted` flag | Show errors only after first submit, then live-validate |
| `shared_preferences` for tokens | Already in deps; abstracted for future swap to secure storage |
| No client-side rate limiting | Server handles brute-force; client shows 429 message (clarification) |
| Session expiry clears token | Even with "Remember Me", server token expiry redirects to login (clarification) |
| Dashboard placeholder | Post-login navigates to `/home` placeholder until dashboard is built (clarification) |
