# Feature Specification: Update Forgot Password Endpoint Error Handling

**Feature Branch**: `026-forgot-password-errors`  
**Created**: 2026-03-10  
**Status**: Draft  
**Input**: User description: "Update the Forget Password flow based on the API response status codes from /api/Auth/forgot-password. Handle 404 (email not registered) and 403 (inactive account) with appropriate user feedback and navigation options."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Unregistered Email Feedback (Priority: P1)

A user enters an email that is not registered in the system on the Forgot Password page and taps "Send." Instead of navigating to the next screen, the system displays a toast message informing them the email is not registered and suggests signing up. The page always shows a "Don't have an account? Sign Up" text button below the Send button (visible regardless of error state), allowing the user to navigate directly to the Sign Up page.

**Why this priority**: This is the most common error scenario — users frequently mistype emails or attempt to reset passwords for unregistered accounts. Providing clear feedback and a direct path to sign up prevents user frustration and reduces drop-off.

**Independent Test**: Can be fully tested by entering a non-existent email, verifying the toast message appears, verifying no navigation occurs, and tapping the "Sign Up" link to confirm navigation to the Sign Up page.

**Acceptance Scenarios**:

1. **Given** the user is on the Forgot Password page, **When** they submit an email that is not registered (API returns 404), **Then** a toast message "Email not registered. Please sign up first." is displayed and the user remains on the Forgot Password page (no navigation to the next screen).
2. **Given** the user is on the Forgot Password page, **When** the page loads, **Then** a "Don't have an account? Sign Up" text is always visible below the Send button, where "Sign Up" acts as a tappable text button.
3. **Given** the "Sign Up" text button is visible on the page, **When** the user taps "Sign Up," **Then** the user is navigated to the Sign Up page.
4. **Given** the user is on the Forgot Password page after a 404 error, **When** they correct the email and resubmit, **Then** the normal flow resumes.

---

### User Story 2 - Inactive Account Feedback (Priority: P2)

A user enters an email that belongs to an existing but inactive account. The system displays a toast message informing them the account is inactive and advising them to contact support. The toast includes a "Contact Support" action button that navigates to the Support page. The user is not navigated to the next screen.

**Why this priority**: Less common than a missing account, but critical for users who have been deactivated. Without clear messaging and a direct path to support, these users are completely blocked with no recourse.

**Independent Test**: Can be fully tested by submitting an email tied to an inactive account, verifying the toast message is displayed with a "Contact Support" button, verifying the user stays on the current page, and tapping the button to confirm navigation to the Support page.

**Acceptance Scenarios**:

1. **Given** the user is on the Forgot Password page, **When** they submit an email for an inactive account (API returns 403), **Then** a toast message "Account exists but is inactive — please contact support." is displayed with a "Contact Support" action button, and the user remains on the Forgot Password page.
2. **Given** the 403 toast is displayed with a "Contact Support" button, **When** the user taps the button, **Then** the user is navigated to the Support page.

---

### User Story 3 - Successful Password Reset Request (Priority: P1)

A user enters a valid, registered, and active email. The system sends the OTP and navigates the user to the Change Password screen. This is the existing happy-path flow that must continue to work correctly.

**Why this priority**: The core functionality must not regress while adding error handling for new status codes.

**Independent Test**: Can be fully tested by entering a registered active email and verifying navigation to the Change Password screen occurs.

**Acceptance Scenarios**:

1. **Given** the user is on the Forgot Password page, **When** they submit a registered and active email (API returns 200), **Then** the user is navigated to the Change Password page with the email passed as context.

---

### Edge Cases

- What happens when the user submits the same unregistered email multiple times in quick succession? The 404 toast should appear each time; the sign-up link is always present (static page element) so no duplication concern.
- What happens if the user triggers a 404 error first and then a 403 error (or vice versa)? The appropriate toast message for the latest error should be shown; no conditional UI elements change since errors are toast-only.
- What happens if the API returns a 429 (rate limit) response? The existing rate-limit error handling should continue to function as-is.
- What happens if the user has no internet connection? The existing network error handling should remain intact.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: When the `/api/Auth/forgot-password` endpoint returns a 404 status code, the system MUST NOT navigate the user to the next screen.
- **FR-002**: When a 404 response is received, the system MUST display a toast message with the text: "Email not registered. Please sign up first."
- **FR-003**: The Forgot Password page MUST always display a "Don't have an account? Sign Up" text below the Send button, where "Sign Up" is a tappable text button. This is a static page element, not conditional on any error.
- **FR-004**: When the user taps the "Sign Up" text button, the system MUST navigate the user to the Sign Up page.
- **FR-005**: When the `/api/Auth/forgot-password` endpoint returns a 403 status code, the system MUST NOT navigate the user to the next screen.
- **FR-006**: When a 403 response is received, the system MUST display a toast message with the text: "Account exists but is inactive — please contact support." The toast MUST include a "Contact Support" action button.
- **FR-007**: When the user taps the "Contact Support" action button in the 403 toast, the system MUST navigate the user to the Support page.
- **FR-008**: Navigation to the Change Password screen MUST only occur when the API response is 200 (successful).
- **FR-009**: Existing error handling for 429 (rate limit), network errors, and unexpected errors MUST continue to function without regression.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users who submit an unregistered email see a clear error message and a direct path to sign up within 1 second of submission, with no unintended navigation.
- **SC-002**: Users with inactive accounts see a clear error message and a way to reach the support page within 1 second of submission, with no unintended navigation.
- **SC-003**: 100% of successful forgot-password submissions (200 OK) continue to navigate to the Change Password screen without interruption.
- **SC-004**: All five API response codes (200, 400, 403, 404, 429) produce the correct user-facing behavior as defined in the API contract.
- **SC-005**: Users can navigate to the Sign Up page from the Forgot Password page in a single tap at any time.
- **SC-006**: Users with inactive accounts can navigate to the Support page directly from the 403 toast action button in a single tap.

## Clarifications

### Session 2026-03-10

- Q: What should the 403 support navigation element's label text and placement be? → A (updated): The 403 toast message includes a "Contact Support" action button that navigates to the Support page. The "Don't have an account? Sign Up" text is always visible below the Send button as part of the page layout (not conditional on 404).

## Assumptions

- The `/api/Auth/forgot-password` endpoint reliably returns 404 for unregistered emails and 403 for inactive accounts, as documented in the swagger.json specification.
- The Sign Up page and Support page already exist and are routable within the app's navigation system.
- Toast messages follow the app's existing toast/snackbar styling and behavior (floating, 4-second duration, error background color).
- The "Don't have an account? Sign Up" text button follows the same visual pattern used on the Login page for consistency.
- Localization strings will be added for all new user-facing text (toast messages, sign-up link text) in both English and Arabic.
