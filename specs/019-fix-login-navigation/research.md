# Research: Fix Login Navigation to Home Screen

**Feature**: 019-fix-login-navigation  
**Date**: 2026-02-23

## Research Task 1: Root Cause — Why Navigation Fails After Successful Login

### Investigation

Traced execution path from login button press → Home screen arrival:

1. **LoginCubit.login()** (login_cubit.dart L60-86):
   - Calls `_loginUseCase(email, password)` → gets `LoginEntity`
   - Calls `await _authRepository.saveSession(user)` → persists to SharedPreferences
   - Emits `LoginStatus.success`
   - **Verdict**: Correct. Session is saved before success is emitted.

2. **LoginPage BlocListener** (login_page.dart L31-44):
   - Listens for `LoginStatus.success`
   - Calls `context.go(AppRouter.home)` which navigates to `/home`
   - **Verdict**: Correct. Navigation fires on success state.

3. **AppRouter home route** (app_router.dart L55-63):
   - Has an async `redirect` guard that calls `authRepository.getStoredSession()`
   - If session is null → redirects to `/login`
   - **Verdict**: Guard logic is correct, but `getStoredSession()` returns null unexpectedly.

4. **AuthRepositoryImpl.getStoredSession()** (auth_repository_impl.dart L59-61):
   - Delegates to `_localDataSource.getUser()`
   - **Verdict**: Pass-through, no issue.

5. **AuthLocalDataSourceImpl.getUser()** (auth_local_data_source.dart L58-78):
   ```dart
   if (token == null ||
       userId == null ||
       customerId == null ||   // ← BUG: customerId is nullable in domain model
       firstName == null ||
       lastName == null ||
       email == null) {
     return null;
   }
   ```
   - **BUG FOUND**: `customerId` is `int?` on `LoginEntity`, but `getUser()` requires it to be non-null
   - When API returns `customerId: null`, `saveUser()` correctly calls `sharedPreferences.remove(_customerIdKey)`
   - On read-back, `sharedPreferences.getInt(_customerIdKey)` returns `null`
   - The null check fails → entire method returns `null` → home guard redirects to `/login`

### Decision

The root cause is a **field nullability mismatch** between the domain entity and the local data source read method. `LoginEntity.customerId` is `int?` but `getUser()` treats it as required.

### Rationale

- The domain model explicitly declares `customerId` as optional (`int?`)
- The API response model also declares it optional (`json['customerId'] as int?`)
- The save method handles null correctly (removes the key)
- Only the read method (`getUser()`) incorrectly requires it

### Alternatives Considered

1. **Make customerId required in the domain model**: Rejected — the API legitimately returns null for this field, and the model was intentionally designed this way
2. **Add a separate "isLoggedIn" flag to SharedPreferences**: Rejected — adds unnecessary complexity; fixing the existing null check is simpler and correct
3. **Remove the home route redirect guard entirely**: Rejected — the guard provides legitimate route protection for unauthenticated access

---

## Research Task 2: GoRouter Async Redirect Best Practices

### Investigation

The current home route uses a per-route async `redirect`:

```dart
GoRoute(
  path: home,
  builder: (context, state) => const HomePlaceholderPage(),
  redirect: (context, state) async {
    final session = await authRepository.getStoredSession();
    if (session == null) return login;
    return null;
  },
),
```

### Decision

The per-route async redirect pattern is valid for GoRouter 14.x. However, it has a subtle timing issue: the redirect runs every time the route is navigated to, including when the session was *just* saved milliseconds ago. Since `saveSession()` is awaited before emitting success (and therefore before `context.go` is called), the data should be available. The real problem is the `getUser()` null-check bug, not a timing race.

### Rationale

- `context.go(AppRouter.home)` is called synchronously after `LoginStatus.success` is emitted
- The `LoginStatus.success` is only emitted after `await _authRepository.saveSession(user)` completes
- SharedPreferences writes are synchronous on the same isolate (commit is fire-and-forget but the in-memory state is immediately updated)
- Therefore the `getStoredSession()` call in the redirect will see the saved data — as long as `getUser()` doesn't incorrectly reject it

### Alternatives Considered

1. **Move to top-level GoRouter redirect**: Rejected — adds complexity; per-route redirect is appropriate for a single protected route
2. **Use GoRouter refreshListenable with auth state**: Rejected — overengineered for this bug fix; can be considered for future auth revamp

---

## Research Task 3: `leadId` Field — Also Missing from Persistence

### Investigation

`LoginEntity` has a `leadId` field (`int?`), and `LoginResponseModel.fromJson` parses it from the API. However, `AuthLocalDataSourceImpl` does not save or restore `leadId` at all.

### Decision

Fix `getUser()` to handle nullable `customerId`. Do NOT add `leadId` persistence in this bug fix — that is a separate enhancement with a different scope.

### Rationale

- The immediate bug is the `customerId` null check
- `leadId` not being persisted means it's lost after app restart (a data gap, not a crash/navigation bug)
- Adding `leadId` persistence changes the storage schema and increases test scope beyond this bug fix

### Alternatives Considered

1. **Add leadId persistence now**: Rejected — out of scope; would expand the change surface unnecessarily for a targeted bug fix
2. **Remove leadId from LoginEntity**: Rejected — it's used elsewhere and is part of the API contract

---

## Summary of Findings

| Finding | Resolution |
|---------|------------|
| `getUser()` requires non-null `customerId` but entity allows null | Fix: make `customerId` optional in the null check |
| GoRouter redirect timing concern | Not the issue — SharedPreferences in-memory state is immediately consistent |
| `leadId` not persisted | Out of scope — separate enhancement |
| Navigation uses `context.go()` (replace semantics) | Correct — already prevents back-button return to login |
| Session save ordering (before emit) | Correct — `await saveSession()` precedes `emit(success)` |
