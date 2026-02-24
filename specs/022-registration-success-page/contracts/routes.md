# Route Contract: Sign-Up Success Page

**Branch**: `022-registration-success-page` | **Date**: 2026-02-24

## New Route

| Property | Value |
|----------|-------|
| Path | `/register-success` |
| Constant | `AppRouter.registerSuccess` |
| Page Widget | `SignUpSuccessPage` |
| Route Type | `GoRoute` with `builder` |
| Navigation Method | `context.go()` (declarative, stack-replacing) |

## Route Definition (AppRouter)

```dart
// In AppRouter class:
static const String registerSuccess = '/register-success';

// In GoRouter routes list:
GoRoute(
  path: registerSuccess,
  builder: (context, state) => const SignUpSuccessPage(),
),
```

## Navigation Flows

### Inbound (how users reach this page)

| From | Trigger | Method | Condition |
|------|---------|--------|-----------|
| `SignUpPage` | `RegisterStatus.success` | `context.go(AppRouter.registerSuccess)` | Registration API returns 200/201 |

### Outbound (where users go from this page)

| To | Trigger | Method | Data Passed |
|----|---------|--------|-------------|
| `LoginPage` | "Let's Start →" button tap | `context.go(AppRouter.login)` | None |

### Blocked Navigation

| Action | Behavior | Implementation |
|--------|----------|----------------|
| Hardware back button | No-op (stays on page) | `PopScope(canPop: false)` |
| Swipe-back gesture | No-op (stays on page) | `PopScope(canPop: false)` |

## Modified Route Behavior

### SignUpPage Success Handler (BEFORE)

```dart
if (state.status == RegisterStatus.success) {
  context.go(AppRouter.home);
}
```

### SignUpPage Success Handler (AFTER)

```dart
if (state.status == RegisterStatus.success) {
  context.go(AppRouter.registerSuccess);
}
```
