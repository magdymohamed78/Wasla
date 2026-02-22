# Feature Specification: Forget Password Page

**Feature Branch**: `001-forget-password`  
**Created**: 2026-02-22  
**Status**: Draft  
**Input**: User description: "Create a Forget Password page (UI only, no API integration). This page opens when the user clicks the existing 'Forgot Password?' text button in the Login page."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Request Password Reset (Priority: P1)

A user who has forgotten their password navigates to the Forget Password page from the Login screen. They enter their email address and receive visual confirmation that a reset link has been sent.

**Why this priority**: This is the core functionality of the page - enabling users to initiate the password reset process.

**Independent Test**: Can be fully tested by navigating to the page, entering a valid email, clicking Send, and verifying the success toast appears.

**Acceptance Scenarios**:

1. **Given** the user is on the Login page, **When** they click "Forgot Password?", **Then** the Forget Password page opens
2. **Given** the user is on the Forget Password page, **When** they enter a valid email and click Send, **Then** a success toast message "Reset link sent successfully" appears
3. **Given** the user has submitted their email, **When** the toast is shown, **Then** the page remains on the Forget Password screen (no navigation)

---

### User Story 2 - Form Validation Feedback (Priority: P2)

A user attempts to submit the form with invalid input and receives clear, helpful error messages guiding them to correct the input.

**Why this priority**: Essential for user experience - prevents frustration from unclear errors and ensures users know what to fix.

**Independent Test**: Can be tested by entering various invalid inputs and verifying appropriate error messages appear.

**Acceptance Scenarios**:

1. **Given** the email field is empty, **When** the user attempts to submit, **Then** "Email is required" error is displayed
2. **Given** the email field has an invalid format (e.g., "invalid-email"), **When** the user attempts to submit, **Then** "Please enter a valid email" error is displayed
3. **Given** the email is invalid, **When** the form is displayed, **Then** the Send button is disabled (light gray background)

---

### User Story 3 - Responsive Mobile Experience (Priority: P3)

A user accesses the Forget Password page from a mobile device and experiences a properly formatted, easy-to-use interface.

**Why this priority**: Mobile-first design ensures accessibility across all device types, though the core functionality works on any screen size.

**Independent Test**: Can be tested by viewing the page on various screen sizes and verifying the card remains centered and properly sized.

**Acceptance Scenarios**:

1. **Given** a user opens the page on a mobile device, **When** the page loads, **Then** the card container is centered with appropriate padding
2. **Given** a user is on any screen size, **When** they view the illustration, **Then** the image is responsive and centered

---

### Edge Cases

- What happens when the user rapidly clicks the Send button multiple times with a valid email? (Resolved: Button disabled during toast display)
- How does the page handle very long email addresses in the input field? (Resolved: Truncate with ellipsis, preserve full value)
- What happens if the forget password image fails to load? (Resolved: Hide section or show placeholder gracefully)
- How does the page behave when accessed via direct URL without coming from Login? (Resolved: Allow direct access, page loads normally)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a centered white card container on a light gray full-screen background
- **FR-002**: System MUST display the WASLA logo in red, bold, centered text at the top of the card
- **FR-003**: System MUST display the forget password illustration from "assets/forget password.png", centered and responsive
- **FR-004**: System MUST display the title "Forget Password ?" in bold, large font, centered
- **FR-005**: System MUST display the description "Don't worry! It occurs. Please enter the email address linked with your account." in small, gray, centered text
- **FR-006**: System MUST provide an email input field with label "Enter Your Email Address" and placeholder "yourmail@gmail.com"
- **FR-007**: System MUST validate the email field - showing "Email is required" when empty
- **FR-008**: System MUST validate the email field - showing "Please enter a valid email" when format is invalid
- **FR-009**: System MUST disable the Send button (light gray background) when email is invalid or empty
- **FR-010**: System MUST enable the Send button (red background) only when a valid email is entered
- **FR-011**: System MUST display a toast/snackbar message "Reset link sent successfully" when Send is clicked with valid email
- **FR-012**: System MUST NOT make any API calls or navigate to another page after Send is clicked
- **FR-013**: System MUST use mobile-first responsive layout with card max-width of 350-400px
- **FR-014**: System MUST support keyboard navigation (Tab to focus fields, Enter to submit)
- **FR-015**: System MUST include ARIA labels for form elements and toast announcements
- **FR-016**: System MUST manage focus state visibly and logically (focus moves to email field on page load)
- **FR-017**: System MUST disable the Send button during toast display to prevent duplicate submissions
- **FR-018**: System MUST gracefully handle illustration load failure by hiding the section or showing placeholder
- **FR-019**: System MUST truncate long email addresses with ellipsis in display while preserving full value

### Visual Requirements

- **VR-001**: Card container MUST have border-radius of 20px, soft shadow, and 24px padding
- **VR-002**: Email input field MUST have border-radius of 12px, light gray border, and full width
- **VR-003**: Send button MUST have red background, white text, height of ~48px, and border-radius of 12px
- **VR-004**: Send button hover state MUST show slightly darker red background
- **VR-005**: Disabled Send button MUST show light gray background

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can complete the password reset request flow in under 30 seconds
- **SC-002**: Form validation errors appear immediately upon invalid input, with zero delay
- **SC-003**: Page renders correctly on screen widths from 320px (mobile) to 1920px (desktop)
- **SC-004**: 100% of users who enter a valid email can successfully trigger the success toast
- **SC-005**: No API calls or page navigations occur when the Send button is clicked

## Clarifications

### Session 2026-02-22

- Q: What accessibility requirements should be implemented? → A: Basic accessibility (keyboard navigation, ARIA labels, focus management)
- Q: How should rapid button clicks be handled? → A: Disable button during toast display (prevent duplicates)
- Q: How should image load failure be handled? → A: Show placeholder image or hide section gracefully
- Q: How should long email addresses be handled? → A: Truncate with ellipsis in display (full value preserved)
- Q: How should direct URL access behave? → A: Allow direct access (page loads normally)

## Assumptions

- The Login page already exists with a "Forgot Password?" text button
- The illustration asset "assets/forget password.png" exists in the project
- The application has a toast/snackbar component available for displaying messages
- The WASLA brand uses red as the primary color
- No actual password reset functionality is required - this is UI-only