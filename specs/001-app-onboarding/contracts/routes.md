# Route Contracts: App Onboarding

**Branch**: `001-app-onboarding` | **Date**: 2026-02-17

## Overview

All routes are defined as top-level routes in `AppRouter` (`lib/core/routing/app_router.dart`). No nested routes. Navigation uses `go_router`.

## Route Definitions

### GET `/` — Splash Screen

| Property | Value |
|----------|-------|
| **Path** | `/` |
| **Page** | `SplashPage` |
| **Description** | Entry point. Displays animated splash screen. Auto-navigates to `/onboarding` when animation completes. |
| **Transition** | Default (none — first screen) |
| **Back navigation** | N/A (initial route) |
| **Cubit** | `SplashCubit` provided via `BlocProvider` within route builder |

**Navigation trigger**: `BlocListener<SplashCubit>` detects `SplashCompleted` → `context.go('/onboarding')`

---

### GET `/onboarding` — Onboarding Welcome Page

| Property | Value |
|----------|-------|
| **Path** | `/onboarding` |
| **Page** | `OnboardingPage` |
| **Description** | Welcome page with Wasla logo, language selector, Log In button, New User button, and support icon. |
| **Transition** | `CustomTransitionPage` with `FadeTransition` (FR-008) |
| **Back navigation** | Disabled (replaces splash in stack via `context.go()`) |
| **Cubit** | `OnboardingCubit` provided via `BlocProvider` within route builder |

**Navigation triggers**:
- `BlocListener<OnboardingCubit>` on `navigateToLogin` → `context.go('/login')`
- `BlocListener<OnboardingCubit>` on `navigateToRegister` → `context.go('/register')`
- `BlocListener<OnboardingCubit>` on `navigateToSupport` → `context.push('/support')`

**Localization**: Reads `LocaleCubit` state for language. Globe dropdown triggers `LocaleCubit.changeLocale()`.

---

### GET `/support` — Support Page

| Property | Value |
|----------|-------|
| **Path** | `/support` |
| **Page** | `SupportPage` |
| **Description** | Help and contact information page. Partially in scope — shell with placeholder content. |
| **Transition** | Default (slide from right / RTL-aware) |
| **Back navigation** | Enabled (`context.push()` from onboarding preserves back stack) |
| **Cubit** | None (static content page) |

---

### GET `/login` — Login Page (Placeholder)

| Property | Value |
|----------|-------|
| **Path** | `/login` |
| **Page** | Placeholder `Scaffold` with "Login — Coming Soon" text |
| **Description** | Out of scope. Route defined so onboarding "Log In" button has a valid target. |
| **Transition** | Default |
| **Back navigation** | Enabled |
| **Cubit** | None |

---

### GET `/register` — Registration Page (Placeholder)

| Property | Value |
|----------|-------|
| **Path** | `/register` |
| **Page** | Placeholder `Scaffold` with "Register — Coming Soon" text |
| **Description** | Out of scope. Route defined so onboarding "New User" button has a valid target. |
| **Transition** | Default |
| **Back navigation** | Enabled |
| **Cubit** | None |

---

## Navigation Flow Diagram

```
App Launch
    │
    ▼
[/] SplashPage
    │ (animation completes → SplashCubit emits SplashCompleted)
    │ context.go('/onboarding')  ← replaces stack, no back
    ▼
[/onboarding] OnboardingPage
    ├── Globe icon tap → LocaleCubit.changeLocale() → rebuilds locale
    ├── "Log In" tap → OnboardingCubit → context.go('/login')
    ├── "New User" tap → OnboardingCubit → context.go('/register')
    └── Support icon tap → OnboardingCubit → context.push('/support')
                                                   │
                                                   ▼
                                          [/support] SupportPage
                                                   │ (back button)
                                                   │ context.pop()
                                                   ▼
                                          [/onboarding] OnboardingPage (state preserved)
```

## App-Wide Providers (above MaterialApp.router)

```
MultiBlocProvider
├── RepositoryProvider<LocaleRepository> → LocaleRepositoryImpl(SharedPreferences)
└── BlocProvider<LocaleCubit> → LocaleCubit(LocaleRepository)
      └── BlocBuilder<LocaleCubit, LocaleState>
            └── MaterialApp.router(
                  locale: state.locale,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  routerConfig: AppRouter.router(),
                )
```
