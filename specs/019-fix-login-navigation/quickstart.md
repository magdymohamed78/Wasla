# Quickstart: Fix Login Navigation to Home Screen

**Feature**: 019-fix-login-navigation  
**Date**: 2026-02-23

## Problem

After a successful login, the app does not navigate to the Home screen. The backend returns a valid response, the session is saved, and `LoginStatus.success` is emitted — but the user stays on the login screen.

## Root Cause

`AuthLocalDataSourceImpl.getUser()` requires `customerId` to be non-null in its validation check, but `LoginEntity.customerId` is `int?` (nullable). When the API returns `customerId: null`:

1. `saveUser()` correctly removes the `customer_id` key from SharedPreferences
2. `getUser()` reads `customer_id` as null → fails the null check → returns null
3. The `/home` route redirect guard calls `getStoredSession()` → gets null → redirects to `/login`
4. The user is silently bounced back to login

## Files to Change

| File | Change |
|------|--------|
| `lib/features/auth/data/data_sources/auth_local_data_source.dart` | Fix `getUser()`: remove `customerId` from the required-null check, pass it as optional to `LoginEntity` |

## How to Verify

1. Run the app and log in with valid credentials
2. Observe that after login, the Home screen appears
3. Press the system back button — should NOT return to login
4. Force-close and reopen the app — should go directly to Home (session persisted)

## Testing

```bash
# Run existing tests
flutter test

# Run auth-specific tests  
flutter test test/features/auth/
```

## Key Architecture Notes

- **Navigation**: `context.go()` (GoRouter) replaces the current route — correct for login→home
- **State management**: flutter_bloc Cubit pattern
- **Session persistence**: SharedPreferences (key-value store)
- **Route protection**: Per-route async `redirect` on the `/home` GoRoute
