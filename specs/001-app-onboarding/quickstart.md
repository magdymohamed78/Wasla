# Quickstart: App Onboarding

**Branch**: `001-app-onboarding` | **Date**: 2026-02-17

## Prerequisites

- Flutter SDK (latest stable, ≥3.11)
- Dart SDK (^3.11.0, included with Flutter)
- Android Studio or VS Code with Flutter extension
- An Android emulator or physical device

## Setup

### 1. Install dependencies

Add to `pubspec.yaml` under `dependencies:`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
  flutter_bloc: ^9.0.0
  go_router: ^15.0.0
  shared_preferences: ^2.3.0
```

Run:
```bash
flutter pub get
```

### 2. Configure localization code generation

Create `l10n.yaml` at project root:

```yaml
arb-dir: lib/core/localization/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
```

Add to `pubspec.yaml` under `flutter:`:

```yaml
flutter:
  generate: true
```

### 3. Create ARB files

Create `lib/core/localization/l10n/app_en.arb`:
```json
{
  "@@locale": "en",
  "onboardingLogIn": "Log In",
  "onboardingNewUser": "New User",
  "languageEnglish": "English",
  "languageArabic": "العربية",
  "supportPageTitle": "Support",
  "supportPageDescription": "Need help? Contact us at support@wasla.app"
}
```

Create `lib/core/localization/l10n/app_ar.arb`:
```json
{
  "@@locale": "ar",
  "onboardingLogIn": "تسجيل الدخول",
  "onboardingNewUser": "مستخدم جديد",
  "languageEnglish": "English",
  "languageArabic": "العربية",
  "supportPageTitle": "الدعم",
  "supportPageDescription": "تحتاج مساعدة؟ تواصل معنا على support@wasla.app"
}
```

### 4. Generate localization files

```bash
flutter gen-l10n
```

This creates the `AppLocalizations` class automatically.

## Running the App

```bash
flutter run
```

## Verification Checklist

After running, verify the following:

1. **Splash screen** → App launches with red circle dropping down, "W" fading in, "ASLA" sliding in, loading dots animating. After 2 seconds, transitions to onboarding.
2. **Onboarding page** → Logo centered, "Log In" button visible, "New User" button visible, globe icon top-left, support icon top-right.
3. **Language switch** → Tap globe icon → dropdown with "English" and "العربية" → select Arabic → all text updates to Arabic, layout switches to RTL.
4. **Language persistence** → Select Arabic → close app → reopen → app displays in Arabic.
5. **Navigation** → Tap support icon → navigates to Support page → back button returns to onboarding.
6. **Placeholder routes** → Tap "Log In" → shows placeholder. Tap "New User" → shows placeholder.

## Project Structure After Implementation

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_dimensions.dart
│   │   └── app_theme.dart
│   ├── routing/
│   │   └── app_router.dart
│   ├── localization/
│   │   ├── l10n/
│   │   │   ├── app_en.arb
│   │   │   └── app_ar.arb
│   │   └── locale_cubit/
│   │       ├── locale_cubit.dart
│   │       └── locale_state.dart
│   ├── widgets/
│   │   ├── wasla_logo.dart
│   │   ├── primary_button.dart
│   │   ├── secondary_button.dart
│   │   └── language_dropdown.dart
│   └── utils/
│       └── responsive_utils.dart
├── features/
│   ├── splash/
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── splash_cubit.dart
│   │       │   └── splash_state.dart
│   │       ├── pages/
│   │       │   └── splash_page.dart
│   │       └── widgets/
│   │           ├── animated_logo_circle.dart
│   │           ├── animated_w_letter.dart
│   │           ├── animated_asla_text.dart
│   │           └── loading_dots.dart
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── onboarding_cubit.dart
│   │       │   └── onboarding_state.dart
│   │       ├── pages/
│   │       │   └── onboarding_page.dart
│   │       └── widgets/
│   │           └── onboarding_header.dart
│   └── support/
│       └── presentation/
│           └── pages/
│               └── support_page.dart
├── main.dart
└── app.dart
```

## Key Technical Decisions (see research.md for details)

| Area | Decision |
|------|----------|
| Animation | Single master controller + Interval per phase + separate repeating controller for dots |
| Localization | `flutter_localizations` + `intl` + `flutter gen-l10n` (official, type-safe) |
| State management | Cubit per feature + app-wide `LocaleCubit` above `MaterialApp.router` |
| Navigation | go_router with `BlocListener` triggers, `context.go()` for stack replacement |
| Persistence | `SharedPreferences` via `LocaleRepository` interface |
| RTL | Automatic via Flutter's `GlobalWidgetsLocalizations.delegate` |
