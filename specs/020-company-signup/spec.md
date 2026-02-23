# Feature Specification: Customer Portal Sign Up Page

**Feature Branch**: `020-company-signup`  
**Created**: 2026-02-23  
**Status**: Draft  
**Input**: User description: "Create Sign Up page for the customer portal with form fields (First Name, Last Name, Phone Number, Email, Password, Confirm Password) matching the login page visual style, integrating with POST /api/customer-portal/register endpoint."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Successful Account Registration (Priority: P1)

A new user visits the Sign Up page, fills in their first name, last name, phone number, email address, and password (with confirmation), and submits the form. The system creates a Lead account and the user is automatically logged in with their new session.

**Why this priority**: This is the core registration flow — without it, no new users can join the platform. It is the fundamental entry point for all portal users.

**Independent Test**: Can be fully tested by navigating to the Sign Up page, filling all fields with valid data, tapping "Sign Up →", and verifying the user is redirected to the home screen with an active session.

**Acceptance Scenarios**:

1. **Given** the user is on the Sign Up page, **When** they fill all required fields (first name, last name, email, password, confirm password) with valid data and tap "Sign Up →", **Then** the system creates a Lead account and navigates the user to the home screen.
2. **Given** the user is on the Sign Up page, **When** they also provide an optional phone number along with all required fields and tap "Sign Up →", **Then** the system creates a Lead account with the phone number stored.
3. **Given** the user has just registered, **When** the system receives the response, **Then** the user's session token, name, and lead ID are persisted locally so they remain logged in.

---

### User Story 2 - Client-Side Form Validation (Priority: P1)

Before submitting, the form validates all input fields in real-time. The Sign Up button remains disabled until every required field passes validation. Error messages appear in red below the offending field.

**Why this priority**: Prevents unnecessary network requests and gives users immediate feedback, which is critical for a good registration experience.

**Independent Test**: Can be tested entirely offline by entering invalid data in each field and verifying error messages appear and the button stays disabled.

**Acceptance Scenarios**:

1. **Given** the user leaves the First Name field empty, **When** the field loses focus, **Then** an error message "First name is required" appears below the field.
2. **Given** the user leaves the Last Name field empty, **When** the field loses focus, **Then** an error message "Last name is required" appears below the field.
3. **Given** the user enters an invalid email (e.g., "notanemail"), **When** the field loses focus, **Then** an error message "Enter a valid email address" appears below the field.
4. **Given** the user enters a password shorter than 6 characters, **When** the field loses focus, **Then** an error message "Password must be at least 6 characters" appears below the field.
5. **Given** the user enters a confirm password that does not match the password field, **When** the confirm password field loses focus, **Then** an error message "Passwords do not match" appears below the field.
6. **Given** one or more required fields have validation errors, **When** the user views the Sign Up button, **Then** it is visually disabled and non-interactive.
7. **Given** all required fields are filled with valid data and passwords match, **When** the user views the Sign Up button, **Then** it becomes enabled and interactive.

---

### User Story 3 - Server-Side Error Handling (Priority: P2)

When the server rejects a registration request (e.g., email already in use, validation error, server error), the user sees a clear, actionable error message without losing their form input.

**Why this priority**: Users need to understand why registration failed and how to fix it, but basic happy-path registration must work first.

**Independent Test**: Can be tested by attempting to register with an email address that is already in use and verifying the appropriate error message is displayed.

**Acceptance Scenarios**:

1. **Given** the user submits the form with an email already registered, **When** the server responds with a 409 Conflict, **Then** the user sees an inline error message "This email is already registered" displayed in red below the Email Address field, and the form data is preserved.
2. **Given** the user submits the form with invalid data that passes client-side validation, **When** the server responds with a 400 Bad Request and the error relates to a specific field, **Then** the user sees the validation error inline below the relevant field.
3. **Given** the server is unreachable or returns a 500 error, **When** the user submits the form, **Then** the user sees a floating snackbar error message "Something went wrong. Please try again later." with a retry option.
4. **Given** an error message is displayed, **When** the user corrects the issue and resubmits, **Then** the previous error (inline or snackbar) is cleared and the new submission is processed.

---

### User Story 4 - Visual Consistency with Login Page (Priority: P2)

The Sign Up page mirrors the visual layout and styling of the existing Login page: same background color, same card container style, same logo placement above the card, same input field styling, same button styling. A user switching between Login and Sign Up should perceive them as part of the same visual family.

**Why this priority**: Visual consistency reinforces brand identity and user trust. Important but secondary to functional registration.

**Independent Test**: Can be verified by placing login and sign-up screenshots side by side and confirming matching background, card style, logo, input fields, and button appearance.

**Acceptance Scenarios**:

1. **Given** the user is on the Sign Up page, **When** they look at the overall layout, **Then** they see the same background color, centered card with large rounded corners and soft shadow as the login page.
2. **Given** the user is on the Sign Up page, **When** they look above the card, **Then** they see the Wasla logo (red circle with "W" followed by "ASLA" in red uppercase).
3. **Given** the user is on the Sign Up page, **When** they look at the card title, **Then** they see "Sign Up" in semi-bold centered text.
4. **Given** the user focuses on any input field, **When** the field gains focus, **Then** its border color changes to red.
5. **Given** the user views the submit button, **When** the button is enabled, **Then** it is red with white text reading "Sign Up →", full-width, with rounded corners and subtle shadow.

---

### User Story 5 - Password Visibility Toggle (Priority: P3)

Users can toggle the visibility of the Password and Confirm Password fields independently using an eye icon, allowing them to verify what they typed.

**Why this priority**: Improves usability but is not blocking for registration.

**Independent Test**: Can be tested by tapping the eye icon on each password field and verifying the text toggles between obscured and visible.

**Acceptance Scenarios**:

1. **Given** the password field contains text and is obscured, **When** the user taps the eye icon, **Then** the password text becomes visible and the icon changes to indicate visibility is on.
2. **Given** the password field text is visible, **When** the user taps the eye icon again, **Then** the text becomes obscured again.
3. **Given** the confirm password field is independent from the password field, **When** the user toggles visibility on one, **Then** the other field's visibility is not affected.

---

### User Story 6 - Navigation Between Login and Sign Up (Priority: P3)

Users can navigate from the Sign Up page to the Login page and vice versa.

**Why this priority**: Navigation between auth pages is expected but the login page already includes a "Sign Up" link, so the reverse link is a completeness concern.

**Independent Test**: Can be tested by tapping the "Log In" link on the Sign Up page and verifying navigation to the Login page.

**Acceptance Scenarios**:

1. **Given** the user is on the Sign Up page, **When** they tap the "Already have an account? Log In" link, **Then** they are navigated to the Login page.
2. **Given** the user is on the Login page, **When** they tap the existing "Sign Up" link, **Then** they are navigated to the Sign Up page.

---

### Edge Cases

- What happens when the user submits the form with leading/trailing whitespace in name fields? The system should trim whitespace before submission.
- What happens when the user double-taps the Sign Up button? The system should prevent duplicate submissions by disabling the button during loading.
- What happens when the user loses network connectivity mid-submission? A network error message should be displayed and the form data preserved.
- What happens when the phone number contains non-numeric characters? The phone number field should accept standard phone formats (digits, +, -, spaces, parentheses).
- What happens when the user pastes a very long string into a field? Fields should enforce maximum length limits (first/last name: 100 chars, email: 256 chars, phone: 50 chars).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a Sign Up page accessible from the login screen's "Sign Up" link.
- **FR-002**: System MUST display the Wasla logo (red circle with "W" + "ASLA" text) above the card container, matching the login page placement.
- **FR-003**: System MUST display a centered "Sign Up" title in semi-bold font at the top of the card.
- **FR-004**: System MUST present a form with the following fields in order: First Name, Last Name, Phone Number, Email Address, Password, Confirm Password.
- **FR-005**: System MUST mark First Name, Last Name, Email Address, and Password as required fields. Phone Number is optional.
- **FR-006**: System MUST show the placeholder "youremail@gmail.com" in the Email Address field.
- **FR-007**: System MUST provide a visibility toggle (eye icon) on both the Password and Confirm Password fields.
- **FR-008**: System MUST validate email format on the client side before submission.
- **FR-009**: System MUST validate that the password is at least 6 characters long.
- **FR-010**: System MUST validate that the Confirm Password field matches the Password field.
- **FR-011**: System MUST validate that First Name and Last Name are not empty and do not exceed 100 characters.
- **FR-012**: System MUST validate that Phone Number (if provided) does not exceed 50 characters.
- **FR-013**: System MUST display validation error messages in red below the respective field.
- **FR-014**: System MUST keep the "Sign Up →" button disabled until all required fields pass validation and passwords match.
- **FR-015**: System MUST submit registration data to the server when the user taps the enabled "Sign Up →" button.
- **FR-016**: System MUST display a loading indicator on the button during submission and prevent duplicate submissions.
- **FR-017**: On successful registration (201 response), the system MUST store the returned session token and user data locally and navigate to the home screen.
- **FR-018**: On a 409 Conflict response, the system MUST display "This email is already registered" as an inline error below the Email Address field.
- **FR-019**: On a 400 Bad Request response, the system MUST display the server-provided validation error message inline below the relevant field (if field-specific) or as a floating snackbar (if general).
- **FR-020**: On a 500 or network error, the system MUST display a generic error message as a floating snackbar with the option to retry.
- **FR-021**: System MUST preserve all form data when displaying server-side errors so the user can correct and resubmit.
- **FR-022**: All input fields MUST have white background, light grey border, medium rounded corners, consistent height (~50px), and equal spacing.
- **FR-023**: When an input field receives focus, its border color MUST change to red.
- **FR-024**: The Sign Up button MUST be full-width, red with white text, rounded corners, and a subtle shadow.
- **FR-025**: The page MUST include a link to navigate back to the Login page (e.g., "Already have an account? Log In").

### Key Entities

- **Lead**: A portal user who has registered but is not yet linked to any company. Created upon successful registration. Key attributes: first name, last name, email, phone number (optional), lead ID.
- **Session Token (JWT)**: Returned upon successful registration, contains a `leadId` claim. Used to authenticate subsequent requests.
- **Registration Request**: The data submitted by the user: first name, last name, email, password, and optionally phone number. Confirm password is used for client-side validation only and is not sent to the server.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can complete the registration process (from opening the page to arriving at the home screen) in under 2 minutes.
- **SC-002**: 95% of users who begin filling the form successfully submit it on the first attempt (excluding duplicate email cases).
- **SC-003**: All client-side validation errors are displayed within 300ms of the user leaving a field.
- **SC-004**: Users who enter an already-registered email see a clear, specific error message (not a generic one) and can correct it without re-entering other fields.
- **SC-005**: The Sign Up page is visually indistinguishable in style from the Login page when compared side by side (same card, colors, spacing, fonts, shadow).
- **SC-006**: The page is usable on mobile screens (320px width and above) with no horizontal scrolling or clipped content.

## Clarifications

### Session 2026-02-23

- Q: Where should server-side error messages (409/400/500) be displayed? → A: Mixed approach — field-specific errors (409 email duplicate, 400 field validation) displayed inline below the relevant field; general errors (500/network) displayed as a floating snackbar.

## Assumptions

- The API server is available and the `/api/customer-portal/register` endpoint is implemented as documented in the Swagger specification.
- Password requirements are limited to a minimum of 6 characters (as specified in the API schema). No additional complexity rules (uppercase, special characters) are enforced unless the server rejects them.
- Phone number format is free-text with a maximum of 50 characters — no specific country format validation is required on the client side.
- After successful registration, the user receives a JWT with a `leadId` claim and is navigated to the home screen. The user is in "Lead" state (not yet connected to any company).
- The Confirm Password field is purely a client-side convenience; only the password value is sent in the registration request.
- The existing login page's visual design (background color, card container style, logo placement, field styling) serves as the authoritative design reference for this page.
