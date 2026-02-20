# Research: Login Error Response Handling

**Feature**: `011-login-error-handling` | **Date**: 2026-02-20

---

## Research Task 1: Mapping HTTP Status Codes to User-Facing Error Messages

### Current State

The existing `_extractErrorMessage()` in `login_cubit.dart` already handles status-code branching but has gaps versus the spec:

| Status | Current behavior | Required behavior |
|--------|-----------------|-------------------|
| 400 | Returns `serverMessage ?? 'Invalid email or password'` (lumped with 401) | Replace with friendly `"Your account is not fully set up. Please contact support for help."` |
| 401 | Same branch as 400, returns server message | Pass through server message `"Invalid credentials or inactive account."` |
| 429 | Returns hardcoded string, no cooldown | Display message **+ start 15 s cooldown** |
| 500/502/503 | Returns `"Server error. Please try again later."` | Use `"An unexpected error occurred. Please try again later."` (matches contract) |
| Network | Varies by `DioExceptionType` | Unify to `"No internet connection. Please check your network and try again."` |

### Decision: Use status code as the primary discriminator, not response body `message`

**Rationale:**
- The backend contracts in `error-responses.md` define one `message` per status code per endpoint, so each status code maps 1:1 to a condition. Status codes are the stable, machine-readable contract.
- For 400, the spec explicitly requires replacing the server message with friendlier text — proving the body text cannot be the sole source of truth.
- For 401, the server message happens to be user-appropriate, so it can be used as-is.

**Pattern — status-code switch with optional server-message fallback:**

```
switch (statusCode) {
  400 → hardcoded friendly string (ignore server message)
  401 → server message ?? fallback constant
  429 → hardcoded string + trigger cooldown side-effect
  500 → hardcoded string
  default → generic fallback
}
```

**Alternatives considered:**

| Alternative | Why rejected |
|-------------|-------------|
| Match on response body `message` string | Brittle — server text could change; 400 message is replaced anyway |
| Generic Dio interceptor that maps all errors globally | Over-scoped — only the login endpoint needs this specific mapping |
| Enum-based error codes from server | Not available — backend only returns `{ "message": "..." }` |

---

## Research Task 2: Cubit 429 Rate-Limit Cooldown Timer

### Decision: Use `dart:async` `Timer.periodic` with 1-second ticks, stored as a field on `LoginCubit`

**Approach:**

1. **State fields** — add to `LoginState`:
   - `bool isRateLimited` (default `false`) — gates the Sign In button
   - `int rateLimitRemainingSeconds` (default `0`) — drives countdown display

2. **Timer lifecycle in Cubit:**
   - On 429 response: emit state with `isRateLimited: true, rateLimitRemainingSeconds: 15`, then start `Timer.periodic(Duration(seconds: 1), _onCooldownTick)`.
   - `_onCooldownTick`: decrement `rateLimitRemainingSeconds`, emit. When it hits 0, cancel timer, emit `isRateLimited: false`.
   - Cancel any existing timer before starting a new one (handles rapid re-429).

3. **Cleanup:** Override `close()` to cancel the timer.

**Rationale:**
- `Timer.periodic` gives a real-time countdown that can be displayed in the UI (e.g., "Try again in 12s"). `Future.delayed` only fires once after the full duration.
- Storing the `Timer` as a Cubit instance field is the standard flutter_bloc pattern; the Cubit owns the lifecycle.

**Alternatives considered:**

| Alternative | Why rejected |
|-------------|-------------|
| `Future.delayed(15s)` then emit | No countdown visibility; harder to cancel on Cubit close |
| `Stream.periodic` + `StreamSubscription` | More boilerplate for the same result |
| Separate `RateLimitCubit` | Over-engineering for a single timer; violates single-cubit-per-feature pattern |
| Read `Retry-After` header from 429 response | Backend doesn't send this header per the contracts; 15 s is the spec requirement |

---

## Research Task 3: SnackBar Behavior and Duration Configuration

### Current State

The existing `_showErrorSnackBar` in `login_page.dart` uses:
- `duration: const Duration(seconds: 5)` — needs to change to **4 seconds**
- Always shows a `Retry` button — needs to be **conditional** (only for 500/network)
- Uses `clearSnackBars()` before showing — correct for FR-013 (replace previous error)

### Decision: 4-second duration, conditional retry action based on error category

**Duration:** Change `Duration(seconds: 5)` → `Duration(seconds: 4)` (FR-009).

**Conditional retry:**
- Add an error category enum to `LoginState`: `LoginErrorCategory { credentials, accountLink, rateLimit, server, network }`
- In `_showErrorSnackBar`, only show the `Retry` `TextButton` when category is `server` or `network`.

**BlocListener pattern (already in place):**
- The existing `BlocListener` with `listenWhen` is correct. Side-effects (snackbar) happen in `listener`, not in `builder`.

**Alternatives considered:**

| Alternative | Why rejected |
|-------------|-------------|
| Show retry for all errors | Retrying wrong credentials is futile; retrying during rate-limit violates cooldown |
| Use a banner instead of snackbar | Spec explicitly calls for snackbar/toast (FR-009) |
| Custom overlay instead of `SnackBar` | Unnecessary complexity; `SnackBar` meets all requirements |

---

## Research Task 4: Testing DioException-Based Error Handling

### 4a. Mocking DioException with mocktail

**Decision:** Construct real `DioException` instances with mock `Response` objects — do not mock `DioException` itself.

**Rationale:** `DioException` is a concrete class with simple constructors. Mock the `LoginUseCase` to throw constructed `DioException` instances.

### 4b. Testing Timer-Based 429 Cooldown

**Decision:** Use `fakeAsync` from `flutter_test` to control time, combined with manual `cubit.login()` calls.

**Rationale:** `blocTest` doesn't support multiple intermediate assertions or `fakeAsync` time control. `fakeAsync` allows deterministic advancement of timer ticks.

- Use `fakeAsync` for countdown verification (intermediate assertions at each second tick)
- Use `blocTest` for simple error mapping tests (no timer involved)

### 4c. Testing SnackBar Display in Widget Tests

**Decision:** Use `pumpWidget` + `BlocProvider` with a `MockCubit`, then verify `find.byType(SnackBar)` and `find.text(...)`.

- For testing "retry button not shown for credential errors": assert `find.text('Retry')` is `findsNothing`.
- For testing "retry button shown for server errors": assert `find.text('Retry')` is `findsOneWidget`.
- For testing rate-limit button disable: verify `PrimaryButton.onPressed` is `null` when `isRateLimited` is `true`.

**Alternatives considered:**

| Alternative | Why rejected |
|-------------|-------------|
| Golden tests for snackbar | Brittle across platforms |
| Integration test with real Cubit + mock Dio | Slower; crosses unit/integration boundary |
| Test snackbar in Cubit test | Snackbar is a UI concern; Cubit tests verify state emissions only |

---

## Summary of Decisions

| # | Topic | Decision |
|---|-------|----------|
| 1a | Error discriminator | Status code primary; ignore/replace body text for 400; use body for 401 |
| 1b | 400 handling | Hardcode friendly message, ignore server `message` |
| 1c | Catch-all | Generic fallback for unknown status codes and malformed bodies |
| 2a | Cooldown mechanism | `Timer.periodic` with 1 s ticks on `LoginCubit` |
| 2b | State fields | `isRateLimited: bool` + `rateLimitRemainingSeconds: int` on `LoginState` |
| 2c | Cleanup | Cancel timer in `Cubit.close()` |
| 3a | Snackbar duration | 4 seconds (`Duration(seconds: 4)`) |
| 3b | Retry action | Conditional — only for `server` and `network` error categories |
| 3c | Error display | Single `BlocListener` with category-based conditional logic |
| 4a | DioException mocking | Construct real instances; mock `LoginUseCase` as the throw source |
| 4b | Timer testing | `fakeAsync` for countdown verification; `blocTest` for simple error mapping |
| 4c | Snackbar testing | Widget test with `MockCubit`, assert `find.byType(SnackBar)` and button presence |
