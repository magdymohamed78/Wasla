# Wasla Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-02-24

## Active Technologies
- Dart SDK ^3.11.0 / Flutter 3.11+ + flutter_bloc 8.1.6, go_router 14.8.1, dio 5.7.0, shared_preferences 2.3.3, flutter_secure_storage ^9.2.4, flutter_localizations + intl (023-login-remember-me)

## Project Structure

```text
lib/
├── core/
│   ├── localization/l10n/
│   │   ├── app_en.arb
│   │   └── app_ar.arb
│   ├── networking/
│   │   └── auth_interceptor.dart
│   ├── routing/app_router.dart
│   └── utils/validators.dart
├── features/auth/
│   ├── data/
│   │   ├── data_sources/
│   │   │   ├── auth_local_data_source.dart
│   │   │   ├── auth_remote_data_source.dart
│   │   │   ├── secure_auth_local_data_source.dart
│   │   │   └── in_memory_auth_local_data_source.dart
│   │   ├── models/
│   │   │   ├── login_request_model.dart
│   │   │   ├── login_response_model.dart
│   │   │   ├── refresh_token_request_model.dart
│   │   │   ├── refresh_token_response_model.dart
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
│       │   ├── sign_up_page.dart
│       │   └── sign_up_success_page.dart
│       └── widgets/
│           ├── login_form.dart
│           └── sign_up_form.dart
├── features/splash/
│   └── presentation/
│       ├── cubit/
│       │   ├── splash_cubit.dart
│       │   └── splash_state.dart
│       └── pages/
│           └── splash_page.dart
├── features/home/presentation/pages/home_placeholder_page.dart
├── app.dart
├── main.dart
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

- `POST /api/customer-portal/login` - Customer login (includes `rememberMe` boolean)
- `POST /api/customer-portal/register` - Customer registration (returns same `CustomerLoginResultDto`)
- `POST /api/customer-portal/refresh-token` - Refresh access token (returns rotated refresh token)

## Routes

| Route | Constant | Page | Description |
|-------|----------|------|-------------|
| `/` | `splash` | SplashPage | App entry point (auth check on launch) |
| `/onboarding` | `onboarding` | OnboardingPage | Onboarding slides |
| `/support` | `support` | SupportPage | Support page |
| `/login` | `login` | LoginPage | Customer login |
| `/register` | `register` | SignUpPage | Customer registration |
| `/register-success` | `registerSuccess` | SignUpSuccessPage | Post-registration confirmation (back disabled) |
| `/forgot-password` | `forgotPassword` | ForgotPasswordPage | Password recovery |
| `/home` | `home` | HomePlaceholderPage | Main app (auth required) |

## Secure Storage Keys (023-login-remember-me)

| Key | Value Type | Written When |
|-----|------------|--------------|
| `auth_token` | String | Login (Remember Me ON) or Refresh success |
| `refresh_token` | String | Login (Remember Me ON) or Refresh success |
| `refresh_token_expiry` | String (ISO 8601) | Login (Remember Me ON) or Refresh success |
| `remember_me` | String ("true") | Login (Remember Me ON) |
| `user_id` | String (int) | Login (Remember Me ON) or Refresh success |
| `customer_id` | String (int) | Login (Remember Me ON) or Refresh success (if present) |
| `lead_id` | String (int) | Login (Remember Me ON) or Refresh success (if present) |
| `first_name` | String | Login (Remember Me ON) or Refresh success |
| `last_name` | String | Login (Remember Me ON) or Refresh success |
| `user_email` | String | Login (Remember Me ON) or Refresh success |

**Storage Strategy**:
- **Remember Me ON**: `SecureAuthLocalDataSource` (FlutterSecureStorage) — persists to disk
- **Remember Me OFF**: `InMemoryAuthLocalDataSource` (Map) — lives in memory only, cleared on app kill

## Localization Keys (022-registration-success-page)

| Key | English | Arabic |
|-----|---------|--------|
| `signUpSuccessMessage` | "You are successfully registered!" | "تم تسجيلك بنجاح!" |
| `signUpSuccessButton` | "Let's Start" | "لنبدأ" |

## Recent Changes
- 023-login-remember-me: Functional Remember Me checkbox with secure token storage (FlutterSecureStorage), refresh token flow for auto-login, Dio interceptor for transparent mid-session token refresh, two storage strategies (SecureAuthLocalDataSource for Remember Me ON, InMemoryAuthLocalDataSource for Remember Me OFF). New endpoint: POST /api/customer-portal/refresh-token.
- 022-registration-success-page: Sign-Up Success Page shown after successful registration. Static page with WASLA logo, illustration, success message, and "Let's Start" CTA button. Navigates to Login Page with `context.go()` (clears stack). Back navigation disabled via `PopScope(canPop: false)`. Route: `/register-success`.
- 020-company-signup: Customer portal sign up page with form fields (First Name, Last Name, Phone Number, Email, Password, Confirm Password). New files: RegisterRequestModel, RegisterUseCase, RegisterCubit/State, SignUpPage, SignUpForm. Extends AuthRepository with register() method. Visual consistency with login page. RTL (Arabic) support.

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
