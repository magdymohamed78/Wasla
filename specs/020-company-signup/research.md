# Research: Customer Portal Sign Up

**Branch**: `020-company-signup` | **Date**: 2026-02-23

## R1. Registration Data Flow & Model Reuse

**Decision**: Reuse `LoginEntity` and `LoginResponseModel` for the registration response. Create a new `RegisterRequestModel` for the request body.

**Rationale**: The `POST /api/customer-portal/register` endpoint returns `CustomerLoginResultDto` — the exact same schema as `POST /api/customer-portal/login`. The response contains `token`, `userId`, `customerId` (nullable), `leadId` (nullable), `firstName`, `lastName`, `email`. Creating a separate `RegisterEntity` or `RegisterResponseModel` would duplicate 100% of the code with zero semantic difference. The request body is different (adds firstName, lastName, phoneNumber, removes nothing), so a new `RegisterRequestModel` is needed.

**Alternatives considered**:
- Separate `RegisterEntity` + `RegisterResponseModel` — rejected: identical fields, violates DRY, adds maintenance burden for zero benefit.
- Generic `AuthResponseModel` renaming — rejected: would require renaming existing `LoginResponseModel` across all files, breaking the login feature unnecessarily.

### RegisterRequestModel Fields

| Field | Type | JSON Key | Required | Constraints |
|-------|------|----------|----------|-------------|
| email | String | `email` | Yes | max 256, email format |
| password | String | `password` | Yes | min 6 chars |
| firstName | String | `firstName` | Yes | max 100, non-empty |
| lastName | String | `lastName` | Yes | max 100, non-empty |
| phoneNumber | String? | `phoneNumber` | No | max 50, nullable |

### Data Flow

```
SignUpForm → RegisterCubit.register()
  → RegisterUseCase.call(email, password, firstName, lastName, phoneNumber?)
    → AuthRepository.register(email, password, firstName, lastName, phoneNumber?)
      → AuthRepositoryImpl.register()
        → AuthRemoteDataSource.register(RegisterRequestModel)
          → Dio POST /api/customer-portal/register
          ← LoginResponseModel.fromJson(response.data)
          ← LoginResponseModel.toEntity() → LoginEntity
        → AuthLocalDataSource.saveToken(entity.token)
        → AuthLocalDataSource.saveUser(entity)
      ← LoginEntity
    ← LoginEntity
  ← RegisterCubit emits RegisterStatus.success with LoginEntity
→ BlocListener navigates to home
```

---

## R2. Error Handling Strategy

**Decision**: Mixed error display — field-specific errors (409 email duplicate, 400 field validation) inline below the relevant field; general errors (500/network) as floating snackbar. Use error codes (enum) in state, map to localized messages in presentation.

**Rationale**: Follows the clarified requirement from the spec. Field-specific errors are more actionable when shown inline. General errors don't relate to a specific field, so a snackbar is the appropriate UX pattern. This mirrors the login page's snackbar pattern for network/server errors while adding inline error support for registration-specific scenarios.

**Alternatives considered**:
- All errors as snackbar (login page pattern) — rejected: 409 "email already registered" is far more actionable when shown inline below the email field.
- All errors inline — rejected: 500/network errors have no relevant field to attach to.

### Error Code Mapping

| HTTP Status | Condition | Error Code | Error Category | Display |
|-------------|-----------|------------|----------------|---------|
| 409 | Email already in use | `emailAlreadyRegistered` | `field` | Inline below email field |
| 400 | Field validation error | `validationError` | `field` | Inline below relevant field (parse `message`) |
| 400 | Generic bad request | `badRequest` | `general` | Snackbar |
| 500/502/503 | Server error | `serverError` | `server` | Snackbar with retry |
| Connection timeout/error | Network issue | `networkError` | `network` | Snackbar with retry |
| Unknown | Unexpected | `unexpectedError` | `server` | Snackbar |

### Server Error Response Format

From `error-responses.md`, the register endpoint returns:
```json
{ "message": "Human-readable error description" }
```

Key responses:
- 400: `{ "message": "Password must contain..." }` — may contain field hint
- 409: `{ "message": "Email already in use." }` — always email-specific
- 500: `{ "message": "An unexpected error occurred. Please try again later." }`

### 409 Detection

The 409 status code is unambiguous — it always means "email already in use" per the API contract. No need to parse the response body for this case. Directly map to inline error on the email field.

### 400 Field Extraction

For 400 responses, the server returns a `message` string. Strategy:
1. If status is 400, extract `response.data['message']` as a string
2. Store in `RegisterState.serverErrorMessage` for display
3. The cubit sets the appropriate field error based on keyword matching (e.g., "password" → passwordError, "email" → emailError)
4. If no field can be determined, display as snackbar

---

## R3. Validation Architecture

**Decision**: Extend existing `Validators` utility class with `validateName()`, `validatePhone()`, `validatePasswordLength()`, and add a `validateConfirmPassword()` method in `RegisterCubit`. Validate on field change after first submit (lazy validation, matching login pattern).

**Rationale**: The login page uses `Validators.validateEmail()` and `Validators.validatePassword()` which return error code strings (e.g., `'email_empty'`, `'email_invalid'`). Registration needs the same pattern plus new validators for name, phone, password length, and confirm password match. Keeping validators in the shared utility class ensures consistency and reusability.

**Alternatives considered**:
- Form-level validation with `Form` widget + `GlobalKey<FormState>` — rejected: login doesn't use the `Form` widget, it uses `BlocBuilder` with manual field validation. Mixing patterns would be inconsistent.
- Separate `RegisterValidators` class — rejected: validators are generic utilities (name validation, phone validation) that could be reused across the app.

### New Validator Methods

| Method | Input | Returns | Error Codes |
|--------|-------|---------|-------------|
| `validateName(String name)` | Name string | `String?` | `'name_empty'`, `'name_too_long'` |
| `validatePhone(String? phone)` | Phone string (nullable) | `String?` | `'phone_too_long'` |
| `validatePasswordLength(String password)` | Password string | `String?` | `'password_empty'`, `'password_too_short'` |

### Confirm Password Validation

Confirm password validation depends on the password field value, so it cannot be a static utility method. It is handled in `RegisterCubit`:
```dart
String? _validateConfirmPassword(String confirmPassword) {
  if (confirmPassword.isEmpty) return 'confirm_password_empty';
  if (confirmPassword != state.password) return 'confirm_password_mismatch';
  return null;
}
```

### Lazy Validation Pattern

Matching the login cubit's `emailChanged`/`passwordChanged` pattern:
1. On first field change: no validation errors shown
2. After first submit attempt (`hasSubmitted = true`): validate on every change
3. This prevents jarring errors while the user is still typing for the first time

---

## R4. State Management Design

**Decision**: Separate `RegisterCubit` + `RegisterState` (not extending or reusing `LoginCubit`). Same architectural pattern but independent state lifecycle.

**Rationale**: Registration has fundamentally different state requirements than login: 6 form fields vs 2, confirm password matching, no "remember me", no rate limiting, different error codes. Sharing a cubit would create a monolith with conditional logic. Separate cubits follow the single-responsibility principle.

**Alternatives considered**:
- Shared `AuthCubit` with mode flag — rejected: violates SRP, state class becomes bloated with unused fields per mode.
- Extension/inheritance of `LoginCubit` — rejected: only ~30% of login cubit logic applies to registration. Inheritance would force overriding most methods.

### RegisterState Fields

| Field | Type | Default | Purpose |
|-------|------|---------|---------|
| firstName | String | `''` | First name field value |
| lastName | String | `''` | Last name field value |
| phoneNumber | String | `''` | Phone number field value |
| email | String | `''` | Email field value |
| password | String | `''` | Password field value |
| confirmPassword | String | `''` | Confirm password field value |
| obscurePassword | bool | `true` | Password visibility toggle |
| obscureConfirmPassword | bool | `true` | Confirm password visibility toggle |
| status | RegisterStatus | `initial` | Form submission status |
| errorCode | RegisterErrorCode? | `null` | Server error code |
| errorCategory | RegisterErrorCategory? | `null` | Error display strategy |
| user | LoginEntity? | `null` | Returned user on success |
| firstNameError | String? | `null` | First name validation error key |
| lastNameError | String? | `null` | Last name validation error key |
| emailError | String? | `null` | Email validation error key |
| passwordError | String? | `null` | Password validation error key |
| confirmPasswordError | String? | `null` | Confirm password validation error key |
| phoneError | String? | `null` | Phone validation error key |
| hasSubmitted | bool | `false` | Whether form was submitted at least once |
| serverErrorMessage | String? | `null` | Raw server error message for display |

### RegisterStatus Enum

```dart
enum RegisterStatus { initial, loading, success, failure }
```

### RegisterErrorCode Enum

```dart
enum RegisterErrorCode {
  emailAlreadyRegistered,  // 409
  validationError,         // 400 field-specific
  badRequest,              // 400 generic
  networkError,            // connection issues
  serverError,             // 500/502/503
  unexpectedError,         // catch-all
}
```

### RegisterErrorCategory Enum

```dart
enum RegisterErrorCategory { field, server, network }
```

---

## R5. UI Layout Architecture

**Decision**: `SignUpPage` (StatelessWidget) mirrors `LoginPage` structure exactly. `SignUpForm` (StatelessWidget) mirrors `LoginForm` but with 6 fields + no "remember me" / "forgot password".

**Rationale**: FR-022–FR-024 require visual consistency with the login page. The simplest way to guarantee this is to replicate the same widget structure, using the same `AppColors`, `AppTypography`, `AppDimensions` constants, the same `WaslaLogo` + "ASLA" row, and the same card `BoxDecoration`.

### Page Layout (matches LoginPage exactly)

```
Scaffold(backgroundColor: AppColors.background)
└── SafeArea
    └── LayoutBuilder
        └── SingleChildScrollView (padding: horizontal AppDimensions.paddingMd)
            └── ConstrainedBox(minHeight: constraints.maxHeight)
                └── Column
                    ├── SizedBox(height: spacingXxl)
                    ├── Directionality(textDirection: ltr)  ← Logo always LTR
                    │   └── Row(center)
                    │       ├── WaslaLogo(size: logoSizeMedium)
                    │       └── Text("ASLA", brandRed, w800, 36)
                    ├── SizedBox(height: spacingXl)
                    ├── Center
                    │   └── ConstrainedBox(maxWidth: 600)
                    │       └── Container(padding: paddingLg, decoration: card)
                    │           └── Column
                    │               ├── Text("Sign Up", heading2, center)
                    │               ├── SizedBox(height: spacingXxl)
                    │               ├── SignUpForm()
                    │               ├── SizedBox(height: spacingMd)
                    │               ├── Row(center) ← "Already have an account? Log In"
                    │               └── SizedBox(height: spacingXxl)
                    └── SizedBox(height: spacingXxl)
```

### Form Layout (SignUpForm)

```
BlocBuilder<RegisterCubit, RegisterState>
└── Column(crossAxisAlignment: stretch)
    ├── TextFormField — First Name (required)
    ├── SizedBox(spacingMd)
    ├── TextFormField — Last Name (required)
    ├── SizedBox(spacingMd)
    ├── TextFormField — Phone Number (optional)
    ├── SizedBox(spacingMd)
    ├── TextFormField — Email (required, hint: "youremail@gmail.com")
    ├── SizedBox(spacingMd)
    ├── TextFormField — Password (required, obscure, eye icon)
    ├── SizedBox(spacingMd)
    ├── TextFormField — Confirm Password (required, obscure, eye icon)
    ├── SizedBox(spacingXxl)
    └── PrimaryButton("Sign Up →") or CircularProgressIndicator
```

### InputDecoration Pattern (reused from LoginForm)

Every field uses the same `InputDecoration` pattern:
- `border`: `OutlineInputBorder(borderRadius: borderRadiusMd)`
- `enabledBorder`: `BorderSide(color: AppColors.divider)`
- `focusedBorder`: `BorderSide(color: AppColors.brandRed, width: 1.5)`
- `errorBorder`: `BorderSide(color: AppColors.error)`
- `contentPadding`: `symmetric(horizontal: paddingMd, vertical: paddingSm)`
- `style`: `AppTypography.bodyLarge`

### Button Disabled Logic

The "Sign Up →" button is enabled only when:
1. `status != RegisterStatus.loading`
2. All required fields are non-empty
3. No validation errors exist in state
4. Passwords match

This is evaluated from `RegisterState` in the `BlocBuilder`.

---

## R6. Session Persistence After Registration

**Decision**: Reuse the existing `AuthLocalDataSource.saveToken()` and `AuthLocalDataSource.saveUser()` methods. The `AuthRepositoryImpl.register()` method saves the session just like `AuthRepositoryImpl.login()`.

**Rationale**: The registration response returns the same `CustomerLoginResultDto` as login. The session data structure is identical (token + user info). Reusing the same persistence path ensures:
1. The user stays logged in after registration (same as after login)
2. The `SplashCubit.checkAuthStatus()` will find the stored session on next app launch
3. No new storage keys or data source methods needed

**Alternatives considered**:
- Separate registration session storage — rejected: identical data, identical behavior, would create confusion about which storage to check on app restart.

### Post-Registration Flow

```
register() success
  → AuthLocalDataSource.saveToken(entity.token)
  → AuthLocalDataSource.saveUser(entity)
  → RegisterCubit emits RegisterStatus.success
  → BlocListener detects success → context.go(AppRouter.home)
```

The `leadId` field will be present in the response (since registration creates a Lead). The `customerId` will be null (Lead is not yet linked to a company). Both are stored by the existing `saveUser()` method — `leadId` is already handled as a field on `LoginEntity` (though currently not persisted in `AuthLocalDataSourceImpl`).

### LeadId Persistence Gap

The existing `AuthLocalDataSourceImpl.saveUser()` does NOT persist `leadId` — it only stores `userId`, `customerId`, `firstName`, `lastName`, `email`. For registration, the `leadId` IS the primary identifier. This is a pre-existing gap that also affects login. For now, the `token` (JWT) contains the `leadId` claim, so it's accessible for API calls. Persisting `leadId` in SharedPreferences should be added but is not blocking for registration.

---

## R7. Route Wiring

**Decision**: Replace `RegisterPlaceholderPage` import in `app_router.dart` with `SignUpPage`. Provide `RegisterCubit` via `BlocProvider` in the route builder, matching how `LoginCubit` is provided for the login route.

**Rationale**: The `/register` route already exists in `AppRouter`. The only change needed is swapping the page widget and adding cubit provision. This follows the established pattern where each route provides its own cubit.

### Route Definition Update

```dart
GoRoute(
  path: register,
  builder: (context, state) => BlocProvider(
    create: (context) => RegisterCubit(
      registerUseCase: context.read<RegisterUseCase>(),
      authRepository: context.read<AuthRepository>(),
    ),
    child: const SignUpPage(),
  ),
),
```

### Dependency Injection

`RegisterUseCase` and `AuthRepository` need to be available via `context.read()`. The existing login feature likely provides `AuthRepository` at a higher level. `RegisterUseCase` needs to be provided above the router — following the same pattern as `LoginUseCase`.

---

## R8. Localization Keys

**Decision**: Add `signUp*` prefixed keys to `app_en.arb` and `app_ar.arb`. Follow the same naming convention as `login*` keys.

**Rationale**: All user-facing text must be localized (English + Arabic). The existing pattern uses feature-prefixed camelCase keys.

### New ARB Keys

| Key | English | Arabic |
|-----|---------|--------|
| `signUpTitle` | Sign Up | إنشاء حساب |
| `signUpFirstName` | First Name | الاسم الأول |
| `signUpLastName` | Last Name | اسم العائلة |
| `signUpPhoneNumber` | Phone Number | رقم الهاتف |
| `signUpEmail` | Email Address | البريد الإلكتروني |
| `signUpEmailHint` | youremail@gmail.com | youremail@gmail.com |
| `signUpPassword` | Password | كلمة المرور |
| `signUpConfirmPassword` | Confirm Password | تأكيد كلمة المرور |
| `signUpButton` | Sign Up | إنشاء حساب |
| `signUpHaveAccount` | Already have an account? Log In | لديك حساب بالفعل؟ تسجيل الدخول |
| `signUpHaveAccountAction` | Log In | تسجيل الدخول |
| `signUpFirstNameRequired` | First name is required | الاسم الأول مطلوب |
| `signUpLastNameRequired` | Last name is required | اسم العائلة مطلوب |
| `signUpNameTooLong` | Must be 100 characters or less | يجب أن يكون 100 حرف أو أقل |
| `signUpPhoneTooLong` | Must be 50 characters or less | يجب أن يكون 50 حرف أو أقل |
| `signUpEmailRequired` | Email is required | البريد الإلكتروني مطلوب |
| `signUpEmailInvalid` | Enter a valid email address | أدخل بريد إلكتروني صالح |
| `signUpPasswordRequired` | Password is required | كلمة المرور مطلوبة |
| `signUpPasswordTooShort` | Password must be at least 6 characters | كلمة المرور يجب أن تكون 6 أحرف على الأقل |
| `signUpConfirmPasswordRequired` | Please confirm your password | يرجى تأكيد كلمة المرور |
| `signUpConfirmPasswordMismatch` | Passwords do not match | كلمات المرور غير متطابقة |
| `signUpErrorEmailInUse` | This email is already registered | هذا البريد الإلكتروني مسجل بالفعل |
| `signUpErrorServer` | Something went wrong. Please try again later. | حدث خطأ ما. يرجى المحاولة مرة أخرى لاحقاً. |
| `signUpErrorNetwork` | No internet connection. Please check your network. | لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة. |
| `signUpErrorUnexpected` | An unexpected error occurred. Please try again. | حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى. |
