# Research: Customer Login

**Feature**: 010-customer-login  
**Date**: 2026-02-19  
**Last Updated**: 2026-02-19 (post-clarification)

## R1: Token Storage for "Remember Me"

**Decision**: Use `shared_preferences` behind an abstract `AuthLocalDataSource` interface.

**Rationale**:
- The app already depends on `shared_preferences ^2.3.3` — no new dependency needed.
- The app sandbox prevents other non-root apps from reading data on both Android and iOS.
- For a graduation project, the threat model (rooted devices, backup forensics) is not a concern.
- Abstracting behind an interface (`AuthLocalDataSource`) allows swapping to `flutter_secure_storage` later with zero impact on domain/presentation layers.

**Alternatives Considered**:
| Option | Verdict |
|--------|---------|
| `flutter_secure_storage` | Best security (Android Keystore / iOS Keychain). Recommended for production. Trivial API migration if storage is abstracted. Not needed for graduation project scope. |
| `hive` (encrypted box) | Overkill for single token storage; better suited for structured local databases. |
| Platform channels to Keystore/Keychain | What `flutter_secure_storage` already does — don't reinvent it. |

**Implementation Pattern**:
- Abstract `AuthLocalDataSource` with `saveToken()`, `getToken()`, `clearToken()`, `saveUser()`, `getUser()`, `clearAll()`.
- Concrete `AuthLocalDataSourceImpl` using `SharedPreferences`.
- `AuthRepositoryImpl` takes both `AuthRemoteDataSource` and `AuthLocalDataSource`.
- On successful login with "Remember Me" enabled → store token + user data.
- On app launch → check for stored token → auto-navigate past login if present.
- On logout → clear all stored auth data.
- **Never store raw passwords** — only server-issued tokens.

---

## R2: Form Validation Strategy

**Decision**: Manual validation in `LoginCubit` with per-field error keys in `LoginState`. No `formz` package. No Flutter `Form` widget.

**Rationale**:
- The login form has exactly 2 fields (email + password) with straightforward rules. `formz` adds a dependency and boilerplate that pays off at 5+ fields with complex cross-field rules.
- The existing `LoginState` uses a manual `copyWith` pattern. Adding `formz` inputs would introduce a second state paradigm — extra cognitive load for no gain.
- Keeping validation in the Cubit means: single source of truth, trivial unit testing (emit state → assert error fields), full control over when/how errors appear.
- `TextFormField` accepts `errorText` in `InputDecoration` directly — no `Form` widget or `GlobalKey<FormState>` needed.

**Alternatives Considered**:
| Option | Verdict |
|--------|---------|
| `formz` package | Recommended by bloc team for large forms. Overkill for 2-field login. |
| Flutter `Form` + `GlobalKey<FormState>` | Splits validation between widget tree and Cubit, creating two competing sources of truth. |
| Hybrid (Cubit for submit, `Form` for inline) | Fragile — `autovalidateMode.onUserInteraction` triggers before Cubit knows about the change, causing flicker. |

**Implementation Pattern**:
- Add `String? emailError` and `String? passwordError` (error keys, not user-facing strings) to `LoginState`.
- Add `bool hasSubmitted` flag to `LoginState` (default: `false`).
- On `login()`: set `hasSubmitted = true`, run validation. If invalid → emit errors and return early.
- On subsequent `emailChanged()`/`passwordChanged()`: re-validate live (since `hasSubmitted` is `true`), giving immediate feedback.
- Widget maps error keys to localized messages via `AppLocalizations`.
- `InputDecoration.errorText` renders the error beneath the field using Material's built-in error styling.

---

## R3: Existing Implementation Gap Analysis (009 → 010)

**Decision**: Extend the existing `009-customer-login` implementation rather than rewriting.

**Rationale**: The existing code provides a solid Clean Architecture foundation. Only targeted modifications are needed.

**Existing (from 009)** — Complete and correct:
| Layer | File | Status |
|-------|------|--------|
| Domain | `login_entity.dart` | Complete |
| Domain | `auth_repository.dart` (interface) | Complete |
| Domain | `login_use_case.dart` | Complete |
| Data | `login_request_model.dart` | Complete |
| Data | `login_response_model.dart` | Complete |
| Data | `auth_remote_data_source.dart` | Complete |
| Data | `auth_repository_impl.dart` | Complete |
| Presentation | `login_state.dart` | Partial — needs validation fields |
| Presentation | `login_cubit.dart` | Partial — needs validation logic |
| Presentation | `login_page.dart` | Partial — needs inline error display |
| Presentation | `login_form.dart` | Partial — needs inline validation errors |

**Gaps to fill**:
| Gap | Spec Requirement | Work Required |
|-----|------------------|---------------|
| No inline validation errors | FR-001 to FR-006 | Add `emailError`, `passwordError`, `hasSubmitted` to state; validation methods in Cubit; `errorText` in form |
| No token persistence | FR-012, FR-017 | New `AuthLocalDataSource`; modify `AuthRepositoryImpl` to accept it; persist token on "Remember Me" |
| No auto-login on app launch | US-4 | Add `checkAuthStatus()` in Cubit or use case; call from splash screen |
| No Forgot Password navigation | FR-013 | Wire `onPressed` in `LoginForm` to `AppRouter`; add `/forgot-password` route + placeholder page |
| No retry on network error | FR-011 | Add retry action to error snackbar in LoginPage |
| No 429 rate-limit handling | Edge case (clarification) | Add `rate_limited` error key in Cubit `_mapDioError()`; show "Too many attempts" message |
| No session-expired redirect | Edge case (clarification) | On 401 during active session → clear stored token via `AuthLocalDataSource.clearAll()`, redirect to login with "Session expired" message |
| No post-login dashboard route | FR-009 (clarification) | Add `/home` route + `HomePlaceholderPage`; navigate there on login success |
| Email whitespace trimming | FR-016 | Already done in Cubit (`state.email.trim()`) |
| Duplicate submission prevention | FR-015 | Already handled (button disabled during loading + `_onSubmit` guard) |
| RTL support | FR-019 | Already uses `EdgeInsetsDirectional` + `AppLocalizations` |
| No tests | Constitution X | Add unit tests for Cubit, UseCase, Repository; add widget test for LoginPage |

---

## R4: Testing Strategy

**Decision**: Add `bloc_test` and `mocktail` as dev dependencies. Test all layers per Clean Architecture.

**Rationale**:
- Constitution Principle X requires testable and maintainable code.
- `bloc_test` provides the `blocTest<>()` helper for testing Cubit state emissions — idiomatic and concise.
- `mocktail` is a code-generation-free mocking library, simpler than `mockito` for a graduation project.

**Test Plan**:
| Test File | Tests | Type |
|-----------|-------|------|
| `login_cubit_test.dart` | Validation logic, login success/failure, toggle visibility, toggle remember me | Unit (bloc_test) |
| `login_use_case_test.dart` | Delegates to repository correctly | Unit |
| `auth_repository_impl_test.dart` | Maps data source responses to entities; handles errors | Unit |
| `auth_remote_data_source_test.dart` | Sends correct request; parses response | Unit |
| `login_page_test.dart` | Renders correctly; shows validation errors; shows loading; navigates on success | Widget |

**Alternatives Considered**:
| Option | Verdict |
|--------|---------|
| `mockito` | Requires build_runner code generation. `mocktail` is simpler. |
| Integration tests | Valuable but not required for this feature scope. Widget tests cover UI behavior. |
