# Feature Specification: Login Error Response Handling

**Feature Branch**: `011-login-error-handling`  
**Created**: 2026-02-20  
**Status**: Draft  
**Input**: User description: "Handle error responses for login page from error contracts"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Display Invalid Credentials Error (Priority: P1)

As a customer who enters incorrect login credentials, I want to see a clear error message so that I know my email or password was wrong and can try again.

**Why this priority**: This is the most common login failure scenario. Customers mistype passwords frequently, and clear feedback is essential for them to self-correct and successfully sign in.

**Independent Test**: Can be fully tested by entering invalid credentials on the login screen, submitting, and verifying the error message "Invalid credentials or inactive account." is displayed in a user-friendly manner.

**Acceptance Scenarios**:

1. **Given** the customer is on the login screen, **When** the customer enters an incorrect email or password and taps "Sign In", **Then** the system displays the error message "Invalid credentials or inactive account." and remains on the login screen.
2. **Given** the customer sees an invalid credentials error, **When** the customer edits the email or password field, **Then** the error message is dismissed so the customer can retry without confusion.
3. **Given** the customer sees an invalid credentials error, **When** the customer corrects their credentials and taps "Sign In" again, **Then** the system processes the new attempt normally.

---

### User Story 2 - Display Unlinked Account Error (Priority: P1)

As a customer whose account is not linked to a lead or customer record, I want to see a specific error message so that I understand why I cannot log in and can seek help.

**Why this priority**: This error indicates a data/configuration issue that prevents login entirely. Without a clear message, the customer would be stuck with no path forward. Prompt guidance toward support is critical.

**Independent Test**: Can be fully tested by attempting to log in with an account that exists but is not linked to any lead or customer record, and verifying the appropriate error message and guidance to contact support are displayed.

**Acceptance Scenarios**:

1. **Given** the customer is on the login screen, **When** the customer enters valid credentials for an account not linked to a lead or customer record and taps "Sign In", **Then** the system displays a user-friendly message such as "Your account is not fully set up. Please contact support for help." and remains on the login screen.
2. **Given** the customer sees the unlinked account error, **When** the customer reads the message, **Then** the message clearly guides the customer to contact support for resolution.

---

### User Story 3 - Handle Rate Limiting (Priority: P1)

As a customer who has made too many login attempts, I want to see a clear rate-limit message so that I know to wait before trying again.

**Why this priority**: Rate limiting protects account security. Without proper feedback, customers may think the app is broken and abandon it, or keep retrying which worsens the experience. This is a security-critical user flow.

**Independent Test**: Can be fully tested by triggering multiple rapid login attempts until a 429 response is received, and verifying the rate-limit message is displayed and the form is temporarily disabled.

**Acceptance Scenarios**:

1. **Given** the customer has made too many login attempts, **When** the server returns a 429 response, **Then** the system displays the error message "Too many login attempts. Please try again later." and disables the "Sign In" button temporarily.
2. **Given** the customer sees the rate-limit error, **When** the customer waits and the cooldown period passes, **Then** the "Sign In" button becomes enabled again and the error message is dismissed.
3. **Given** the customer sees the rate-limit error, **When** the customer navigates away from the login screen and returns, **Then** the rate-limit state is respected (button remains disabled if cooldown has not passed).

---

### User Story 4 - Handle Unexpected Server Errors (Priority: P2)

As a customer who encounters a server error during login, I want to see a friendly error message with a retry option so that I know the problem is temporary and can try again.

**Why this priority**: Server errors (500) are less common but critically impact trust. A friendly message with retry capability prevents customer frustration and abandonment.

**Independent Test**: Can be fully tested by simulating a 500 server response and verifying the generic error message and retry option are displayed.

**Acceptance Scenarios**:

1. **Given** the customer is on the login screen, **When** the customer taps "Sign In" and the server returns a 500 error, **Then** the system displays the error message "An unexpected error occurred. Please try again later." with a visible option to retry.
2. **Given** the customer sees the unexpected error message, **When** the customer taps the retry option, **Then** the system re-submits the login request.

---

### User Story 5 - Handle Network Connectivity Errors (Priority: P2)

As a customer with no internet connection or an unreachable server, I want to see a network-specific error message so that I understand the issue is with connectivity, not my credentials.

**Why this priority**: Network errors are distinct from server errors and require different user guidance. Customers should know to check their connection rather than re-entering credentials.

**Independent Test**: Can be fully tested by disabling network connectivity, attempting to log in, and verifying a network-specific error message is displayed.

**Acceptance Scenarios**:

1. **Given** the customer has no internet connection, **When** the customer taps "Sign In", **Then** the system displays the error message "No internet connection. Please check your network and try again."
2. **Given** the customer sees a network error, **When** the customer restores connectivity and taps retry, **Then** the system re-submits the login request normally.

---

### Edge Cases

- What happens when the server returns an error with an empty or malformed message body? The system should fall back to a generic error message "An unexpected error occurred. Please try again later."
- What happens when the server returns an unexpected HTTP status code not covered by the error contracts (e.g., 403, 502, 503)? The system should treat it as an unexpected error and display the generic error message.
- What happens when the error message from the server is in a different language than the app's current locale? The system should use the server-provided message as-is; localization of server error messages is out of scope for this feature.
- What happens when an error response is received but the customer has already navigated away from the login screen? The system should discard the error and not display it on a different screen.
- What happens when multiple errors occur in rapid succession (e.g., network error followed by rate limit)? The system should display only the most recent error message, replacing the previous one.
- What happens when the customer taps "Sign In" while a previous request is still in flight? The system should prevent duplicate submissions (handled in the existing login feature FR-015).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST map HTTP 401 responses from the login endpoint to display the error message "Invalid credentials or inactive account." on the login screen.
- **FR-002**: System MUST map HTTP 400 responses from the login endpoint to display a user-friendly message such as "Your account is not fully set up. Please contact support for help." instead of the raw server message, providing clear guidance to the customer.
- **FR-003**: System MUST map HTTP 429 responses from the login endpoint to display the error message "Too many login attempts. Please try again later." and temporarily disable the "Sign In" button.
- **FR-004**: System MUST map HTTP 500 responses from the login endpoint to display the error message "An unexpected error occurred. Please try again later." with a retry option.
- **FR-005**: System MUST handle network connectivity failures (no internet, timeout, DNS failure) by displaying the message "No internet connection. Please check your network and try again."
- **FR-006**: System MUST handle unexpected or undocumented HTTP status codes by displaying the generic error message "An unexpected error occurred. Please try again later."
- **FR-007**: System MUST handle malformed or empty error response bodies by falling back to the generic error message.
- **FR-008**: System MUST dismiss the displayed error message when the customer begins editing the email or password field.
- **FR-009**: System MUST display error messages using a snackbar/toast at the bottom of the login screen that auto-dismisses after 4 seconds.
- **FR-010**: System MUST provide a retry mechanism (button or tap action) when displaying server errors (500) and network errors.
- **FR-011**: System MUST re-enable the "Sign In" button after a 15-second cooldown period when a 429 rate-limit error is received.
- **FR-012**: System MUST NOT display login error messages if the customer has navigated away from the login screen before the response arrives.
- **FR-013**: System MUST replace any previously displayed error message with the most recent error when a new login attempt fails.
- **FR-014**: System MUST display all error messages using the app's current locale direction (LTR or RTL).

### Key Entities

- **Login Error**: Represents an error state from the login endpoint. Key attributes: HTTP status code, error message text, error category (credentials, account-link, rate-limit, server, network).
- **Error Display State**: Represents the current error visibility state on the login screen. Key attributes: whether an error is shown, the error message, whether retry is available, whether the sign-in button is disabled.

## Clarifications

### Session 2026-02-20

- Q: What is the cooldown duration for re-enabling the Sign In button after a 429 rate-limit response? → A: 15 seconds
- Q: What error display mechanism should be used for login errors? → A: Snackbar/toast at the bottom of the screen (auto-dismisses)
- Q: Should the app provide actionable guidance for the unlinked account error (400)? → A: Replace server message with a friendlier version that includes support guidance in the text
- Q: What is the exact network error message text? → A: "No internet connection. Please check your network and try again."
- Q: How long should the snackbar/toast remain visible before auto-dismissing? → A: 4 seconds (Material Design default)

## Assumptions

- The login endpoint follows the error response contracts defined in the project's error-responses.md document, always returning `{ "message": "..." }` for error responses.
- The base login feature (feature 010-customer-login / spec 04-customer-login) is already implemented or will be implemented before this feature, including the login form, basic submission flow, and loading state.
- The server returns error messages in English; localization of server-provided error messages is not in scope.
- The cooldown period for rate-limiting (429) is 15 seconds since the server does not specify a `Retry-After` header in the current contract.
- Error messages from the server are displayed as-is without modification, except for the HTTP 400 unlinked-account error which is replaced with a friendlier user-facing message that includes support guidance.
- No special handling is needed for HTTP 201/200 success responses — those are handled by the existing login feature.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of defined error responses (400, 401, 429, 500) from the login endpoint are mapped to user-visible error messages on the login screen.
- **SC-002**: Error messages are displayed within 1 second of receiving the server response.
- **SC-003**: Customers who encounter a temporary error (500 or network) can successfully retry without leaving the login screen.
- **SC-004**: The rate-limit error (429) disables repeated submissions and automatically re-enables the sign-in button after the cooldown period.
- **SC-005**: Network connectivity errors are distinguishable from server errors by the displayed message, helping customers self-diagnose the issue.
- **SC-006**: No error messages are shown on screens other than the login screen, even if the customer navigates away before the response arrives.
- **SC-007**: Error messages display correctly in both LTR and RTL layouts without visual defects.
