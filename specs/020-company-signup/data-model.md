# Data Model: Customer Portal Sign Up

**Branch**: `020-company-signup` | **Date**: 2026-02-23

## Entities

### LoginEntity (REUSED — no changes)

Represents a successfully authenticated user. Returned by both login and registration endpoints since both return `CustomerLoginResultDto`.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| token | String | JWT authentication token | Required, non-empty |
| userId | int | Internal user ID | Required |
| customerId | int? | Customer ID (null for Leads) | Nullable |
| leadId | int? | Lead ID (set after registration) | Nullable |
| firstName | String | User's first name | Required |
| lastName | String | User's last name | Required |
| email | String | User's email address | Required |

**Location**: `lib/features/auth/domain/entities/login_entity.dart` (existing, unchanged)

**Note**: After registration, `leadId` will be populated and `customerId` will be null (user is a Lead, not yet linked to a company).

---

## Data Models

### RegisterRequestModel (NEW)

Represents the request body for `POST /api/customer-portal/register`. Maps to `CustomerRegisterDto` in the Swagger schema.

| Field | Type | JSON Key | Required | Constraints |
|-------|------|----------|----------|-------------|
| email | String | `email` | Yes | max 256, email format |
| password | String | `password` | Yes | min 6 chars |
| firstName | String | `firstName` | Yes | max 100, non-empty |
| lastName | String | `lastName` | Yes | max 100, non-empty |
| phoneNumber | String? | `phoneNumber` | No | max 50, nullable |

**Location**: `lib/features/auth/data/models/register_request_model.dart`

**Methods**:
- `toJson() → Map<String, dynamic>` — Serializes to JSON for API request. Omits `phoneNumber` key if null.

---

### LoginResponseModel (REUSED — no changes)

The register endpoint returns `CustomerLoginResultDto` — the same schema used by login. No new response model needed.

**Location**: `lib/features/auth/data/models/login_response_model.dart` (existing, unchanged)

---

## State Classes

### RegisterState (NEW)

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| firstName | String | `''` | First name field value |
| lastName | String | `''` | Last name field value |
| phoneNumber | String | `''` | Phone number field value |
| email | String | `''` | Email field value |
| password | String | `''` | Password field value |
| confirmPassword | String | `''` | Confirm password field value |
| obscurePassword | bool | `true` | Password visibility toggle |
| obscureConfirmPassword | bool | `true` | Confirm password visibility toggle |
| status | RegisterStatus | `initial` | Submission status |
| errorCode | RegisterErrorCode? | `null` | Server error identifier |
| errorCategory | RegisterErrorCategory? | `null` | Error display strategy |
| user | LoginEntity? | `null` | User data on success |
| firstNameError | String? | `null` | Validation error key |
| lastNameError | String? | `null` | Validation error key |
| emailError | String? | `null` | Validation error key |
| passwordError | String? | `null` | Validation error key |
| confirmPasswordError | String? | `null` | Validation error key |
| phoneError | String? | `null` | Validation error key |
| hasSubmitted | bool | `false` | First submit flag (lazy validation) |
| serverErrorMessage | String? | `null` | Raw server error for snackbar |

**Location**: `lib/features/auth/presentation/cubit/register_state.dart`

**Pattern**: Immutable class with `copyWith()` — matches `LoginState` pattern.

---

### RegisterStatus (Enum, NEW)

| Value | Description |
|-------|-------------|
| initial | Form loaded, no submission attempted |
| loading | Registration request in flight |
| success | Account created, session stored |
| failure | Server rejected request or network error |

**State Transitions**:
```
initial → loading → success
initial → loading → failure → initial (user corrects and resubmits)
```

**Location**: `lib/features/auth/presentation/cubit/register_state.dart`

---

### RegisterErrorCode (Enum, NEW)

| Value | HTTP Status | Description |
|-------|-------------|-------------|
| emailAlreadyRegistered | 409 | Email is already in use |
| validationError | 400 | Field-specific validation error from server |
| badRequest | 400 | Generic bad request (non-field-specific) |
| networkError | — | Connection timeout/error |
| serverError | 500/502/503 | Server-side error |
| unexpectedError | — | Catch-all for unknown errors |

**Location**: `lib/features/auth/presentation/cubit/register_state.dart`

---

### RegisterErrorCategory (Enum, NEW)

| Value | Display Strategy |
|-------|------------------|
| field | Inline error below the relevant form field |
| server | Floating snackbar with retry option |
| network | Floating snackbar with retry option |

**Location**: `lib/features/auth/presentation/cubit/register_state.dart`

---

## Repository Interfaces

### AuthRepository (EXTENDED)

Add one method to the existing abstract interface:

| Method | Return Type | Description |
|--------|-------------|-------------|
| register(email, password, firstName, lastName, phoneNumber?) | Future\<LoginEntity\> | Registers a new Lead account and persists session |

**Location**: `lib/features/auth/domain/repositories/auth_repository.dart`

Existing methods (unchanged):
- `login(email, password) → Future<LoginEntity>`
- `getStoredSession() → Future<LoginEntity?>`
- `saveSession(LoginEntity) → Future<void>`
- `clearSession() → Future<void>`

---

### AuthRemoteDataSource (EXTENDED)

Add one method to the existing abstract interface:

| Method | Return Type | Description |
|--------|-------------|-------------|
| register(RegisterRequestModel) | Future\<LoginResponseModel\> | POST /api/customer-portal/register |

**Location**: `lib/features/auth/data/data_sources/auth_remote_data_source.dart`

---

## Use Cases

### RegisterUseCase (NEW)

| Method | Parameters | Return Type | Description |
|--------|------------|-------------|-------------|
| call() | email, password, firstName, lastName, phoneNumber? | Future\<LoginEntity\> | Delegates to AuthRepository.register() |

**Location**: `lib/features/auth/domain/use_cases/register_use_case.dart`

**Pattern**: Single-responsibility, constructor-injected `AuthRepository`. Matches `LoginUseCase` pattern exactly.

---

## Relationships

```
SignUpPage (StatelessWidget)
├── BlocListener<RegisterCubit, RegisterState>
│   └── on success → context.go('/home')
│   └── on failure (server/network) → showSnackBar
├── WaslaLogo + "ASLA" row
└── Card container
    ├── "Sign Up" title
    ├── SignUpForm (StatelessWidget)
    │   └── BlocBuilder<RegisterCubit, RegisterState>
    │       ├── TextFormField × 6 (reads state, dispatches to cubit)
    │       └── PrimaryButton (on tap → cubit.register())
    └── "Already have an account? Log In" link → context.push('/login')

RegisterCubit
├── depends on → RegisterUseCase
├── depends on → AuthRepository (for session save)
├── emits → RegisterState
└── methods: firstNameChanged(), lastNameChanged(), phoneChanged(),
             emailChanged(), passwordChanged(), confirmPasswordChanged(),
             togglePasswordVisibility(), toggleConfirmPasswordVisibility(),
             register()

RegisterUseCase
└── depends on → AuthRepository.register()

AuthRepositoryImpl
├── depends on → AuthRemoteDataSource.register()
├── depends on → AuthLocalDataSource.saveToken() + saveUser()
└── register() flow:
    1. Trim inputs
    2. Call remote.register(RegisterRequestModel)
    3. Convert response to LoginEntity via .toEntity()
    4. Save token + user locally
    5. Return entity

AuthRemoteDataSourceImpl
└── register(RegisterRequestModel) flow:
    1. POST /api/customer-portal/register with model.toJson()
    2. Parse response as LoginResponseModel.fromJson()
    3. Return model (or rethrow DioException)
```

---

## Validation Rules Summary

| Field | Rule | Error Key |
|-------|------|-----------|
| First Name | Non-empty | `name_empty` |
| First Name | ≤ 100 chars | `name_too_long` |
| Last Name | Non-empty | `name_empty` |
| Last Name | ≤ 100 chars | `name_too_long` |
| Phone Number | ≤ 50 chars (if provided) | `phone_too_long` |
| Email | Non-empty | `email_empty` |
| Email | Valid format (regex) | `email_invalid` |
| Password | Non-empty | `password_empty` |
| Password | ≥ 6 chars | `password_too_short` |
| Confirm Password | Non-empty | `confirm_password_empty` |
| Confirm Password | Matches password | `confirm_password_mismatch` |
