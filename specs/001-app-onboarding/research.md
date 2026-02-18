# Research: App Onboarding

**Branch**: `001-app-onboarding` | **Date**: 2026-02-17

## R1. Splash Screen Animation Architecture

**Decision**: Single master `AnimationController` + `Interval` per phase, with one additional repeating controller for loading dots.

**Rationale**: The animation sequence (circle drop → W fade → ASLA slide → dots) is a linear, non-overlapping pipeline within a fixed 2-second window. `Interval`-based staggering keeps timing declarative and tied to a single source of truth. Using `Future.delayed` chains or `addStatusListener` chains creates fragile timing dependencies.

**Alternatives considered**:
- Multiple `AnimationController`s (one per phase) — rejected: synchronization complexity for zero benefit with a linear timeline.
- `ImplicitlyAnimatedWidget` / `TweenAnimationBuilder` — rejected: these are state-driven, not timeline-driven. Cannot participate in an `Interval` pipeline.

### Animation Timeline (2000ms total)

| Phase | Time Slice | Normalized Interval | Duration |
|---|---|---|---|
| Circle drop + settle | 0ms–700ms | `Interval(0.0, 0.35)` | 700ms |
| "W" fade-in | 700ms–1050ms | `Interval(0.35, 0.525)` | 350ms |
| "ASLA" slide-in | 1050ms–1400ms | `Interval(0.525, 0.70)` | 350ms |
| Dots appear + loop | 1400ms–2000ms | `Interval(0.70, 1.0)` | 600ms |

### Animation Curves

| Phase | Curve | Rationale |
|---|---|---|
| Circle drop | `Curves.bounceOut` | Instantly recognizable "drop and settle," zero custom code |
| W fade-in | `Curves.easeIn` | Simple opacity ramp |
| ASLA slide-in | `Curves.easeOutCubic` | Decelerates into position, feels like it "arrives" |
| Dots appear | `Curves.easeIn` for opacity, then repeating loop | Smooth entry followed by continuous animation |

### Controller Architecture

- **Master controller**: `duration: 2000ms`, drives all four phases via `Interval`
- **Dots loop controller**: `duration: ~600ms`, calls `.repeat()`, started when master reaches the dots phase threshold

### Widget Pattern

All animation sub-widgets are `StatelessWidget` + `AnimatedBuilder`. Each receives its `Animation<double>` as a constructor parameter. Parent `SplashPage` (`StatefulWidget` + `TickerProviderStateMixin`) owns controllers and creates interval-scoped animations. This keeps widgets pure per Constitution Principle VII.

### Loading Dots Pattern

Staggered scale+opacity pulse using the dots loop controller + 3 offset intervals:
- Dot 1: `Interval(0.0, 0.6)`, Dot 2: `Interval(0.15, 0.75)`, Dot 3: `Interval(0.3, 0.9)`
- Curve: `Curves.easeInOut` for smooth sinusoidal feel
- No external packages needed — ~40-line widget

### Cubit Role

Widget's `AnimationController` drives animation timeline. Cubit is notified when complete and handles navigation decision:
1. `SplashPage.initState()` → creates controller, calls `controller.forward()`
2. Controller `addStatusListener` → on `completed`, calls `splashCubit.onAnimationComplete()`
3. `SplashCubit` emits `SplashCompleted` state
4. `BlocListener` reacts and triggers navigation

---

## R2. Localization Architecture

**Decision**: `flutter_localizations` + `intl` + `flutter gen-l10n` (official code generation)

**Rationale**: First-party, type-safe with compile-time key checks, minimal dependencies. `easy_localization` was rejected because it manages locale state internally via `context.setLocale()` which would compete with `LocaleCubit` — two sources of truth for locale violates Clean Architecture.

**Alternatives considered**:
- `easy_localization` package — rejected: internal state management conflicts with Cubit pattern, adds unnecessary dependencies for two languages.

### LocaleCubit Integration

- `LocaleCubit` emits a `Locale` state
- Provided at app root, **above** `MaterialApp.router`
- `BlocBuilder<LocaleCubit, LocaleState>` wraps `MaterialApp.router`, passes `state.locale` to the `locale` parameter
- When locale changes, Flutter's `Localizations` widget automatically rebuilds all descendant widgets using `AppLocalizations.of(context)` — no manual reload needed (satisfies FR-016)

### Persistence

- `LocaleCubit` calls `LocaleRepository` directly — no use case needed
- `LocaleRepository` interface in `core/localization/`, implementation uses `SharedPreferences`
- Rationale: zero business logic (pure CRUD). A `SaveLocaleUseCase` would be a pass-through class with no value

### RTL Support

- **Automatic** via `GlobalWidgetsLocalizations.delegate`
- When `locale` changes to `Locale('ar')`, `Directionality.of(context)` switches to `TextDirection.rtl`
- All standard Flutter widgets mirror automatically
- **Required**: Use `EdgeInsetsDirectional` instead of `EdgeInsets`, `AlignmentDirectional` instead of `Alignment`, `start`/`end` instead of `left`/`right`

### ARB File Structure

- Location: `lib/core/localization/l10n/`
- Template: `app_en.arb` (English is default per FR-018)
- Keys: feature-prefixed, camelCase (e.g., `onboardingLogIn`, `onboardingNewUser`)
- `l10n.yaml`: `nullable-getter: false` to avoid `!` null assertions

---

## R3. Navigation Architecture (go_router + Cubit)

**Decision**: `BlocListener` in `SplashPage` calls `context.go('/onboarding')` on `SplashCompleted` state. `AppRouter` as a final class with static route constants and a static `router()` factory method.

**Rationale**: Splash → onboarding is a transient, temporal event (animation completed), not a persistent state guard. `BlocListener` fires exactly once per state change, making it the correct semantic match. `redirect` is reserved for persistent guards (future auth checks).

**Alternatives considered**:
- go_router `redirect` based on `SplashCubit` state — rejected: over-engineered for a transient animation event, couples router to UI-layer concerns.
- `context.push()` — rejected: would leave splash in the back stack.

### Route Definitions

| Route | Path | Navigation Method | Rationale |
|---|---|---|---|
| Splash | `/` | Initial route | Entry point, every app starts at `/` |
| Onboarding | `/onboarding` | `context.go()` | Replaces stack entirely, no back to splash |
| Support | `/support` | `context.push()` | Push allows back-navigation to onboarding |
| Login | `/login` | `context.go()` | Placeholder, out of scope |
| Register | `/register` | `context.go()` | Placeholder, out of scope |

### AppRouter Structure

```
AppRouter (final class)
├── static const String splash = '/'
├── static const String onboarding = '/onboarding'
├── static const String support = '/support'
├── static const String login = '/login'
├── static const String register = '/register'
└── static GoRouter router() → GoRouter
```

### No-Back-to-Splash

`context.go()` replaces the entire navigation stack. After navigating to `/onboarding`, splash is not in history. No additional `WillPopScope` or route guards needed.

### Placeholder Routes

Real `GoRoute` entries with minimal `Scaffold` placeholder pages for `/login` and `/register`. Support page at `/support` has a real shell with placeholder content.

### Fade Transition

Use `pageBuilder` with `CustomTransitionPage` on the onboarding route definition. `transitionsBuilder` returns `FadeTransition` to satisfy FR-008.
