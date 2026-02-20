# Feature Specification: Customer Login

**Feature Branch**: `010-customer-login`  
**Created**: 2026-02-19  
**Status**: Draft  
**Input**: User description: "Customer Login feature"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Sign In with Email and Password (Priority: P1)

As a registered customer, I want to sign in using my email address and password so that I can access my personal account and use the app's features.

**Why this priority**: Authentication is the gateway to all personalized features. Without login, customers cannot access any account-specific functionality. This is the foundational user flow.

**Independent Test**: Can be fully tested by entering valid credentials on the login screen and verifying that the customer is authenticated and navigated to the home screen.

**Acceptance Scenarios**:

1. **Given** the customer is on the login screen with empty fields, **When** the customer enters a valid registered email and correct password and taps "Sign In", **Then** the system authenticates the customer and navigates to the home screen.
2. **Given** the customer is on the login screen, **When** the customer enters a valid email but an incorrect password and taps "Sign In", **Then** the system displays an error message "Invalid email or password" and remains on the login screen.
3. **Given** the customer is on the login screen, **When** the customer enters an unregistered email and taps "Sign In", **Then** the system displays an error message "Invalid email or password" without revealing whether the email exists.
4. **Given** the customer has successfully signed in, **When** the customer reopens the app within the session validity period, **Then** the customer is automatically signed in without re-entering credentials.

---

### User Story 2 - Input Validation Feedback (Priority: P1)

As a customer, I want to see clear validation messages when I submit incomplete or incorrectly formatted login information so that I know exactly what to correct.

**Why this priority**: Real-time validation prevents unnecessary server requests and provides immediate guidance, directly impacting usability and reducing frustration.

**Independent Test**: Can be fully tested by attempting to submit the login form with various invalid inputs and verifying appropriate inline error messages appear.

**Acceptance Scenarios**:

1. **Given** the customer is on the login screen, **When** the customer taps "Sign In" without entering any information, **Then** the system displays validation errors for both the email and password fields.
2. **Given** the customer is on the login screen, **When** the customer enters an improperly formatted email (e.g., missing "@" or domain), **Then** the system displays an inline error "Please enter a valid email address".
3. **Given** the customer is on the login screen, **When** the customer enters an email but leaves the password field empty, **Then** the system displays a validation error on the password field "Password is required".

---

### User Story 3 - Password Visibility Toggle (Priority: P2)

As a customer, I want to toggle the visibility of my password while typing so that I can verify what I've entered without worrying about typos.

**Why this priority**: Password visibility toggle is a standard usability enhancement that reduces login failures caused by mistyped passwords, but it is not required for core sign-in functionality.

**Independent Test**: Can be fully tested by entering text in the password field and toggling visibility on/off, verifying the text is shown/hidden accordingly.

**Acceptance Scenarios**:

1. **Given** the customer is typing in the password field, **When** the customer taps the visibility toggle icon, **Then** the password text changes from obscured to plain text (and vice versa on subsequent taps).
2. **Given** the password is currently visible, **When** the customer taps the visibility toggle again, **Then** the password is obscured.

---

### User Story 4 - Remember Me (Priority: P2)

As a customer, I want the option to stay signed in across app sessions so that I don't have to re-enter my credentials every time I open the app.

**Why this priority**: Convenience feature that improves daily user experience but is not critical for the core authentication flow.

**Independent Test**: Can be fully tested by signing in with "Remember Me" enabled, closing the app, reopening it, and verifying the customer is still signed in.

**Acceptance Scenarios**:

1. **Given** the customer is on the login screen, **When** the customer checks "Remember Me" and signs in successfully, **Then** the customer remains signed in on subsequent app launches until they explicitly sign out.
2. **Given** the customer signed in without "Remember Me", **When** the app session expires or the app is closed and reopened, **Then** the customer is redirected to the login screen.

---

### User Story 5 - Navigate to Forgot Password (Priority: P3)

As a customer who has forgotten their password, I want to navigate to a password recovery flow from the login screen so that I can regain access to my account.

**Why this priority**: Important for account recovery but depends on a separate "Forgot Password" feature being implemented. The login screen only needs to provide a navigation entry point.

**Independent Test**: Can be tested by tapping the "Forgot Password?" link and verifying navigation to the password recovery screen (or a placeholder screen).

**Acceptance Scenarios**:

1. **Given** the customer is on the login screen, **When** the customer taps "Forgot Password?", **Then** the system navigates to the password recovery screen.

---

### User Story 6 - Navigate to Sign Up (Priority: P3)

As a new user who does not have an account, I want to navigate to the registration screen from the login screen so that I can create an account.

**Why this priority**: Provides discoverability for new users but depends on a separate registration feature. The login screen only needs to provide the navigation link.

**Independent Test**: Can be tested by tapping the "Sign Up" link and verifying navigation to the registration screen (or a placeholder screen).

**Acceptance Scenarios**:

1. **Given** the customer is on the login screen, **When** the customer taps "Don't have an account? Sign Up", **Then** the system navigates to the registration screen.

---

### Edge Cases

- What happens when the customer attempts to sign in with no internet connection? The system should display an appropriate offline error message.
- What happens when the server is unreachable or returns an unexpected error? The system should display a generic error message and allow the customer to retry.
- What happens when the customer rapidly taps the "Sign In" button multiple times? The system should prevent duplicate submissions by disabling the button after the first tap.
- What happens when the email field contains leading/trailing whitespace? The system should trim whitespace before validation and submission.
- What happens when the customer's session token expires while using the app (including when "Remember Me" was enabled)? The system should redirect the customer to the login screen with a "Session expired, please sign in again" message, clear the stored token, and require re-authentication.
- What happens when the customer rotates the device or changes screen size during login? The form state (entered text, validation errors) should be preserved.
- What happens when the server returns a 429 (Too Many Requests) response? The system should display a "Too many attempts. Please try again later." message and respect the server's retry-after period.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide an email input field that accepts text input and validates email format.
- **FR-002**: System MUST provide a password input field that obscures text by default.
- **FR-003**: System MUST provide a visibility toggle on the password field to show/hide the entered password.
- **FR-004**: System MUST validate that both email and password fields are non-empty before allowing submission.
- **FR-005**: System MUST validate that the email field contains a properly formatted email address.
- **FR-006**: System MUST display inline validation error messages directly beneath the relevant input field.
- **FR-007**: System MUST provide a "Sign In" button that initiates the authentication process.
- **FR-008**: System MUST display a loading indicator and disable the "Sign In" button while authentication is in progress.
- **FR-009**: System MUST navigate the customer to the main/home dashboard screen upon successful authentication. If the dashboard screen is not yet implemented, a placeholder screen MUST be used.
- **FR-010**: System MUST display an error message "Invalid email or password" when authentication fails due to incorrect credentials, without revealing which field is incorrect.
- **FR-011**: System MUST display a generic error message when authentication fails due to network or server errors, with an option to retry.
- **FR-012**: System MUST provide a "Remember Me" checkbox that persists the customer's session across app launches when enabled.
- **FR-013**: System MUST provide a "Forgot Password?" link that navigates to the password recovery screen.
- **FR-014**: System MUST provide a "Sign Up" link that navigates to the registration screen.
- **FR-015**: System MUST prevent duplicate form submissions when the customer taps "Sign In" multiple times.
- **FR-016**: System MUST trim leading and trailing whitespace from the email field before validation and submission.
- **FR-017**: System MUST store authentication tokens locally using app-sandbox-level storage when "Remember Me" is enabled, behind an abstract interface that allows future upgrade to encrypted storage. Raw passwords MUST NOT be stored.
- **FR-018**: System MUST display the login screen responsively across small phones (360dp), large phones (414dp), and tablets (768dp).
- **FR-019**: System MUST support both LTR and RTL layouts based on the app's current locale.

### Key Entities

- **Customer**: A registered user of the Wasla app. Key attributes: email address, first name, last name, unique customer identifier.
- **Authentication Session**: Represents an active login session. Key attributes: session token, expiration time, associated customer, "remember me" preference.
- **Login Credentials**: The information provided by the customer to authenticate. Key attributes: email address, password.

## Clarifications

### Session 2026-02-19

- Q: What is the specific post-login destination screen? → A: A main/home dashboard screen (placeholder if not yet built)
- Q: Should the app implement client-side rate limiting for failed login attempts? → A: No client-side rate limiting; rely on server-side protection (handle 429 if returned)
- Q: What happens when "Remember Me" is enabled but the server token expires? → A: Redirect to login with "Session expired, please sign in again" message; clear stored token
- Q: What level of token storage security is acceptable? → A: App-sandbox-level storage (SharedPreferences behind an abstract interface for future upgrade)

## Assumptions

- The authentication backend is available and provides a login endpoint that accepts email and password.
- Email/password is the sole authentication method for customers (no social login or SSO at this stage).
- The "Forgot Password" and "Sign Up" features are either already implemented or will be implemented as separate features; the login screen only provides navigation entry points.
- Session tokens have a server-defined expiration period; the app does not control token lifetime.
- The login screen design is available in Figma and will be followed pixel-perfect per Constitution Principle V.
- Password requirements (minimum length, complexity) are enforced at registration time, not on the login screen.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Customers can complete the sign-in flow (enter credentials and reach home screen) in under 30 seconds on a stable connection.
- **SC-002**: 95% of customers who enter valid credentials successfully authenticate on the first attempt.
- **SC-003**: Validation errors are displayed within 1 second of the customer submitting invalid input.
- **SC-004**: The login screen renders correctly and is fully usable on screens sized 360dp, 414dp, and 768dp.
- **SC-005**: Customers with "Remember Me" enabled are automatically signed in on subsequent app launches without re-entering credentials.
- **SC-006**: Failed login attempts display user-friendly error messages that do not expose sensitive information (e.g., whether an email is registered).
- **SC-007**: The login screen supports both LTR and RTL layouts without visual defects or usability issues.
