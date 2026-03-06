# Feature Specification: Forgot Password Flow – UI + API Implementation

**Feature Branch**: `024-forgot-password-flow`  
**Created**: 2026-03-05  
**Status**: Draft  
**Input**: User description: "Forgot Password Flow – UI + API Implementation. Three-screen flow: Forgot Password (email entry), OTP Verification (6-digit code), and Change Password (new password entry). Full API integration with forgot-password, resend-otp, and reset-password endpoints."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Request OTP via Email (Priority: P1)

A user who has forgotten their password navigates to the Forgot Password screen from the Login page. They enter their registered email address and press Send. The system sends an OTP to their email and navigates them to the OTP Verification screen, carrying the email address forward for subsequent requests.

**Why this priority**: This is the entry point of the entire password recovery flow. Without it, the user cannot begin resetting their password.

**Independent Test**: Can be fully tested by navigating from Login, entering a valid email, pressing Send, and verifying that the app navigates to the OTP Verification screen with the email passed through.

**Acceptance Scenarios**:

1. **Given** the user is on the Login page, **When** they tap "Forgot Password?", **Then** the Forgot Password screen opens
2. **Given** the user is on the Forgot Password screen with a valid email entered, **When** they press Send, **Then** a loading indicator appears on the button during the request
3. **Given** the API request succeeds (200 OK), **When** the response is received, **Then** the user is navigated to the OTP Verification screen with the email passed to it
4. **Given** the user enters an empty or invalid email, **When** they attempt to press Send, **Then** the Send button remains disabled
5. **Given** the API returns a rate-limit error (429), **When** the response is received, **Then** an appropriate error message is displayed to the user

---

### User Story 2 - Verify OTP Code (Priority: P1)

After receiving the OTP via email, the user enters the 6-digit code on the OTP Verification screen. A countdown timer shows the remaining time to resend. If the timer expires, a "Resend OTP" button appears. Upon entering all 6 digits and pressing Verify, the system validates the input and navigates to the Change Password screen, passing the email and OTP forward.

**Why this priority**: OTP verification is the security gate of the flow. The user cannot proceed to resetting their password without this step.

**Independent Test**: Can be fully tested by entering a 6-digit OTP, pressing Verify, and verifying navigation to the Change Password screen. Resend OTP can be tested independently by waiting for the timer to expire and pressing the Resend button.

**Acceptance Scenarios**:

1. **Given** the user is on the OTP Verification screen, **When** the screen loads, **Then** a 60-second countdown timer starts and is displayed below the OTP input boxes
2. **Given** the user enters a digit in an OTP box, **When** the digit is entered, **Then** the focus auto-advances to the next box
3. **Given** all 6 OTP digits are entered, **When** the user views the Verify button, **Then** it becomes enabled
4. **Given** fewer than 6 digits are entered, **When** the user views the Verify button, **Then** it remains disabled
5. **Given** all 6 digits are entered and the user presses Verify, **When** the action is triggered, **Then** the email and OTP are passed to the Change Password screen
6. **Given** the 60-second countdown reaches zero, **When** the timer expires, **Then** the timer text disappears and a "Resend OTP" text button appears
7. **Given** the user presses "Resend OTP", **When** the resend request succeeds, **Then** a new OTP is sent to their email and the 60-second countdown restarts
8. **Given** the user pastes a 6-digit code from the clipboard, **When** the paste action occurs, **Then** all 6 boxes are filled with the pasted digits
9. **Given** the user has entered a digit in an OTP box, **When** they press backspace, **Then** the current digit is cleared and focus moves to the previous box
10. **Given** the user presses "Resend OTP" and the API returns 429, **When** the error response is received, **Then** a "Too many requests" error message is shown and the 60-second countdown timer restarts

---

### User Story 3 - Set New Password (Priority: P1)

On the Change Password screen, the user enters a new password and confirms it. Upon pressing Confirm, the system calls the reset-password endpoint with the email, OTP, new password, and confirmation. On success, the user is redirected to the Login screen.

**Why this priority**: This is the final step that actually resets the password. Without it, the entire flow has no effect.

**Independent Test**: Can be fully tested by entering matching valid passwords, pressing Confirm, and verifying that on API success the user is redirected to the Login screen.

**Acceptance Scenarios**:

1. **Given** the user is on the Change Password screen, **When** the screen loads, **Then** the change password illustration is displayed at the top of the card
2. **Given** the user enters a new password with fewer than 6 characters, **When** they attempt to press Confirm, **Then** the Confirm button remains disabled and a validation error is shown
3. **Given** the user enters a valid new password and a matching confirmation, **When** they press Confirm, **Then** a loading indicator appears and the reset-password request is sent with email, OTP, new password, and confirmation
4. **Given** the API returns success (200), **When** the response is received, **Then** a success toast/snackbar "Password reset successfully" is shown and the user is navigated to the Login screen
5. **Given** the new password and confirm password do not match, **When** the mismatch is detected, **Then** the confirm password field border turns red and an inline error message "Passwords do not match" is displayed
6. **Given** the API returns an error (400 — invalid/expired OTP), **When** the response is received, **Then** an error message is displayed and the user is auto-navigated back to Screen A (Forgot Password) after a short delay
7. **Given** the API returns a 400 error for password policy violation, **When** the response is received, **Then** an inline error message is shown and the user remains on Screen C to correct the password
8. **Given** the API returns a rate-limit error (429), **When** the response is received, **Then** an appropriate error message is displayed

---

### User Story 4 - Form Validation and Error Handling Across All Screens (Priority: P2)

Across the entire forgot password flow, the user receives clear, immediate feedback for invalid inputs. Loading states prevent duplicate submissions. Error messages from the server are displayed in a user-friendly manner.

**Why this priority**: Good validation and error handling prevents user frustration and ensures a polished experience, but the core flow can function with basic validation alone.

**Independent Test**: Can be tested by entering various invalid inputs across all three screens and verifying appropriate error messages appear and buttons remain disabled until inputs are valid.

**Acceptance Scenarios**:

1. **Given** the user is on the Forgot Password screen with an empty email, **When** they view the Send button, **Then** it is disabled
2. **Given** the user enters an invalidly formatted email, **When** validation runs, **Then** an inline error message "Please enter a valid email" appears and the Send button remains disabled
3. **Given** any screen is making an API call, **When** the user views the primary action button, **Then** a loading indicator is shown and the button is not tappable
4. **Given** the user is on the Change Password screen and toggles the eye icon, **When** they tap it, **Then** the password field toggles between masked and visible text
5. **Given** a network error occurs during any API call, **When** the error is caught, **Then** a user-friendly error message is displayed

---

### Edge Cases

- What happens if the user navigates back from the OTP screen to the Forgot Password screen and resubmits? The previous OTP is invalidated by the server; a new one is issued.
- What happens if the user enters an unregistered email on the Forgot Password screen? The API always returns 200 OK (to prevent email enumeration), so the app navigates to the OTP screen regardless. The user will simply never receive an OTP.
- What happens if the OTP expires (10 minutes server-side) before the user enters it on the Change Password screen? The reset-password API returns 400; the app shows an error message on Screen C, then auto-navigates back to Screen A (Forgot Password) after a short delay so the user can request a new OTP.
- What happens if the user makes 5 incorrect OTP attempts? The OTP is permanently invalidated server-side; the user must request a new one via Resend OTP or restart the flow.
- What happens if the rate limit (429) is hit? The app displays a "Too many requests. Please try again later." message.
- What happens if the user kills the app mid-flow and returns? The in-memory email/OTP data is lost; the user must restart from the Forgot Password screen.
- What happens if the user presses Resend OTP before the timer expires? The Resend OTP button is not visible until the timer expires, preventing premature resend.

## Requirements *(mandatory)*

### Functional Requirements

**Screen A — Forgot Password**

- **FR-001**: System MUST display a Forgot Password screen accessible from the Login page's "Forgot Password?" button
- **FR-002**: System MUST display the same background styling and top-center WASLA logo as other screens in the app
- **FR-003**: System MUST display a centered white rounded card containing the form elements
- **FR-004**: System MUST provide an email input field for the user to enter their registered email address
- **FR-005**: System MUST validate the email field — the Send button remains disabled when the email is empty or has an invalid format
- **FR-006**: System MUST show inline validation errors: "Email is required" when empty, "Please enter a valid email" when format is invalid
- **FR-007**: System MUST call `POST /api/Auth/forgot-password` with the entered email when Send is pressed
- **FR-008**: System MUST show a loading indicator on the Send button while the API request is in progress
- **FR-009**: System MUST navigate to the OTP Verification screen on a successful response, passing the email address
- **FR-010**: System MUST display an error message if the API returns a 429 (rate limit) response

**Screen B — OTP Verification**

- **FR-011**: System MUST display an OTP Verification screen with the title "Change Password" and helper text "Enter the OTP sent to your email to proceed."
- **FR-012**: System MUST display 6 individual input boxes (~40–44px square, 1px border, ~10–12px gap) for the OTP digits
- **FR-013**: System MUST auto-advance focus to the next OTP box when a digit is entered
- **FR-013a**: System MUST move focus back to the previous OTP box when backspace is pressed, clearing the current digit
- **FR-014**: System MUST support paste functionality — pasting a 6-digit code fills all boxes
- **FR-015**: System MUST display a 60-second countdown timer below the OTP inputs showing the remaining time
- **FR-016**: System MUST replace the timer with a "Resend OTP" text button when the countdown reaches zero
- **FR-017**: System MUST call `POST /api/Auth/resend-otp` with the stored email when "Resend OTP" is pressed, and restart the 60-second timer on success
- **FR-017a**: If the resend-otp API returns 429 (rate limit), the system MUST show a "Too many requests" error message and restart the 60-second countdown timer to prevent immediate re-tap
- **FR-018**: System MUST keep the Verify button disabled until all 6 OTP digits are entered
- **FR-019**: System MUST navigate to the Change Password screen when Verify is pressed, passing both the email and the entered OTP
- **FR-020**: System MUST display appropriate visual states for OTP fields: default (light border), focused (stronger border), filled (shows digit), error (red border + error message)

**Screen C — Change Password**

- **FR-021**: System MUST display a Change Password screen with the illustration from `assets/images/changepassword.png` centered at the top of the card
- **FR-022**: System MUST display the title "Change Password" and helper text "Your new password must be different from previously used passwords."
- **FR-023**: System MUST provide two password fields: "New Password" and "Confirm Password", both masked by default
- **FR-024**: System MUST provide an eye icon toggle on each password field to switch between masked and visible text
- **FR-025**: System MUST validate that the new password is at least 6 characters long
- **FR-026**: System MUST validate that the Confirm Password matches the New Password
- **FR-027**: System MUST show inline error messages when validation fails (e.g., "Passwords do not match", "Password must be at least 6 characters")
- **FR-028**: System MUST highlight field borders in red when validation errors are present
- **FR-029**: System MUST keep the Confirm button disabled until both password fields are valid and matching
- **FR-030**: System MUST call `POST /api/Auth/reset-password` with email, OTP, new password, and confirm password when Confirm is pressed
- **FR-031**: System MUST show a loading indicator on the Confirm button while the API request is in progress
- **FR-032**: System MUST show a brief success toast/snackbar (e.g., "Password reset successfully") on a successful password reset (200 OK), then navigate the user to the Login screen
- **FR-033**: System MUST display an error message if the API returns 400 (invalid/expired OTP, password policy violation) or 429 (rate limit)
- **FR-033a**: When the reset-password API returns 400 (expired or invalidated OTP), the system MUST show the error message on Screen C, then auto-navigate the user back to Screen A (Forgot Password) after a short delay to restart the flow

**Cross-Screen Requirements**

- **FR-034**: System MUST pass the email address from the Forgot Password screen through the OTP screen to the Change Password screen
- **FR-035**: System MUST pass the OTP from the OTP Verification screen to the Change Password screen
- **FR-036**: System MUST disable primary action buttons during API calls to prevent duplicate submissions
- **FR-037**: System MUST display user-friendly error messages for all API failure responses (400, 429, network errors)

### Key Entities

- **Email**: The user's registered email address; entered on Screen A and passed through all subsequent screens as a required parameter for every API call in the flow
- **OTP (One-Time Password)**: A 6-digit code sent to the user's email; valid for 10 minutes server-side, invalidated after 5 incorrect attempts; entered on Screen B and passed to Screen C for the final API call
- **New Password**: The user's desired new password; must be at least 6 characters; entered on Screen C along with a matching confirmation

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can complete the entire forgot password flow (email → OTP → new password → login) in under 3 minutes (excluding time waiting for the OTP email)
- **SC-002**: 95% of users who begin the forgot password flow successfully reset their password on the first attempt
- **SC-003**: Form validation errors appear within 1 second of invalid input across all three screens
- **SC-004**: Loading indicators are visible during every API call, preventing duplicate submissions
- **SC-005**: All three screens render correctly and are usable on mobile screen sizes from 320px width upward
- **SC-006**: Users who receive a rate-limit or server error see a clear, actionable message within 1 second of the response

## Clarifications

### Session 2026-03-05

- Q: When reset-password returns 400 (expired/invalidated OTP), what is the recovery behavior on Screen C? → A: Show error message, then auto-navigate back to Screen A (Forgot Password) after a short delay so the user can request a new OTP.
- Q: After a successful password reset on Screen C, should the app show a success confirmation before navigating to Login? → A: Show a brief success toast/snackbar, then navigate to the Login screen.
- Q: Should backspace on an OTP box clear the digit and move focus to the previous box? → A: Yes — pressing backspace clears the current digit and auto-moves focus to the previous box.
- Q: When Resend OTP is pressed and the API returns 429 (rate limit), what should happen? → A: Show a "Too many requests" error message and restart the 60-second timer to prevent immediate re-tap.

## Assumptions

- The Login page already exists with a "Forgot Password?" text button that navigates to Screen A
- The app shares a consistent visual system (background, WASLA logo, white rounded card) across authentication screens
- The illustration asset `assets/images/changepassword.png` exists in the project
- The app has a routing/navigation mechanism capable of passing data (email, OTP) between screens
- The backend enforces a minimum 6-character password policy as specified in the ResetPasswordDto schema
- The 60-second countdown on the OTP screen is a UI-side timer controlling when the user can request a resend; the actual OTP validity is 10 minutes server-side
- The `POST /api/Auth/forgot-password` endpoint always returns 200 OK regardless of whether the email exists, to prevent email enumeration — the app treats this as a success and navigates forward
- The `POST /api/Auth/reset-password` endpoint performs both OTP verification and password reset in a single call — there is no separate OTP-only verification endpoint
- After a successful password reset, the user is navigated to the Login screen (not automatically logged in)
