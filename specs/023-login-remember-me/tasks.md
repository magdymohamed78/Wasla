# Tasks: Login Remember Me & Refresh Token

**Input**: Design documents from `/specs/023-login-remember-me/`  
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/api.md, quickstart.md

---

## Phase 1: Setup

**Purpose**: Add new dependency and create project structure for new files

- [X] T001 Add `flutter_secure_storage: ^9.2.4` dependency in pubspec.yaml
- [X] T002 [P] Add legacy SharedPreferences cleanup on first post-update launch in lib/main.dart
- [X] T003 [P] Add `GlobalKey<NavigatorState>` to `AppRouter` and pass to `GoRouter(navigatorKey:)` in lib/core/routing/app_router.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Extend data models, entities, interfaces, and storage layer that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Models & Entity (US5 — Updated Login Response Model)

- [X] T004 [P] Add `rememberMe` bool field to `LoginRequestModel` and update `toJson()` in lib/features/auth/data/models/login_request_model.dart
- [X] T005 [P] Add `refreshToken` (String?) and `refreshTokenExpiry` (String?) fields to `LoginResponseModel`, update `fromJson()` and `toEntity()` in lib/features/auth/data/models/login_response_model.dart
- [X] T006 [P] Add `refreshToken` (String?) and `refreshTokenExpiry` (String?) fields to `LoginEntity` in lib/features/auth/domain/entities/login_entity.dart
- [X] T007 [P] Create `RefreshTokenRequestModel` with `refreshToken` field and `toJson()` in lib/features/auth/data/models/refresh_token_request_model.dart
- [X] T008 [P] Create `RefreshTokenResponseModel` with all token/user fields, `fromJson()` and `toEntity()` in lib/features/auth/data/models/refresh_token_response_model.dart

### Storage Layer

- [X] T009 Extend `AuthLocalDataSource` abstract interface with `saveRefreshToken()`, `getRefreshToken()`, `clearRefreshToken()`, `saveRememberMeFlag()`, `getRememberMeFlag()`, `clearRememberMeFlag()`, `saveRefreshTokenExpiry()`, `getRefreshTokenExpiry()` in lib/features/auth/data/data_sources/auth_local_data_source.dart
- [X] T010 [P] Create `SecureAuthLocalDataSource` implementing `AuthLocalDataSource` backed by `FlutterSecureStorage` with all keys (auth_token, refresh_token, refresh_token_expiry, remember_me, user_id, customer_id, lead_id, first_name, last_name, user_email) in lib/features/auth/data/data_sources/secure_auth_local_data_source.dart
- [X] T011 [P] Create `InMemoryAuthLocalDataSource` implementing `AuthLocalDataSource` backed by `Map<String, dynamic>` for in-memory-only session storage in lib/features/auth/data/data_sources/in_memory_auth_local_data_source.dart

### Repository & Remote Data Source

- [X] T012 Update `AuthRepository` abstract interface: add `rememberMe` param to `login()`, add `refreshToken()`, `getRememberMeFlag()`, `getStoredRefreshToken()` methods in lib/features/auth/domain/repositories/auth_repository.dart
- [X] T013 Add `refreshToken(RefreshTokenRequestModel request)` method to `AuthRemoteDataSource` abstract class and `AuthRemoteDataSourceImpl` calling `POST /api/customer-portal/refresh-token` in lib/features/auth/data/data_sources/auth_remote_data_source.dart
- [X] T014 Update `AuthRepositoryImpl`: add `rememberMe` to `login()`, implement `refreshToken()`, `getRememberMeFlag()`, `getStoredRefreshToken()`, update `saveSession()` to accept rememberMe flag in lib/features/auth/data/repositories/auth_repository_impl.dart
- [X] T015 Update `LoginUseCase` to accept and pass `rememberMe` parameter in lib/features/auth/domain/use_cases/login_use_case.dart

**Checkpoint**: All models, entities, interfaces, and storage implementations are ready. User story work can begin.

---

## Phase 3: User Story 1 & 2 — Login with Remember Me (Priority: P1) 🎯 MVP

**Goal**: Make the Remember Me checkbox functional — send `rememberMe` to the API, store tokens securely when checked (US1), hold tokens in memory only when unchecked (US2)

**Independent Test (US1)**: Log in with Remember Me checked → verify API request includes `rememberMe: true` → verify access token, refresh token, and remember me flag are stored in secure storage.

**Independent Test (US2)**: Log in with Remember Me unchecked → verify API request includes `rememberMe: false` → verify tokens are in memory only (not on disk) → kill app → reopen → verify user goes to Onboarding (not Home).

### Implementation

- [X] T016 Update `LoginCubit.login()` to pass `state.rememberMe` through `LoginUseCase` and conditionally use `SecureAuthLocalDataSource` or `InMemoryAuthLocalDataSource` for session storage in lib/features/auth/presentation/cubit/login_cubit.dart
- [X] T017 Update `App` widget to wire `SecureAuthLocalDataSource` (with `FlutterSecureStorage`) as the default data source, and expose a mechanism for `LoginCubit` to swap to `InMemoryAuthLocalDataSource` when Remember Me is off in lib/app.dart

**Checkpoint**: Login with Remember Me checked stores tokens securely. Login with Remember Me unchecked stores tokens in memory only. Both paths navigate to Home on success.

---

## Phase 4: User Story 3 & 4 — Auto-Login on App Reopen (Priority: P1)

**Goal**: On app reopen, the splash screen checks **local** auth state only (no network calls) — if Remember Me was on and a stored access token exists, navigate directly to Home. If no stored session, navigate to Onboarding. Token refresh and failure handling are delegated entirely to the interceptor (Phase 5) when API calls encounter 401 responses.

**Independent Test (US3)**: Log in with Remember Me → kill app → reopen → verify splash reads stored token locally and navigates to Home without making any network calls.

**Independent Test (US4)**: Log in with Remember Me → manually clear stored tokens (simulate missing session) → reopen app → verify splash navigates to Onboarding. For expired-but-stored tokens: splash navigates to Home, and the interceptor (Phase 5) handles refresh on the first API call.

### Implementation

- [X] T018 Update `SplashState` to add `SplashAuthStatus` enum (pending, authenticated, unauthenticated), `authStatus` field, `readyToNavigate` bool, and computed `destination` getter in lib/features/splash/presentation/cubit/splash_state.dart
- [X] T019 Expand `SplashCubit` to inject `AuthRepository`, implement local-only auth check (read remember me flag + stored access token — no network calls), use two-boolean gate pattern (`_animationFinished`, `_authFinished`) with `_tryNavigate()` in lib/features/splash/presentation/cubit/splash_cubit.dart
- [X] T020 Update `SplashPage` to replace direct `context.go('/onboarding')` with `BlocConsumer` listener that navigates to `state.destination` when `readyToNavigate` is true in lib/features/splash/presentation/pages/splash_page.dart
- [X] T021 Update `SplashPage` to use app-provided `SplashCubit` via `BlocProvider.value` instead of locally creating one, and wire `SplashCubit` creation in `App.initState()` with `AuthRepository` injection in lib/app.dart

**Checkpoint**: App reopen with valid Remember Me session and stored token auto-navigates to Home. No stored session navigates to Onboarding (current behavior preserved). No network calls during splash — all token refresh is delegated to the interceptor.

---

## Phase 5: User Story 4b — Transparent Mid-Session Token Refresh (Priority: P1)

**Goal**: Add a Dio interceptor that detects 401 responses on any API call, tracks consecutive unauthorized failures, and **only calls `/refresh-token` after more than 3 consecutive 401 responses**. Queues concurrent requests during refresh and retries — so the user never sees token expiry errors mid-session. This phase also absorbs US4 failure handling: auth failure during refresh clears tokens and forces logout; network error surfaces without clearing tokens.

**Independent Test**: Log in → simulate 401 on API calls → verify interceptor retries the request up to 3 times before triggering a `/refresh-token` call → verify refresh succeeds and retries original request without user-visible error. Verify concurrent 401s during refresh are queued (single refresh call). Verify auth failure during refresh clears tokens and navigates to Login. Verify network error during refresh surfaces error without clearing tokens.

### Implementation

- [X] T022 Create `AuthInterceptor` extending `QueuedInterceptorsWrapper` with: `onRequest` to inject `Authorization: Bearer <token>` header from stored token, `onError` to track consecutive 401 responses and only call `/refresh-token` via a separate `_refreshDio` instance (no interceptors) **after more than 3 consecutive 401 failures** (reset counter on success), retry original request on refresh success, clear tokens + force logout via `GlobalKey<NavigatorState>` on auth failure during refresh, surface error on network failure without clearing tokens in lib/core/networking/auth_interceptor.dart
- [X] T023 Wire `AuthInterceptor` into the main `Dio` instance via `_dio.interceptors.add(...)` in `App.initState()`, passing the local data source for token access in lib/app.dart

**Checkpoint**: All authenticated API calls automatically have Bearer tokens injected. After 3+ consecutive 401s, interceptor triggers token refresh. Concurrent requests during refresh are queued (single refresh call). Auth failures during refresh force logout. Network errors are surfaced without clearing tokens. Counter resets on any successful response.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final integration, cleanup, and validation

- [X] T024 Update `AuthRepositoryImpl.clearSession()` to clear all secure storage keys (access token, refresh token, refresh token expiry, remember me flag, all user data) ensuring logout fully resets state in lib/features/auth/data/repositories/auth_repository_impl.dart
- [X] T025 [P] Add localization strings for network error messages (e.g. "No connection", "Retry") in lib/core/localization/l10n/app_en.arb and lib/core/localization/l10n/app_ar.arb
- [X] T026 [P] Remove debug `debugPrint` statements from auth data sources and repository if no longer needed, or ensure they don't log sensitive token values
- [X] T027 Run quickstart.md validation: verify all acceptance scenarios from spec.md pass end-to-end

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on T001 (flutter_secure_storage dependency). BLOCKS all user stories.
- **US1 & US2 (Phase 3)**: Depends on Phase 2 completion — login flow changes
- **US3 & US4 (Phase 4)**: Depends on Phase 2 completion — can run in parallel with Phase 3
- **US4b (Phase 5)**: Depends on Phase 2 completion — can run in parallel with Phase 3 and Phase 4
- **Polish (Phase 6)**: Depends on all previous phases being complete

### User Story Dependencies

- **US5 (Foundational — Phase 2)**: Blocking prerequisite for all other stories. Models/entities must be updated first.
- **US1 & US2 (Phase 3)**: Depend on Foundational. Independent of US3/US4/US4b — can be tested by logging in and checking storage.
- **US3 & US4 (Phase 4)**: Depend on Foundational. Independent of US1/US2 at the splash level (splash reads stored auth locally, no network calls). Can start after Phase 2.
- **US4b (Phase 5)**: Depends on Foundational only. Also absorbs US4 failure handling (auth failure → logout, network error → surface). Fully independent — the interceptor works regardless of how tokens were stored. Can start after Phase 2.

### Within Each Phase

- Models marked [P] can all run in parallel (T004–T008)
- Storage implementations [P] can run in parallel after interface extension (T010, T011 after T009)
- Splash state (T018) before cubit (T019) before page (T020)

### Parallel Opportunities

```
After Phase 2 completes:
  ├── Phase 3 (US1 & US2): T016, T017
  ├── Phase 4 (US3 & US4): T018, T019, T020, T021   ← can run in parallel with Phase 3
  └── Phase 5 (US4b):      T022, T023                ← can run in parallel with Phase 3 & 4
```

---

## Implementation Strategy

### MVP First (Login + Storage Only — Phases 1–3)

1. Complete Phase 1: Setup (T001–T003)
2. Complete Phase 2: Foundational models + storage (T004–T015)
3. Complete Phase 3: Login with Remember Me on/off (T016–T017)
4. **STOP and VALIDATE**: Login sends `rememberMe`, tokens stored securely or in memory
5. Deploy/demo if ready — users can log in with functional Remember Me

### Full Delivery (Add Auto-Login + Interceptor — Phases 4–6)

6. Complete Phase 4: Splash auto-login + failure handling (T018–T021)
7. Complete Phase 5: Mid-session interceptor (T022–T023)
8. Complete Phase 6: Polish (T024–T027)
9. **FINAL VALIDATION**: Run all acceptance scenarios from spec.md

### Parallel Team Strategy

After Phase 2:
- Developer A: Phase 3 (Login flow) — T016, T017
- Developer B: Phase 4 (Splash flow) — T018–T021
- Developer C: Phase 5 (Interceptor) — T022, T023
- All converge on Phase 6 (Polish)

---

## Notes

- [P] tasks = different files, no dependencies — can run in parallel
- [USn] labels map tasks to specific user stories for traceability
- US5 (Updated Login Response Model) is absorbed into Phase 2 as a foundational prerequisite since all stories depend on it
- US1 and US2 are grouped in Phase 3 because they share the same files (LoginCubit, App widget) and test opposite branches of the same `rememberMe` flag
- US3 and US4 are grouped in Phase 4 for local auth checks; US4's network failure handling is delegated to the interceptor in Phase 5
- Commit after each task or logical group
- Total tasks: 27
