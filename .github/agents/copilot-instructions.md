# Wasla Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-02-19

## Active Technologies
- Dart (null-safe), SDK ^3.11.0 + flutter_bloc ^8.1.6, go_router ^14.8.1, dio ^5.7.0, shared_preferences ^2.3.3 (010-customer-login)
- shared_preferences (token persistence), secure_storage (optional — see research.md) (010-customer-login)
- shared_preferences (token persistence via abstract `AuthLocalDataSource` interface) (010-customer-login)
- Dart 3.11 / Flutter (latest stable) + flutter_bloc 8.1.6, dio 5.7.0, go_router 14.8.1, flutter_localizations (011-login-error-handling)
- SharedPreferences (session persistence only, not affected by this feature) (011-login-error-handling)
- Dart SDK ^3.11.0, Flutter 3.11+ (latest stable) + flutter_bloc 8.1.6, go_router 14.8.1, dio 5.7.0, shared_preferences 2.3.3, flutter_localizations + intl (020-company-signup)
- SharedPreferences (session token + user data persistence via AuthLocalDataSource) (020-company-signup)
- N/A (static page, no persistence) (022-registration-success-page)

- Dart (null-safe), SDK ^3.11.0 + flutter_bloc (Cubit), go_router, flutter_localizations, intl (006-fix-logo-rtl)

## Project Structure

```text
src/
tests/
```

## Commands

# Add commands for Dart (null-safe), SDK ^3.11.0

## Code Style

Dart (null-safe), SDK ^3.11.0: Follow standard conventions

## Recent Changes
- 022-registration-success-page: Added Dart (null-safe), SDK ^3.11.0 + flutter_bloc (Cubit), go_router, flutter_localizations, intl
- 020-company-signup: Added Dart SDK ^3.11.0, Flutter 3.11+ (latest stable) + flutter_bloc 8.1.6, go_router 14.8.1, dio 5.7.0, shared_preferences 2.3.3, flutter_localizations + intl
- 011-login-error-handling: Added Dart 3.11 / Flutter (latest stable) + flutter_bloc 8.1.6, dio 5.7.0, go_router 14.8.1, flutter_localizations


<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
