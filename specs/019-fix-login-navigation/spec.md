# Feature Specification: Fix Login Navigation to Home Screen

**Feature Branch**: `019-fix-login-navigation`  
**Created**: 2026-02-23  
**Status**: Draft  
**Input**: User description: "login page logic - after successful login response the app does not navigate to the Home screen"

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - Successful Login Navigates to Home (Priority: P1)

As a customer, after I enter valid login credentials and the system confirms authentication, I am automatically taken to the Home screen so that I can begin using the app immediately.

**Why this priority**: This is the core broken behavior. Without this fix, authenticated users are stuck on the login screen despite successful authentication, rendering the app unusable after login.

**Independent Test**: Can be fully tested by entering valid email/password, submitting, and verifying the Home screen appears. Delivers the fundamental value of completing the login flow.

**Acceptance Scenarios**:

1. **Given** the user is on the login screen and has entered valid credentials, **When** the login button is pressed and the backend returns a successful response, **Then** the user is navigated to the Home screen within 2 seconds of receiving the response.
2. **Given** the user is on the login screen and the backend returns a successful login response, **When** the session is persisted, **Then** the session data must be fully saved before navigation occurs so that the Home screen can verify the user is authenticated.
3. **Given** the user has just successfully logged in and been navigated to the Home screen, **When** they press the system back button, **Then** they should NOT be returned to the login screen (the login route should be replaced, not pushed).

---

### User Story 2 - Session Persistence After Navigation (Priority: P2)

As a customer who has just logged in and arrived at the Home screen, I expect that my session is fully stored so that I am not redirected back to login by any authentication guard or route protection.

**Why this priority**: Even if navigation happens, a missing or incomplete session could cause the Home screen's route guard to bounce the user back to login, creating a redirect loop.

**Independent Test**: Can be tested by logging in successfully, verifying arrival at Home, and confirming that the stored session (token, user data) is complete and valid.

**Acceptance Scenarios**:

1. **Given** the user has completed a successful login, **When** they arrive at the Home screen, **Then** the stored session contains a valid authentication token, user ID, first name, last name, and email.
2. **Given** the user has completed a successful login and is on the Home screen, **When** the app checks session validity (e.g., on route guard), **Then** the session check returns a valid, non-null session.

---

### User Story 3 - Loading Indicator During Login (Priority: P3)

As a customer, I want to see a clear loading indicator after I press the login button so that I know the app is processing my request and I don't press the button multiple times.

**Why this priority**: While the primary issue is navigation, proper loading feedback during the login-to-home transition ensures the user understands the app is working and prevents duplicate submissions.

**Independent Test**: Can be tested by pressing the login button and verifying a loading state appears until navigation completes or an error is shown.

**Acceptance Scenarios**:

1. **Given** the user presses the login button with valid credentials, **When** the request is being processed, **Then** a loading indicator is shown and the login button is disabled.
2. **Given** the login request is in progress, **When** the response is received (success or failure), **Then** the loading indicator is removed before the next screen transition or error display.

---

### Edge Cases

- What happens if the session save operation fails silently after the backend confirms a successful login? The user should see an error message and remain on the login screen rather than navigating to an unprotected Home screen.
- What happens if the user rapidly taps the login button multiple times before the first request completes? Only one login request should be processed, and duplicate submissions must be prevented.
- What happens if the network connection drops between receiving the successful login response and completing the session save? The user should see an appropriate error and be able to retry.
- What happens if the user navigates away from the login page (e.g., presses back) while the login request is in progress? The pending operation should be cancelled and no navigation to Home should occur.
- What happens if the Home screen's route guard checks the session before the session save has fully completed? The user must not be redirected back to login.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST navigate the user to the Home screen immediately after a successful login response is received and the session is persisted.
- **FR-002**: System MUST fully persist the user session (authentication token, user ID, customer ID, name, email) before initiating navigation to the Home screen.
- **FR-003**: System MUST replace the login screen in the navigation stack when navigating to Home (not push on top) so the user cannot navigate back to the login screen via the back button.
- **FR-004**: System MUST ensure the Home screen's route protection recognizes the freshly saved session so no redirect back to login occurs.
- **FR-005**: System MUST prevent duplicate login submissions while a login request is in progress.
- **FR-006**: System MUST display a loading indicator from the moment the login button is pressed until navigation to Home completes or an error is displayed.
- **FR-007**: System MUST display a user-friendly error message if session persistence fails after a successful backend response, and keep the user on the login screen.

### Key Entities

- **User Session**: Represents the authenticated user's persisted credentials and profile data (token, user ID, customer ID, first name, last name, email). Must be fully stored before any navigation occurs.
- **Login State**: Represents the current status of the login process (initial, loading, success, failure). The transition from loading → success must trigger navigation.

## Assumptions

- The backend login endpoint is functioning correctly and returning valid successful responses (the user has confirmed this via logs).
- The issue is isolated to the client-side flow between receiving a successful response and navigating to the Home screen.
- The Home screen already exists as a placeholder page and is routable.
- Session storage uses on-device persistent storage which is available and writable.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of successful login attempts result in the user arriving at the Home screen within 2 seconds of the backend response.
- **SC-002**: After a successful login and navigation to Home, pressing the back button does NOT return the user to the login screen.
- **SC-003**: The stored session is valid and complete after login, passing all route protection checks without redirect loops.
- **SC-004**: Zero duplicate login requests are sent when the user taps the login button multiple times in rapid succession.
