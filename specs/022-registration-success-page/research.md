# Research: Sign-Up Success Page

**Branch**: `022-registration-success-page` | **Date**: 2026-02-24

## R1. GoRouter Navigation Stack Clearing

**Decision**: Use `context.go(AppRouter.login)` to navigate from the Sign-Up Success Page to the Login Page. This replaces the entire navigation stack, making Login the new root route.

**Rationale**: `context.go()` performs declarative navigation — it sets the target route as the current location and rebuilds the navigation stack from scratch. All previously pushed routes (Splash → Onboarding → Register → Register-Success) are discarded. There is no "back" because nothing remains behind it in the stack. This is already the established pattern in the codebase:
- `sign_up_page.dart`: `context.go(AppRouter.home)` on success
- `login_page.dart`: `context.go(AppRouter.home)` on success
- `splash_page.dart`: `context.go('/onboarding')` after animation

**Alternatives considered**:
- `context.push('/login')` — rejected: keeps register-success in the stack; user could navigate back
- `context.pushReplacement('/login')` — rejected: only replaces the top-most route; deeper routes (Onboarding) remain
- `context.go('/onboarding')` then push login — rejected: unnecessary complexity

---

## R2. Back Navigation Disabling

**Decision**: Use `PopScope(canPop: false)` to wrap the page content. This disables the hardware back button, swipe-back gesture, and any system-level back navigation.

**Rationale**: `WillPopScope` is deprecated as of Flutter 3.12+. This project targets Dart SDK ^3.11.0, making `PopScope` the correct replacement. GoRouter 14.x respects `PopScope` — it delegates to `Navigator`'s pop handling, which checks `PopScope.canPop`. When `canPop: false`, system back is blocked while `context.go()` (declarative navigation) remains unaffected. This would be the first usage of `PopScope` in the codebase and sets a clean precedent.

**Alternatives considered**:
- `WillPopScope` — rejected: deprecated in Flutter 3.12+, generates lint warnings
- Hiding AppBar back button only (`automaticallyImplyLeading: false`) — rejected: only removes the visual button, does not block Android system back
- `NavigatorObserver` to intercept pops — rejected: overengineered for this use case

---

## R3. GoRouter Route Definition Pattern

**Decision**: Use `builder` (not `pageBuilder`) for the `/register-success` route definition.

**Rationale**: `builder` uses the platform's default page transition and is the simplest approach. The codebase reserves `pageBuilder` + `CustomTransitionPage` only for routes needing custom transitions — currently only `/onboarding` uses a fade. All other routes (`/login`, `/register`, `/support`, `/home`, etc.) use `builder`. Since the Sign-Up Success Page is reached via `context.go()` (full stack replacement, which produces no animation for top-level routes), `CustomTransitionPage` adds no visual benefit.

**Alternatives considered**:
- `pageBuilder` + `CustomTransitionPage` with fade — rejected: `context.go()` already has no animation for top-level routes
- `NoTransitionPage` — rejected: `builder` already defaults to this behavior when reached via `context.go()`

---

## R4. Theme Background Color Discrepancy

**Decision**: Use `AppColors.background` (existing `#F3F4F6` light gray) for the page background, NOT a custom dark color.

**Rationale**: The original user description mentioned "dark background" but the app's established theme uses `AppColors.background = Color(0xFFF3F4F6)` — a light gray. The Sign-Up Page, Login Page, and all other auth pages use this same background. Using a custom dark color would be visually inconsistent with the rest of the app. The spec's FR-012 says "dark background consistent with the app's existing theme" — since the existing theme IS `#F3F4F6`, consistency takes precedence over the word "dark." The white container/card (FR-013) still provides visual contrast against the light background, matching the Sign-Up Page pattern which uses `AppColors.surface` (white) for the card.

**Alternatives considered**:
- Custom dark background color — rejected: inconsistent with all other app screens
- New `AppColors.darkBackground` constant — rejected: adds theming complexity for a single screen

---

## R5. Illustration Asset

**Decision**: Use an existing illustration asset from `assets/images/` or a placeholder that will be replaced later.

**Rationale**: The `assets/images/` directory currently contains `changepassword.png`, `forgetpassword.png`, and `Start.png`. The spec assumes "the illustration image asset will be provided and placed in the app's assets directory before development begins." The implementation should reference the asset by a clear name (e.g., `assets/images/registration_success.png`) and the asset can be added during development. If no dedicated asset is provided, `Start.png` could serve as a temporary placeholder.

**Alternatives considered**:
- Inline SVG or drawn illustration — rejected: project uses PNG assets exclusively
- No illustration (text only) — rejected: spec explicitly requires an illustration (FR-003)

---

## R6. Localization Keys

**Decision**: Add two localization keys following the existing `signUp*` naming convention: `signUpSuccessMessage` and `signUpSuccessButton`.

**Rationale**: The codebase uses `signUp*` prefix for all sign-up related strings (e.g., `signUpTitle`, `signUpButton`, `signUpEmail`). Following this convention maintains consistency and discoverability. Only two strings need localization:
1. "You are successfully registered!" → `signUpSuccessMessage`
2. "Let's Start →" → `signUpSuccessButton`

The WASLA logo text is not localized (it's a brand name rendered via `WaslaLogo` widget).

**Alternatives considered**:
- `registrationSuccess*` prefix — rejected: inconsistent with existing `signUp*` convention
- Hardcoded strings — rejected: app already supports English/Arabic localization

---

## R7. Route Path Naming

**Decision**: Use `/register-success` as the route path, with `registerSuccess` as the `AppRouter` constant name.

**Rationale**: The existing route for the sign-up page is `AppRouter.register = '/register'`. Appending `-success` creates a clear relationship: `/register` → `/register-success`. This follows the kebab-case URL pattern used throughout (`/forgot-password`). The constant name `registerSuccess` follows the camelCase pattern of existing constants (`forgotPassword`).

**Alternatives considered**:
- `/signup-success` — rejected: route uses "register" (not "signup") despite the class being `SignUpPage`
- `/register/success` (nested) — rejected: GoRouter nested routes require sub-route configuration; unnecessary complexity for a flat route
