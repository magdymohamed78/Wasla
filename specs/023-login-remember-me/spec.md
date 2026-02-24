# Feature Specification: Login Remember Me & Refresh Token

**Feature Branch**: `023-login-remember-me`  
**Created**: 2026-02-24  
**Status**: Draft  
**Input**: User description: "Update login endpoint with rememberMe flag, implement refresh token flow, and persist session based on Remember Me checkbox. New refresh-token endpoint integration. Secure token storage. Splash screen auto-login when Remember Me is enabled."

## Clarifications

### Session 2026-02-24

- Q: What happens to existing sessions stored in plain SharedPreferences after the update? → A: Clear all old SharedPreferences data on first launch post-update — users must log in again (Option B).
- Q: What does "current session" mean when Remember Me is off — when does it end? → A: Session ends when the app process is killed (removed from recents / force-stopped). Tokens live in memory only (not persisted to disk). Backgrounding preserves the session.
- Q: How does the system distinguish a first-ever launch (show Onboarding) from a returning user who chose not to Remember Me (skip Onboarding, go to Login)? → A: Out of scope for this feature. Preserve the current splash behavior for the no-auth case — always navigate to Onboarding as the app does today.
- Q: Should this feature handle access token expiry during active app usage (mid-session 401s), not just on app reopen? → A: Yes — add an HTTP interceptor that catches 401 responses, attempts a token refresh, retries the original request transparently. If refresh fails, clear session and redirect to Login.
- Q: Should a network error during refresh be treated the same as an auth rejection (401)? → A: No — distinguish them. On network error: keep tokens, show a "No connection — Retry" prompt. On 401/auth failure: clear tokens and go to Login.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Login with Remember Me Enabled (Priority: P1)

A user opens the Login Page, enters their email and password, checks the "Remember Me" checkbox, and taps "Log In". The system sends the `rememberMe: true` flag to the login API. On success, the system receives an access token, a refresh token (valid for 30 days), and user info. The system stores both tokens securely and persists a flag indicating Remember Me is enabled. The user is navigated to the Home page.

**Why this priority**: This is the core new behavior — without sending `rememberMe` to the API and storing the refresh token, no other user story (auto-login, token refresh) can function.

**Independent Test**: Can be fully tested by logging in with Remember Me checked, verifying the API request includes `rememberMe: true`, and confirming that the access token, refresh token, and Remember Me flag are stored securely on the device.

**Acceptance Scenarios**:

1. **Given** the user is on the Login Page with Remember Me checked, **When** they submit valid credentials, **Then** the login request body includes `{ "email": "...", "password": "...", "rememberMe": true }`.
2. **Given** the login API returns a successful response with `token`, `refreshToken`, `refreshTokenExpiry`, and user info, **When** the system processes the response, **Then** the access token, refresh token, refresh token expiry, and a Remember Me flag (`true`) are all stored securely on the device.
3. **Given** login is successful with Remember Me checked, **When** the user is navigated to the Home page, **Then** the session is fully established and persistent across app restarts.

---

### User Story 2 - Login with Remember Me Disabled (Priority: P1)

A user logs in without checking Remember Me (or with it unchecked). The system sends `rememberMe: false` (or omits it) to the login API. On success, the system stores tokens only for the current session — they are not persisted long-term. When the user closes and reopens the app, they must log in again.

**Why this priority**: This is the counterpart to US1 — the system must differentiate behavior based on the checkbox to avoid always remembering the user.

**Independent Test**: Can be tested by logging in with Remember Me unchecked, closing the app, reopening it, and verifying the user is redirected to the Login Page (not auto-logged in).

**Acceptance Scenarios**:

1. **Given** the user is on the Login Page with Remember Me unchecked, **When** they submit valid credentials, **Then** the login request body includes `rememberMe: false` (or the field is omitted).
2. **Given** login is successful with Remember Me unchecked, **When** the system stores tokens, **Then** the access token is held in memory only (not written to disk). The refresh token and Remember Me flag are NOT persisted. Backgrounding the app preserves the in-memory session.
3. **Given** the user logged in without Remember Me and the app process is killed (removed from recents / force-stopped), **When** they reopen the app, **Then** the Splash Screen plays, no refresh attempt is made, and the user is navigated to the Onboarding Page (current default flow).

---

### User Story 3 - Auto-Login via Refresh Token on App Reopen (Priority: P1)

A user who previously logged in with Remember Me enabled closes the app and reopens it later. The Splash Screen shows the loading dots animation. While the animation plays, the system checks if a Remember Me flag and a valid refresh token exist. If yes, it calls `POST /api/customer-portal/refresh-token` with the stored refresh token. On success, the system receives a new access token and a rotated refresh token, stores them securely, and navigates the user directly to the Home page — bypassing login entirely.

**Why this priority**: This is the primary user-facing value of Remember Me — seamless re-entry without re-entering credentials. Without this, the Remember Me checkbox is meaningless.

**Independent Test**: Can be tested by logging in with Remember Me, force-closing the app, reopening it, and verifying the user lands on the Home page without seeing the Login Page.

**Acceptance Scenarios**:

1. **Given** a user previously logged in with Remember Me enabled and the app is reopened, **When** the Splash Screen loads, **Then** the system checks for a stored Remember Me flag and refresh token.
2. **Given** the Remember Me flag is `true` and a refresh token exists, **When** the system calls `POST /api/customer-portal/refresh-token` with `{ "refreshToken": "..." }`, **Then** it receives a new access token, rotated refresh token, and refreshTokenExpiry.
3. **Given** the refresh token call succeeds, **When** the system processes the response, **Then** the new access token and rotated refresh token are stored securely, and the user is navigated directly to the Home page.
4. **Given** the Splash Screen is showing, **When** the auth check / refresh is in progress, **Then** the loading dots animation continues until the result is resolved — navigation only happens after the auth check completes.

---

### User Story 4 - Refresh Token Failure on App Reopen (Priority: P1)

A user who previously logged in with Remember Me enabled reopens the app, but the refresh token has expired, been revoked, or the refresh call fails. The system clears all stored tokens and the Remember Me flag, then navigates the user to the Login Page so they can authenticate again.

**Why this priority**: Without handling failure gracefully, the user could be stuck in a broken state — unable to reach Home yet not redirected to Login.

**Independent Test**: Can be tested by logging in with Remember Me, waiting for the refresh token to expire (or simulating a 401 response), reopening the app, and verifying the user is redirected to Login with all stored tokens cleared.

**Acceptance Scenarios**:

1. **Given** the Remember Me flag is `true` and a refresh token exists but is expired, **When** the system calls `/refresh-token`, **Then** the API returns 401 (invalid/expired/revoked token).
2. **Given** the refresh token call returns 401, **When** the system handles the error, **Then** all stored tokens (access token, refresh token, refresh token expiry) and the Remember Me flag are cleared from secure storage.
3. **Given** tokens have been cleared after a failed refresh, **When** navigation occurs, **Then** the user is navigated to the Login Page.
4. **Given** a network error occurs during the refresh call (no connectivity), **When** the system handles the error, **Then** stored tokens are NOT cleared. The system shows a "No connection — Retry" prompt on the Splash Screen so the user can retry when connectivity is restored.

---

### User Story 4b - Transparent Mid-Session Token Refresh (Priority: P1)

A user is actively using the app and their short-lived access token expires. The next API call returns a 401 response. An HTTP interceptor detects the 401, pauses outgoing requests, uses the stored refresh token to obtain a new access token, updates secure storage, and retries the original request transparently. The user experiences no interruption. If the refresh itself fails (expired/revoked refresh token or network error), the system clears all stored tokens and redirects the user to the Login Page.

**Why this priority**: Without mid-session refresh, users with Remember Me enabled will encounter unexplained errors whenever the short-lived access token expires, even though they hold a valid refresh token.

**Independent Test**: Can be tested by logging in, waiting for the access token to expire (or simulating a 401 on any API call), and verifying the interceptor refreshes the token and retries the request without user-visible errors.

**Acceptance Scenarios**:

1. **Given** the user is logged in and the access token has expired, **When** an API call returns 401, **Then** the interceptor automatically calls `/refresh-token` with the stored refresh token.
2. **Given** the interceptor successfully refreshes the token, **When** the new tokens are stored, **Then** the original failed request is retried with the new access token and the response is returned to the caller as if no error occurred.
3. **Given** multiple API calls fail with 401 simultaneously, **When** the interceptor handles them, **Then** only one refresh call is made. All queued requests wait for the single refresh to complete and are then retried with the new token.
4. **Given** the interceptor’s refresh call fails with a 401/auth error, **When** the system handles the failure, **Then** all stored tokens and the Remember Me flag are cleared and the user is redirected to the Login Page.
5. **Given** the interceptor’s refresh call fails due to a network error (no connectivity), **When** the system handles the failure, **Then** stored tokens are NOT cleared. The failed request surfaces a network error to the caller (e.g., "No connection").

---

### User Story 5 - Updated Login Response Model (Priority: P1)

The existing login response model must be updated to include the new fields returned by the API: `refreshToken` (string) and `refreshTokenExpiry` (datetime). These fields must be parsed from the API response, mapped through the data model to the domain entity, and stored securely.

**Why this priority**: All other stories depend on the refresh token data flowing through the system correctly. This is a blocking prerequisite.

**Independent Test**: Can be tested by calling the login API and verifying that the response model correctly parses `refreshToken` and `refreshTokenExpiry` fields, and that they propagate to the domain entity.

**Acceptance Scenarios**:

1. **Given** the login API returns a response with `token`, `refreshToken`, `refreshTokenExpiry`, and user info, **When** the response model parses it, **Then** all fields including `refreshToken` and `refreshTokenExpiry` are correctly populated.
2. **Given** the response model is converted to a domain entity, **When** the conversion runs, **Then** `refreshToken` and `refreshTokenExpiry` are present on the entity.

---

### Edge Cases

- What happens if the system attempts a refresh token call and a second refresh is triggered simultaneously? Only one refresh call should be in-flight at a time — avoid duplicate/parallel refresh requests.
- What happens if the refresh token response itself returns a replay detection error? The system should treat it like an expired token — clear all stored tokens and redirect to Login.
- What happens if the stored Remember Me flag is `true` but no refresh token is found in storage? The system should clear the flag and navigate to Login.
- What happens if the splash animation finishes before the refresh token call completes? Navigation should wait until the auth result is resolved, even if the animation has ended.
- What happens if an access token expires mid-session during active app usage? The HTTP interceptor catches the 401, refreshes the token transparently, and retries the request. The user sees no interruption.
- What happens if multiple API calls fail with 401 at the same time during a mid-session refresh? Only one refresh call is made; all other 401 requests are queued and retried after the refresh completes.
- What happens if the user has Remember Me enabled but opens the app with no network connectivity? Stored tokens are preserved, and a "No connection — Retry" prompt is shown on the Splash Screen. Tokens are NOT cleared for network errors.
- What happens if the user logs out? All tokens (access, refresh), the Remember Me flag, and all user data should be cleared from storage.
- What happens to users who were logged in before this update (legacy SharedPreferences data)? All legacy session data is cleared on first post-update launch — the user must log in again.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The login request body MUST include a `rememberMe` boolean field, set to the value of the Remember Me checkbox.
- **FR-002**: The login response model MUST parse `refreshToken` (string, nullable) and `refreshTokenExpiry` (datetime) from the API response.
- **FR-003**: The domain login entity MUST include `refreshToken` and `refreshTokenExpiry` fields.
- **FR-004**: When Remember Me is checked (`true`), the system MUST securely store the access token, refresh token, refresh token expiry, and a Remember Me flag on the device.
- **FR-005**: When Remember Me is unchecked (`false`), the system MUST hold the access token in memory only (not written to disk). The refresh token and Remember Me flag MUST NOT be persisted. Backgrounding the app preserves the in-memory session; killing the app process ends the session.
- **FR-006**: Token storage MUST use a secure storage mechanism (not plain SharedPreferences) to protect access and refresh tokens.
- **FR-007**: On app launch, the Splash Screen MUST check for a stored Remember Me flag and refresh token before deciding where to navigate.
- **FR-008**: If Remember Me is `true` and a refresh token exists, the system MUST call `POST /api/customer-portal/refresh-token` with the stored refresh token.
- **FR-009**: The refresh token request body MUST be `{ "refreshToken": "<stored_token>" }`.
- **FR-010**: On successful refresh, the system MUST store the new access token, the rotated refresh token, and the new refresh token expiry securely.
- **FR-011**: On successful refresh, the user MUST be navigated directly to the Home page without seeing the Login Page.
- **FR-012**: On refresh failure due to an authentication error (401 — expired, revoked, or invalid token), the system MUST clear all stored tokens and the Remember Me flag, then navigate to the Login Page. On refresh failure due to a network error (no connectivity), the system MUST NOT clear stored tokens — instead it MUST show a "No connection — Retry" prompt so the user can retry when connectivity is restored.
- **FR-013**: If Remember Me is `false` (or no flag exists) on app launch, the system MUST NOT attempt a refresh token call and MUST navigate to the Onboarding Page (preserving the current splash flow). Differentiating first-launch from returning-user navigation is out of scope for this feature.
- **FR-014**: The Splash Screen loading dots MUST continue animating until the auth check / refresh call is fully resolved — navigation MUST only happen after the result is known.
- **FR-015**: The system MUST NOT enter an infinite refresh loop. If a refresh fails, no retry should be attempted — go directly to Login.
- **FR-016**: On logout, ALL stored tokens (access, refresh), the Remember Me flag, the refresh token expiry, and all user data MUST be cleared from secure storage.
- **FR-017**: On first launch after the update, the system MUST clear all legacy SharedPreferences session data (access token, user info) and require the user to log in again. No migration of old plain-text tokens into secure storage.
- **FR-018**: The HTTP client MUST include an interceptor that detects 401 responses on any API call. When a 401 is received, the interceptor MUST attempt to refresh the access token using the stored refresh token before failing the request.
- **FR-019**: During a mid-session token refresh, concurrent 401-triggering requests MUST be queued and retried after the single refresh completes. If the refresh fails, all queued requests MUST fail and the user MUST be redirected to the Login Page with all tokens cleared.

### Key Entities

- **LoginRequest**: Email, password, and rememberMe flag sent to the login API.
- **LoginResponse / LoginEntity**: Access token, refresh token, refresh token expiry, userId, customerId (nullable), leadId (nullable), firstName, lastName, email.
- **RefreshTokenRequest**: Refresh token string sent to the refresh-token API.
- **Persisted Auth State**: Access token, refresh token, refresh token expiry, Remember Me flag, and user info stored on-device in secure storage.

## Assumptions

- The existing Login Page already has a working "Remember Me" checkbox in the UI that toggles state in the `LoginCubit`. This feature makes that checkbox functional by wiring it to the API and session persistence logic.
- The existing `LoginResponseModel` and `LoginEntity` currently only have a `token` field — they will be extended with `refreshToken` and `refreshTokenExpiry`.
- The existing `LoginRequestModel` currently only has `email` and `password` — it will be extended with `rememberMe`.
- The existing session storage uses `SharedPreferences` (plain text). This feature requires migrating token storage to a secure storage mechanism for token fields (access token, refresh token).
- The Splash Screen currently always navigates to `/onboarding` after its animation. This feature modifies the splash logic to check auth state first.
- The app's first-launch flow (Splash → Onboarding) should be preserved for new users who have never logged in.
- On the first launch after this update, all legacy SharedPreferences session data will be cleared. Users who were previously logged in will need to log in again. No migration of old plain-text sessions into secure storage.
- The `/api/customer-portal/refresh-token` endpoint uses token rotation — each refresh token is single-use. After a successful refresh, the old token is invalidated and a new one is returned.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of login requests include the `rememberMe` field matching the checkbox state.
- **SC-002**: Users who log in with Remember Me enabled can close and reopen the app and land on the Home page without re-entering credentials.
- **SC-003**: Users who log in without Remember Me must re-authenticate on every app reopen.
- **SC-004**: When a refresh token is expired or revoked, the user is redirected to Login within 3 seconds of the Splash Screen appearing.
- **SC-005**: Zero access or refresh tokens are stored in plain text — all token storage uses secure storage.
- **SC-006**: The Splash Screen loading animation remains visible until auth status is fully resolved — no blank screens or premature navigation.
- **SC-007**: Logout clears all stored tokens and flags — subsequent app opens navigate to Login, never to Home.
