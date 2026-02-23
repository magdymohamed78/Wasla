# Wasla Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-02-23

## Active Technologies
- Dart SDK ^3.11.0 / Flutter 3.11+ + flutter_bloc 8.1.6, go_router 14.8.1, dio 5.7.0, shared_preferences 2.3.3, flutter_localizations + intl (020-company-signup)

## Project Structure

```text
lib/
├── core/
│   ├── localization/l10n/
│   │   ├── app_en.arb
│   │   └── app_ar.arb
│   ├── routing/app_router.dart
│   └── utils/validators.dart
├── features/auth/
│   ├── data/
│   │   ├── data_sources/
│   │   │   ├── auth_local_data_source.dart
│   │   │   └── auth_remote_data_source.dart
│   │   ├── models/
│   │   │   ├── login_request_model.dart
│   │   │   ├── login_response_model.dart
│   │   │   └── register_request_model.dart
│   │   └── repositories/auth_repository_impl.dart
│   ├── domain/
│   │   ├── entities/login_entity.dart
│   │   ├── repositories/auth_repository.dart
│   │   └── use_cases/
│   │       ├── login_use_case.dart
│   │       └── register_use_case.dart
│   └── presentation/
│       ├── cubit/
│       │   ├── login_cubit.dart
│       │   ├── login_state.dart
│       │   ├── register_cubit.dart
│       │   └── register_state.dart
│       ├── pages/
│       │   ├── login_page.dart
│       │   └── sign_up_page.dart
│       └── widgets/
│           ├── login_form.dart
│           └── sign_up_form.dart
├── features/home/presentation/pages/home_placeholder_page.dart
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

## API Endpoints

- `POST /api/customer-portal/login` - Customer login
- `POST /api/customer-portal/register` - Customer registration (returns same `CustomerLoginResultDto`)

## Recent Changes
- 020-company-signup: Customer portal sign up page with form fields (First Name, Last Name, Phone Number, Email, Password, Confirm Password). New files: RegisterRequestModel, RegisterUseCase, RegisterCubit/State, SignUpPage, SignUpForm. Extends AuthRepository with register() method. Visual consistency with login page. RTL (Arabic) support.

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
