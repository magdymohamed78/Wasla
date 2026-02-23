# Wasla Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-02-23

## Active Technologies
- Dart 3.11 / Flutter 3.11+ + flutter_bloc 8.1.6, go_router 14.8.1, dio 5.7.0, shared_preferences 2.3.3 (019-fix-login-navigation)

## Project Structure

```text
lib/
├── features/auth/
│   ├── data/data_sources/auth_local_data_source.dart
│   ├── domain/entities/login_entity.dart
│   └── presentation/
│       ├── cubit/login_cubit.dart
│       └── pages/login_page.dart
├── core/routing/app_router.dart
test/
```

## Commands

- `flutter test` - Run tests
- `flutter analyze` - Static analysis

## Code Style

Dart 3.11 / Flutter 3.11+: Follow standard conventions

## Architecture

Flutter Clean Architecture with:
- **Domain layer**: Entities, repositories (interfaces), use cases
- **Data layer**: Repository implementations, data sources (local/remote), models
- **Presentation layer**: BLoC/Cubit, pages, widgets

## Recent Changes
- 019-fix-login-navigation: Bug fix for login navigation - `AuthLocalDataSourceImpl.getUser()` incorrectly required non-null `customerId` but `LoginEntity.customerId` is `int?` (nullable). Fix: make `customerId` optional in the null check. Root cause: field nullability mismatch between domain entity and local data source read method.

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
