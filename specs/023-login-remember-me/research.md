# Research: Login Remember Me & Refresh Token

**Feature**: 023-login-remember-me  
**Date**: 2026-02-24  
**Status**: Complete

---

## Decision 1: Secure Storage Package

**Decision**: Use `flutter_secure_storage: ^9.2.4`  
**Rationale**: Industry-standard package for secure credential storage in Flutter. Uses Android Keystore + EncryptedSharedPreferences on Android and iOS Keychain on iOS. No platform-specific setup required — Android `minSdkVersion` 21 ≥ 18 threshold, iOS uses Keychain automatically.  
**Alternatives considered**:
- `shared_preferences` (current) — stores tokens in plain text; insecure for access/refresh tokens
- `hive_flutter` with encryption — more complex setup, primarily designed as a local database, overkill for key-value credential storage
- Platform channels (custom Keystore/Keychain) — unnecessary when `flutter_secure_storage` already wraps both

**Key API differences from SharedPreferences**:
| Operation | SharedPreferences | flutter_secure_storage |
|---|---|---|
| Instance | `await SharedPreferences.getInstance()` | `const FlutterSecureStorage()` (no async init) |
| Read | `prefs.getString(key)` | `await storage.read(key: key)` |
| Write | `await prefs.setString(key, value)` | `await storage.write(key: key, value: value)` |
| Delete | `await prefs.remove(key)` | `await storage.delete(key: key)` |
| Data types | String, int, double, bool | **String only** — serialize ints via `toString()`/`int.parse()` |

---

## Decision 2: Token Storage Architecture (Remember Me on vs off)

**Decision**: Strategy pattern — two implementations of the existing `AuthLocalDataSource` abstract class:
1. `SecureAuthLocalDataSource` — backed by `FlutterSecureStorage`, persists to disk (Remember Me ON)
2. `InMemoryAuthLocalDataSource` — backed by a `Map<String, dynamic>`, lives in memory only (Remember Me OFF)

**Rationale**: The existing `AuthLocalDataSource` abstract interface already defines `saveToken`, `getToken`, `saveUser`, `getUser`, `clearAll`. Swapping implementations at login time via DI provides clean separation with zero changes to callers (repository, cubit). When Remember Me is OFF and the app process is killed, the in-memory `Map` is garbage-collected — tokens never touch disk.  
**Alternatives considered**:
- Single implementation with conditional write logic (if rememberMe → write to secure storage, else skip writes) — violates single responsibility, harder to test
- Always persist but clear on app resume if Remember Me was off — race condition risks, unnecessary disk I/O

**DI swap point**: In `App.initState()` / login flow — when login succeeds, the cubit decides which data source to use based on the `rememberMe` flag and reconfigures the repository.

---

## Decision 3: Legacy Data Migration

**Decision**: Clear all legacy SharedPreferences auth keys on first launch post-update. Use a `secure_storage_migrated` boolean flag in SharedPreferences to track migration status.  
**Rationale**: Old sessions lack refresh tokens and were stored in plain text — they can't participate in the new flow. Force re-login is the simplest and safest approach (spec clarification Q1 answer).  
**Alternatives considered**:
- Migrate plain-text tokens into secure storage — adds complexity, old tokens lack `refreshToken` anyway
- No migration, rely on natural session expiry — leaves plain-text tokens on disk indefinitely

**Implementation point**: `main.dart` — before `runApp()`, check `secure_storage_migrated` flag and clear legacy keys (`auth_token`, `user_id`, `customer_id`, `first_name`, `last_name`, `user_email`) if not yet migrated.

---

## Decision 4: Dio Interceptor Architecture

**Decision**: Use `QueuedInterceptorsWrapper` with a separate `Dio` instance for refresh calls.  
**Rationale**: `QueuedInterceptorsWrapper` serializes interceptor callbacks — when one 401 triggers a refresh, all subsequent requests queue automatically. No manual lock/Completer needed. A separate `Dio` instance (`_refreshDio`) for the refresh call has zero interceptors, preventing refresh loops entirely.  
**Alternatives considered**:
- Standard `Interceptor` with manual Completer/lock — more error-prone, must manually manage concurrency
- `extra` flag to skip self-interception — works but fragile; separate Dio is cleaner

**File location**: `lib/core/networking/auth_interceptor.dart`

**Token injection**: `onRequest` in the same interceptor — injects `Authorization: Bearer <token>` header from stored token. No separate interceptor needed.

**Network error vs auth error distinction**: In `onError`, if refresh fails with 401 → clear tokens + force logout. If refresh fails with network error → surface error to caller, do NOT clear tokens (per spec clarification Q5).

---

## Decision 5: Navigation from Interceptor (No BuildContext)

**Decision**: Add a `static GlobalKey<NavigatorState>` on `AppRouter` and pass it to `GoRouter(navigatorKey:)`. The interceptor uses `GoRouter.of(navigatorKey.currentContext!).go(AppRouter.login)` to force logout.  
**Rationale**: Simplest approach that works with GoRouter. The key is already supported via `GoRouter`'s `navigatorKey` parameter. No additional packages or streams needed.  
**Alternatives considered**:
- `StreamController`-based `SessionManager` listened to by `App` widget — more "Clean Architecture" pure but adds indirection for a simple navigation call
- Passing a logout callback to the interceptor — creates circular dependencies with the app widget

---

## Decision 6: Splash Screen Auth Check Pattern

**Decision**: Expand `SplashCubit` to handle auth check. Use two boolean flags (`_animationFinished`, `_authFinished`) and a `_tryNavigate()` method to coordinate. Navigation fires only when BOTH flags are true.  
**Rationale**: The auth check is splash-scoped (runs once at startup). Expanding `SplashCubit` keeps the navigation decision in one place. Booleans over `Completer` because `Completer` is single-use — booleans support retry on network error.  
**Alternatives considered**:
- Separate `SplashAuthCubit` — adds wiring overhead (extra `BlocProvider`, cross-cubit coordination) for a one-shot operation
- Reuse `LoginCubit.checkAuthStatus()` from splash — couples splash to login's state machine
- `Completer<void>` pair with `Future.wait` — cleaner for one-shot but doesn't support retry

**Expanded SplashState**: Add `authStatus` (pending/authenticated/unauthenticated/networkError), `readyToNavigate` boolean, and computed `destination` getter.

**Error overlay**: Stack-based overlay on top of splash animation. Animation continues underneath. "No connection — Retry" button resets `_authFinished` and re-runs auth check.

---

## Decision 7: SplashCubit Dependency Injection

**Decision**: Inject `AuthRepository` (or the new secure local data source) into `SplashCubit` via constructor. Create the cubit in `App` state and provide it via `BlocProvider`.  
**Rationale**: Currently `SplashCubit` is created locally in `SplashPage` with no dependencies. For the auth check, it needs access to `AuthRepository` to read Remember Me flag, stored refresh token, and call the refresh endpoint. Moving cubit creation to `App` (like `LoginCubit` and `RegisterCubit`) keeps DI consistent.  
**Alternatives considered**:
- Pass `AuthRepository` directly to `SplashPage` via constructor — breaks GoRouter's builder pattern which uses `const SplashPage()`
- Use `context.read<AuthRepository>()` inside the cubit — anti-pattern, cubits shouldn't depend on BuildContext

---

## Decision 8: Login Request/Response Model Extensions

**Decision**: Extend existing models in-place (add fields to `LoginRequestModel`, `LoginResponseModel`, `LoginEntity`). Add new `RefreshTokenRequestModel` and `RefreshTokenResponseModel`.  
**Rationale**: The swagger API contract already includes `rememberMe` on `CustomerLoginDto` and `refreshToken`/`refreshTokenExpiry` on `CustomerLoginResultDto`. Extending in-place is simpler than creating new model classes. The `RefreshTokenRequestDto` is a new endpoint requiring its own model.  
**Alternatives considered**:
- Create entirely new versioned models (e.g., `LoginRequestModelV2`) — unnecessary churn, the old models aren't used elsewhere

**Changes**:
- `LoginRequestModel`: add `rememberMe` (bool) field + update `toJson()`
- `LoginResponseModel`: add `refreshToken` (String?) + `refreshTokenExpiry` (String?) + update `fromJson()` + `toEntity()`
- `LoginEntity`: add `refreshToken` (String?) + `refreshTokenExpiry` (String?)
- New: `RefreshTokenRequestModel` with `refreshToken` field + `toJson()`
- New: `RefreshTokenResponseModel` with `token`, `refreshToken`, `refreshTokenExpiry` + `fromJson()`

---

## Decision 9: AuthRepository Interface Extension

**Decision**: Add `refreshToken({required String refreshToken})` method and `rememberMe` parameter to `login()` on the `AuthRepository` abstract class. Add dedicated methods for Remember Me flag management.  
**Rationale**: The repository is the bridge between data and domain. The refresh token call is a new remote operation. The Remember Me flag affects storage behavior.  
**Alternatives considered**:
- Separate `TokenRepository` — over-engineering for 2 additional methods on an already small interface

**New methods on `AuthRepository`**:
- `login({required String email, required String password, required bool rememberMe})` — updated signature
- `Future<LoginEntity> refreshToken({required String refreshToken})` — new
- `Future<bool> getRememberMeFlag()` — new
- `Future<String?> getStoredRefreshToken()` — new

---

## Decision 10: AuthRemoteDataSource Extension

**Decision**: Add `refreshToken(RefreshTokenRequestModel request)` method to `AuthRemoteDataSource`. Endpoint: `POST /api/customer-portal/refresh-token`.  
**Rationale**: Follows existing pattern — `AuthRemoteDataSource` already has `login()` and `register()` methods that call specific endpoints. The refresh-token endpoint is a new API call in the same domain.  
**Alternatives considered**:
- Separate `TokenRemoteDataSource` — unnecessary; the refresh endpoint is part of the auth domain
