# Feature Specification: Settings Page (Lead & Customer)

**Feature Branch**: `029-settings-page`  
**Created**: 2026-04-15  
**Status**: Draft  
**Input**: User description: "Design and implement a complete Settings Page supporting both Lead and Customer roles, with profile information, digital signature handling, security actions, and language selection."

## Clarifications

### Session 2026-04-15

- Q: Should logout actions require confirmation before proceeding? → A: Confirm only Logout All Devices. Logout Current Session does not require confirmation.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Profile Identity Card (Priority: P1)

As an authenticated user (Lead or Customer), I want to see my profile identity at the top of the Settings page so I can quickly confirm which account I am signed in with.

**Why this priority**: The identity card establishes context for all subsequent settings actions and confirms correct account ownership.

**Independent Test**: Can be fully tested by opening Settings as Lead and Customer, verifying avatar initials and full name display correctly.

**Acceptance Scenarios**:

1. **Given** the user is authenticated and opens Settings, **When** the page renders, **Then** a circular avatar is displayed at the top showing the first letter of the first name combined with the first letter of the last name as uppercase initials.
2. **Given** the user has both first and last name available, **When** the avatar renders, **Then** it displays exactly two uppercase letters.
3. **Given** the user has only a first name available, **When** the avatar renders, **Then** it displays the first letter of the first name as a single uppercase initial.
4. **Given** the user is authenticated, **When** the identity card renders, **Then** the user's full name is displayed beside the avatar.

---

### User Story 2 - Navigate to Edit Profile (Priority: P1)

As an authenticated user, I want to tap an "Edit Profile" action so I can navigate to my profile editing page with the correct endpoint for my role.

**Why this priority**: Profile editing is a core account management action and the primary entry point from Settings.

**Independent Test**: Can be fully tested by tapping Edit Profile as Lead and as Customer, confirming correct navigation.

**Acceptance Scenarios**:

1. **Given** the user is a Lead and taps Edit Profile, **When** navigation occurs, **Then** the user is taken to the Lead Profile page.
2. **Given** the user is a Customer and taps Edit Profile, **When** navigation occurs, **Then** the user is taken to the Customer Profile page.
3. **Given** the Edit Profile section is visible, **When** rendered, **Then** it shows a title "Edit Profile" and helper subtitle text.

---

### User Story 3 - Reveal Digital Signature (Priority: P2)

As a Customer, I want to securely view my digital signature by entering my password, so I can access it when needed without it being permanently exposed.

**Why this priority**: Digital signature is sensitive security data requiring careful handling; it is Customer-specific (Leads do not have one).

**Independent Test**: Can be fully tested by tapping the signature field, entering correct/incorrect passwords, observing reveal behavior, and verifying auto-hide after 60 seconds.

**Acceptance Scenarios**:

1. **Given** the user is a Customer, **When** the Settings page renders, **Then** a Digital Signature field is displayed showing masked text (asterisks).
2. **Given** the signature field is showing masked text, **When** the user taps it, **Then** a modal dialog appears requesting password input with a secure text field and show/hide toggle.
3. **Given** the user enters the correct password and submits, **When** the server responds successfully, **Then** the modal closes and the signature field displays the actual signature text inline, which is selectable and copyable.
4. **Given** the signature has been revealed, **When** 60 seconds elapse, **Then** the signature field automatically reverts to masked text and the revealed value is cleared from memory.
5. **Given** the user enters an incorrect password, **When** the server rejects it, **Then** an error message is displayed in the modal without closing it.
6. **Given** the server returns a 403 response, **When** the error is handled, **Then** a message is displayed: "Too many failed attempts. Please try again after 15 minutes."
7. **Given** the signature is revealed, **When** the user copies it to clipboard, **Then** brief visual feedback confirms the copy action succeeded.
8. **Given** the user is a Lead, **When** the Settings page renders, **Then** the Digital Signature section is not displayed.

---

### User Story 4 - Change Password (Priority: P2)

As an authenticated user, I want to change my password from Settings by providing my current password and a new one, so I can keep my account secure.

**Why this priority**: Password management is essential for account security and is a standard settings expectation.

**Independent Test**: Can be fully tested by opening the change password modal, submitting valid/invalid data, and confirming success feedback.

**Acceptance Scenarios**:

1. **Given** the user taps Change Password, **When** the modal opens, **Then** it displays three fields: Current Password, New Password, and Confirm Password, all with show/hide toggles.
2. **Given** the user fills in all fields, **When** validation runs, **Then** the same rules from the Registration flow are enforced: all fields required, new password minimum 8 characters with at least one uppercase letter, one digit, and one special character, and confirm password must match new password.
3. **Given** all validation passes and the user submits, **When** the server responds successfully, **Then** the modal closes and a success feedback message is shown.
4. **Given** the server returns an error, **When** the change fails, **Then** a clear error message is displayed in the modal without closing it.
5. **Given** the change password action is in progress, **When** loading state is active, **Then** the submit button is disabled and repeated taps are prevented.

---

### User Story 5 - Logout (Priority: P2)

As an authenticated user, I want to log out from my current device or all devices, so I can control my active sessions.

**Why this priority**: Session management is fundamental to security and user control.

**Independent Test**: Can be fully tested by triggering both logout actions, confirming API calls and navigation to Login screen.

**Acceptance Scenarios**:

1. **Given** the user taps Logout Current Session, **When** the action completes, **Then** the local session is cleared and the user is navigated to the Login screen without a confirmation dialog.
2. **Given** the user taps Logout All Devices, **When** the action is triggered, **Then** a confirmation dialog is displayed warning that all sessions will be invalidated.
3. **Given** the user confirms Logout All Devices, **When** the action completes, **Then** all server-side sessions are invalidated, the local session is cleared, and the user is navigated to the Login screen.
4. **Given** the user dismisses the Logout All Devices confirmation, **When** the dialog is cancelled, **Then** no logout occurs and the user remains on the Settings page.
3. **Given** a logout action is in progress, **When** loading state is active, **Then** the corresponding action button is disabled and repeated taps are prevented.
4. **Given** a network or server error occurs during logout, **When** the API call fails, **Then** an appropriate error message is displayed.

---

### User Story 6 - Switch Application Language (Priority: P3)

As a user, I want to switch between English and Arabic from Settings so I can use the app in my preferred language.

**Why this priority**: Language preference improves accessibility but is not a security or identity-critical action.

**Independent Test**: Can be fully tested by selecting each language option, confirming the UI updates immediately, and verifying persistence after app restart.

**Acceptance Scenarios**:

1. **Given** the user opens the Language section, **When** the section renders, **Then** English (EN) and Arabic (AR) are displayed as selectable options with the current language indicated.
2. **Given** the user selects a different language, **When** the selection is confirmed, **Then** the app language changes immediately across all visible UI elements.
3. **Given** the user selects a language, **When** the change is applied, **Then** the preference is stored locally and persists across app restarts.

---

### Edge Cases

- User opens Settings while network is offline: all sections render from cached/local data; only actions requiring API calls show appropriate error states.
- Rapid repeated taps on any action button: only one request is sent; subsequent taps are ignored during loading.
- Signature is revealed and user navigates away and returns: signature must be in masked state regardless of previous reveal.
- Change password modal is opened and dismissed: all field values and error states are cleared.
- 403 signature lock occurs: the signature field and modal must reflect the locked state and prevent further attempts until the lock period expires.
- Password in the signature modal is visible (show toggle on): if the user rotates the device or the app loses focus, the field should revert to hidden.
- Logout action completes during a signature reveal: the signature is cleared, the timer is cancelled, and navigation to Login occurs.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Settings page MUST display a profile identity card at the top containing a circular avatar with the user's initials and full name.
- **FR-002**: The avatar MUST show the first letter of the first name and the first letter of the last name as uppercase. If only a first name is available, it MUST show a single initial.
- **FR-003**: The Settings page MUST display an "Edit Profile" section with a title and helper subtitle.
- **FR-004**: Tapping Edit Profile MUST navigate Lead users to the Lead Profile page and Customer users to the Customer Profile page.
- **FR-005**: The Settings page MUST display a Digital Signature section for Customer users only; this section MUST NOT appear for Lead users.
- **FR-006**: The Digital Signature field MUST display masked text (asterisks) by default.
- **FR-007**: Tapping the Digital Signature field MUST open a modal dialog requesting the user's password with a secure text input and show/hide toggle.
- **FR-008**: Upon successful password verification via the signature API, the modal MUST close and the actual signature text MUST replace the masked text inline.
- **FR-009**: The revealed signature text MUST be selectable and copyable with a copy-to-clipboard action that provides visual feedback.
- **FR-010**: The revealed signature MUST automatically revert to masked text after exactly 60 seconds, and the revealed value MUST be cleared from memory.
- **FR-011**: The signature MUST NOT be cached between sessions; password verification is required for every reveal attempt.
- **FR-012**: A wrong password submission for the signature MUST display an error message in the modal without closing it.
- **FR-013**: A 403 response from the signature API MUST display the message: "Too many failed attempts. Please try again after 15 minutes."
- **FR-014**: The Settings page MUST display a Change Password action in the Security section.
- **FR-015**: Tapping Change Password MUST open a modal with three fields: Current Password, New Password, and Confirm Password, each with show/hide toggles.
- **FR-016**: Change Password validation MUST enforce the same rules as the Registration flow: required fields, minimum 8 characters, at least one uppercase letter, one digit, one special character (!@#$%^&*), and confirm password must match.
- **FR-017**: Successful password change MUST close the modal and display success feedback to the user.
- **FR-018**: The Settings page MUST display a Logout Current Session action.
- **FR-019**: Tapping Logout Current Session MUST call the logout API, clear the local session, and navigate to the Login screen without a confirmation dialog.
- **FR-020**: The Settings page MUST display a Logout All Devices action.
- **FR-021**: Tapping Logout All Devices MUST display a confirmation dialog. Upon user confirmation, it MUST call the logout-all API, clear the local session, and navigate to the Login screen.
- **FR-022**: The Settings page MUST display a Language section with English (EN) and Arabic (AR) as selectable options.
- **FR-023**: Selecting a language MUST immediately change the app language and persist the choice locally.
- **FR-024**: All Settings page sections MUST use the existing design system tokens for colors, typography, and spacing.
- **FR-025**: All password fields across the Settings page MUST include a show/hide visibility toggle.
- **FR-026**: All action buttons MUST be disabled during loading states to prevent repeated rapid requests.
- **FR-027**: Navigation after any logout action MUST always go to the Login screen.
- **FR-028**: The revealed signature MUST have a smooth visual transition when showing and hiding.
- **FR-029**: The Settings page MUST support both LTR and RTL directionality for Arabic language.

### State Handling Requirements

- **SH-001**: Signature reveal state MUST be tracked as hidden, revealed, or locked (after 403).
- **SH-002**: The signature auto-hide timer MUST be cancelled and the revealed value cleared when the user navigates away from the Settings page, when the signature section exits the widget tree, or when a logout occurs.
- **SH-003**: Each action (signature reveal, change password, logout) MUST manage its own loading, success, and error states independently.
- **SH-004**: Loading states MUST disable all action buttons and show a progress indicator on the active action only.
- **SH-005**: Error states MUST be clearly displayed near the relevant action and MUST be dismissible or auto-cleared on retry.
- **SH-006**: Modal form state (field values, validation errors) MUST be cleared when the modal is dismissed.
- **SH-007**: Password show/hide toggle state MUST revert to hidden when the modal is closed.

### Component Breakdown

- **CB-001**: Profile identity card with circular avatar (initials) and full name.
- **CB-002**: Edit Profile section card with title, subtitle, and navigation action.
- **CB-003**: Digital Signature section card with masked/revealed text, tap-to-reveal behavior, and copy-to-clipboard action.
- **CB-004**: Signature password modal dialog with secure input, show/hide toggle, and error display.
- **CB-005**: Change Password modal dialog with three password fields, validation rules display, and error display.
- **CB-006**: Security actions section containing Change Password, Logout Current Session, and Logout All Devices.
- **CB-006a**: Logout All Devices confirmation dialog with confirm and cancel actions.
- **CB-007**: Language selection section with radio-style options for EN and AR.
- **CB-008**: Settings page scaffold that assembles all sections and manages role-based visibility.

### Key Entities *(include if feature involves data)*

- **Settings User Identity**: User's first name, last name, and role, used to render the avatar initials card.
- **Signature Reveal State**: Represents whether the signature is hidden, revealed with a countdown, or locked due to rate limiting.
- **Change Password Form Model**: Holds current password, new password, and confirm password field values along with validation error state.
- **Logout Action State**: Tracks loading and error state for both current-session and all-device logout actions.

### Assumptions

- The user does not have a profile image URL in the current data model; the avatar will display initials only until image support is added in a future iteration.
- The Change Password API (`POST /api/Auth/change-password`) accepts current password, new password, and confirm password in the request body, distinct from the existing OTP-based reset-password flow.
- The Digital Signature reveal API (`POST /api/customer-portal/my/digital-signature`) accepts the user's current password and returns the signature string on success.
- The logout APIs (`POST /api/customer-portal/logout` and `POST /api/customer-portal/logout-all`) do not require a request body beyond the authorization token.
- The existing `LocaleCubit` and `LocaleRepository` infrastructure will be reused for language selection.
- The existing `SessionCubit.logout()` method will be extended or wrapped to support the new logout API calls.
- The existing `Validators` utility class will be reused for password validation rules.
- "Edit Profile" navigates to the already-existing Lead Profile page or Customer Profile page; no new profile editing page is created in this feature.
- The signature modal from registration (`DigitalSignatureModal`) is a display-only widget; the new signature reveal flow requires a distinct password-input modal.
- After a 403 lock on the signature endpoint, the lock duration is determined server-side; the client displays the server's error message and prevents further attempts until the user retries after the indicated period.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of authenticated users (Lead and Customer) can open the Settings page and see their identity card with correct avatar initials and full name.
- **SC-002**: At least 95% of Edit Profile taps navigate to the correct profile page based on the user's role.
- **SC-003**: 100% of successful signature password submissions reveal the actual signature within 3 seconds.
- **SC-004**: 100% of revealed signatures automatically revert to masked text within 60 seconds +/- 2 seconds.
- **SC-005**: 100% of 403 responses on the signature endpoint display the lock message and prevent further attempts.
- **SC-006**: At least 95% of valid change password submissions complete within 3 seconds and show success feedback.
- **SC-007**: 100% of change password attempts with invalid input display inline validation errors before submission.
- **SC-008**: 100% of successful logout actions (current device or all devices) clear the session and navigate to the Login screen.
- **SC-009**: Language selection changes take effect immediately across all visible UI without requiring app restart.
- **SC-010**: Language preference persists and is restored correctly after app restart in at least 99% of cases.
- **SC-011**: No layout overflow or directionality issues occur across both LTR (English) and RTL (Arabic) layouts.
- **SC-012**: All action buttons are disabled during loading, preventing duplicate requests in at least 99% of rapid-tap scenarios.
