# Quickstart: Login Remember Me & Refresh Token

**Feature**: 023-login-remember-me  
**Branch**: `023-login-remember-me`

---

## What This Feature Does

Makes the existing "Remember Me" checkbox functional. When checked, the app persists the user's session securely and auto-logs them in on subsequent app opens using a refresh token. When unchecked, the session lives only in memory — the user must log in again after killing the app.

Adds a Dio interceptor that transparently refreshes expired access tokens mid-session, so authenticated API calls never fail silently due to token expiry.

---

## Key Files to Touch

### New Files

| File | Purpose |
|---|---|
| `lib/core/networking/auth_interceptor.dart` | `QueuedInterceptorsWrapper` — injects Bearer token, handles 401 refresh, queues concurrent requests |
| `lib/features/auth/data/models/refresh_token_request_model.dart` | Request body model for `/refresh-token` |
| `lib/features/auth/data/models/refresh_token_response_model.dart` | Response model for `/refresh-token` |
| `lib/features/auth/data/data_sources/secure_auth_local_data_source.dart` | `AuthLocalDataSource` impl backed by `FlutterSecureStorage` |
| `lib/features/auth/data/data_sources/in_memory_auth_local_data_source.dart` | `AuthLocalDataSource` impl backed by `Map` (in-memory only) |

### Modified Files

| File | Change |
|---|---|
| `pubspec.yaml` | Add `flutter_secure_storage: ^9.2.4` |
| `lib/main.dart` | Add legacy SharedPreferences cleanup on first launch |
| `lib/app.dart` | Add `AuthInterceptor` to Dio, provide `SplashCubit` via BlocProvider, wire new secure data source |
| `lib/features/auth/data/models/login_request_model.dart` | Add `rememberMe` bool field |
| `lib/features/auth/data/models/login_response_model.dart` | Add `refreshToken`, `refreshTokenExpiry` fields |
| `lib/features/auth/domain/entities/login_entity.dart` | Add `refreshToken`, `refreshTokenExpiry` fields |
| `lib/features/auth/data/data_sources/auth_local_data_source.dart` | Extend abstract interface with refresh token + remember me methods |
| `lib/features/auth/data/data_sources/auth_remote_data_source.dart` | Add `refreshToken()` method for the new endpoint |
| `lib/features/auth/data/repositories/auth_repository_impl.dart` | Add `rememberMe` to login, add `refreshToken()`, add remember me flag methods |
| `lib/features/auth/domain/repositories/auth_repository.dart` | Update `login()` signature, add `refreshToken()`, `getRememberMeFlag()`, `getStoredRefreshToken()` |
| `lib/features/auth/domain/use_cases/login_use_case.dart` | Add `rememberMe` parameter |
| `lib/features/auth/presentation/cubit/login_cubit.dart` | Pass `rememberMe` to login call, conditionally switch data source |
| `lib/features/splash/presentation/cubit/splash_cubit.dart` | Inject `AuthRepository`, add auth check with two-signal gate pattern |
| `lib/features/splash/presentation/cubit/splash_state.dart` | Add `SplashAuthStatus` enum, `authStatus`, `readyToNavigate` fields |
| `lib/features/splash/presentation/pages/splash_page.dart` | Replace direct navigation with `BlocConsumer` listener, add retry overlay for network errors |
| `lib/core/routing/app_router.dart` | Add `GlobalKey<NavigatorState>` for interceptor-driven navigation |

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────┐
│                     Presentation                      │
│                                                      │
│  SplashPage ──→ SplashCubit (auth check + animation) │
│  LoginPage  ──→ LoginCubit  (rememberMe toggle)      │
│                                                      │
├──────────────────────────────────────────────────────┤
│                      Domain                          │
│                                                      │
│  AuthRepository (interface)                          │
│    ├── login(email, password, rememberMe)             │
│    ├── refreshToken(refreshToken)                     │
│    ├── getRememberMeFlag()                           │
│    ├── getStoredRefreshToken()                        │
│    ├── saveSession(user, rememberMe)                 │
│    └── clearSession()                                │
│                                                      │
│  LoginEntity (+ refreshToken, refreshTokenExpiry)    │
│  LoginUseCase (+ rememberMe param)                   │
│                                                      │
├──────────────────────────────────────────────────────┤
│                       Data                           │
│                                                      │
│  AuthRemoteDataSource                                │
│    ├── login(LoginRequestModel)                      │
│    └── refreshToken(RefreshTokenRequestModel)         │
│                                                      │
│  AuthLocalDataSource (abstract)                      │
│    ├── SecureAuthLocalDataSource (FlutterSecureStorage)│
│    └── InMemoryAuthLocalDataSource (Map)              │
│                                                      │
├──────────────────────────────────────────────────────┤
│                    Networking                        │
│                                                      │
│  Dio ──→ AuthInterceptor (QueuedInterceptorsWrapper) │
│            ├── onRequest: inject Bearer token         │
│            └── onError: 401 → refresh → retry         │
│                 └── _refreshDio (separate, no interceptors) │
└──────────────────────────────────────────────────────┘
```

---

## Implementation Order (Suggested)

1. **Models first** — Extend `LoginRequestModel`, `LoginResponseModel`, `LoginEntity`. Create `RefreshTokenRequestModel`, `RefreshTokenResponseModel`.
2. **Storage layer** — Add `flutter_secure_storage` dependency. Create `SecureAuthLocalDataSource` and `InMemoryAuthLocalDataSource`. Extend `AuthLocalDataSource` interface.
3. **Repository + Remote** — Update `AuthRepository`, `AuthRepositoryImpl`, `AuthRemoteDataSource` with refresh token methods and `rememberMe` parameter.
4. **Interceptor** — Create `AuthInterceptor`. Wire into Dio in `app.dart`. Add `GlobalKey` to `AppRouter`.
5. **Login flow** — Update `LoginUseCase`, `LoginCubit` to pass `rememberMe` and conditionally use secure vs in-memory storage.
6. **Splash flow** — Expand `SplashCubit`/`SplashState` with auth check. Update `SplashPage` with `BlocConsumer` and retry overlay.
7. **Migration** — Add legacy data cleanup to `main.dart`.
8. **Testing** — Unit tests for models, data sources, interceptor, cubits. Integration tests for splash auth flow.
