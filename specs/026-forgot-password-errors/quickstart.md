# Quickstart: Update Forgot Password Endpoint Error Handling

**Feature**: 026-forgot-password-errors  
**Branch**: `026-forgot-password-errors`

## Prerequisites

- Flutter SDK (Dart ^3.11.0)
- Project dependencies installed: `flutter pub get`
- Existing codebase on branch `026-forgot-password-errors`

## What Changes

| # | File | Change |
|---|------|--------|
| 1 | `lib/features/auth/presentation/cubit/forgot_password_cubit.dart` | Add `404 → 'notFound'` and `403 → 'inactive'` in `_mapDioError` |
| 2 | `lib/features/auth/presentation/pages/forgot_password_page.dart` | Add `'notFound'` and `'inactive'` cases in `_mapErrorMessage`; for `'inactive'`, show snackbar with "Contact Support" action button → Support page |
| 3 | `lib/features/auth/presentation/widgets/forgot_password_form.dart` | Add static sign-up link widget below Submit button |
| 4 | `lib/core/localization/l10n/app_en.arb` | Add 4 new localization keys |
| 5 | `lib/core/localization/l10n/app_ar.arb` | Add 4 new localization keys (Arabic) |
| 6 | `test/features/auth/presentation/cubit/forgot_password_cubit_test.dart` | Add tests for 404 and 403 error mapping |
| 7 | `test/features/auth/presentation/pages/forgot_password_page_test.dart` | Add tests for sign-up link visibility and navigation |

## Implementation Order

1. **Localization first** — Add ARB keys so generated code is available
2. **Cubit error mapping** — Extend `_mapDioError` with 404/403 cases
3. **Page toast mapping** — Extend `_mapErrorMessage` with new keys
4. **Form sign-up link** — Add `_SignUpLink` widget to form
5. **Tests** — Cubit unit tests, then widget tests

## How to Verify

```bash
# Run localization generation
flutter gen-l10n

# Run all forgot-password tests
flutter test test/features/auth/presentation/cubit/forgot_password_cubit_test.dart
flutter test test/features/auth/presentation/pages/forgot_password_page_test.dart

# Run full test suite (regression check)
flutter test
```

## Key Design Decisions

- **No new state enum values** — Error discrimination uses `errorMessage` string keys (existing pattern)
- **No data layer changes** — DioException already propagates status codes
- **Static sign-up link** — Always visible per clarification, not conditional on error state
- **Toast with action** — 403 snackbar includes a "Contact Support" action button navigating to Support page; 404 is toast-only
