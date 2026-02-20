# Tasks: Customer Login

**Input**: Design documents from `/specs/009-customer-login/`
**Prerequisites**: spec.md (required), constitution.md

## Phase 1: Infrastructure & Dependencies

- [X] T001 Add `dio` dependency to pubspec.yaml and run `flutter pub get`
- [X] T002 Add login-related l10n keys to app_en.arb and app_ar.arb, then regenerate

## Phase 2: Data Layer (Clean Architecture — Data)

- [X] T003 Create `LoginRequestModel` in `lib/features/auth/data/models/login_request_model.dart`
- [X] T004 Create `LoginResponseModel` in `lib/features/auth/data/models/login_response_model.dart`
- [X] T005 Create `AuthRemoteDataSource` abstract + impl in `lib/features/auth/data/data_sources/auth_remote_data_source.dart`
- [X] T006 Create `AuthRepositoryImpl` in `lib/features/auth/data/repositories/auth_repository_impl.dart`

## Phase 3: Domain Layer (Clean Architecture — Domain)

- [X] T007 Create `LoginEntity` in `lib/features/auth/domain/entities/login_entity.dart`
- [X] T008 Create `AuthRepository` abstract interface in `lib/features/auth/domain/repositories/auth_repository.dart`
- [X] T009 Create `LoginUseCase` in `lib/features/auth/domain/use_cases/login_use_case.dart`

## Phase 4: Presentation Layer — State Management

- [X] T010 Create `LoginState` in `lib/features/auth/presentation/cubit/login_state.dart`
- [X] T011 Create `LoginCubit` in `lib/features/auth/presentation/cubit/login_cubit.dart`

## Phase 5: Presentation Layer — UI Widgets

- [X] T012 Create `LoginForm` widget in `lib/features/auth/presentation/widgets/login_form.dart`
- [X] T013 Create `LoginPage` in `lib/features/auth/presentation/pages/login_page.dart`

## Phase 6: Integration & Wiring

- [X] T014 Update `AppRouter` to use `LoginPage` instead of `LoginPlaceholderPage`
- [X] T015 Wire up DI in `app.dart` — provide Dio, AuthRemoteDataSource, AuthRepository, LoginCubit

## Phase 7: Validation

- [X] T016 Run `flutter analyze` and fix any issues
- [ ] T017 Run app and verify login flow *(manual — requires device/emulator)*
