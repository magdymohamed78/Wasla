# Data Model: App Onboarding

**Branch**: `001-app-onboarding` | **Date**: 2026-02-17

## Entities

### LanguagePreference

Represents the user's selected app language. This is a cross-cutting concern stored locally on the device.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| languageCode | String | ISO 639-1 language code | "en" or "ar" only |

**Default**: `"en"` (English) when no preference has been set or persisted data is corrupted/missing.

**Persistence**: Stored via `SharedPreferences` under a single key. Read on app startup, written on language change.

**Validation Rules**:
- Must be one of the supported language codes: `["en", "ar"]`
- If persisted value is not in the supported set, fall back to `"en"`

---

### SplashAnimationPhase (Enum)

Represents the current phase of the splash screen animation. Used by `SplashCubit` to track progress.

| Value | Description |
|-------|-------------|
| initial | Screen mounted, animation not started |
| animating | Animation sequence in progress |
| completed | All animations finished, ready to navigate |

**State Transitions**:
```
initial → animating → completed
```

- `initial → animating`: Triggered when `SplashPage.initState()` starts the master `AnimationController`
- `animating → completed`: Triggered when the master controller reports `AnimationStatus.completed`
- No reverse transitions. Splash is a one-way flow.

---

### OnboardingNavigation (Enum)

Represents the navigation actions available from the onboarding page. Used by `OnboardingCubit` to signal route changes.

| Value | Description |
|-------|-------------|
| idle | No navigation pending |
| navigateToLogin | User tapped "Log In" button |
| navigateToRegister | User tapped "New User" button |
| navigateToSupport | User tapped support icon |

**State Transitions**:
```
idle → navigateToLogin
idle → navigateToRegister
idle → navigateToSupport
```

After navigation is handled by `BlocListener`, the Cubit resets to `idle`.

---

## State Classes

### LocaleState

| Field | Type | Description |
|-------|------|-------------|
| locale | Locale | Current app locale (e.g., `Locale('en')` or `Locale('ar')`) |

**Used by**: `LocaleCubit` (in `core/localization/locale_cubit/`)

---

### SplashState

| Field | Type | Description |
|-------|------|-------------|
| phase | SplashAnimationPhase | Current animation phase |

**Used by**: `SplashCubit` (in `features/splash/presentation/cubit/`)

---

### OnboardingState

| Field | Type | Description |
|-------|------|-------------|
| navigation | OnboardingNavigation | Pending navigation action |

**Used by**: `OnboardingCubit` (in `features/onboarding/presentation/cubit/`)

---

## Repository Interfaces

### LocaleRepository (Abstract)

| Method | Return Type | Description |
|--------|-------------|-------------|
| getSavedLocale() | Future\<Locale?\> | Reads persisted language preference. Returns null if none saved. |
| saveLocale(Locale locale) | Future\<void\> | Persists the given locale's language code. |

**Implementation**: `LocaleRepositoryImpl` using `SharedPreferences`
- `getSavedLocale()`: Reads string key `"app_locale"`, returns `Locale(code)` or `null`
- `saveLocale()`: Writes `locale.languageCode` to string key `"app_locale"`

---

## Relationships

```
MaterialApp.router
  ├── reads → LocaleCubit.state.locale
  └── routerConfig → AppRouter.router()
        ├── / (SplashPage)
        │     └── listens → SplashCubit.state.phase == completed → go('/onboarding')
        ├── /onboarding (OnboardingPage)
        │     ├── reads → LocaleCubit (language dropdown)
        │     └── listens → OnboardingCubit.state.navigation → go/push routes
        ├── /support (SupportPage)
        ├── /login (placeholder)
        └── /register (placeholder)
```
