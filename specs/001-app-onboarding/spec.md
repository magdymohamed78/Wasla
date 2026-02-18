# Feature Specification: App Onboarding

**Feature Branch**: `001-app-onboarding`  
**Created**: 2026-02-17  
**Status**: Draft  
**Input**: User description: "Implement a new onboarding feature for the Wasla app including an animated Splash Screen and a multilingual Onboarding Page."

## Clarifications

### Session 2026-02-17

- Q: Does the language selection on the onboarding page apply to the entire app (all screens), or only to the onboarding page itself? → A: App-wide — language applies to all current and future screens globally.
- Q: What should happen when the user taps the globe icon? → A: Dropdown menu — tapping the globe opens a small dropdown listing "English" and "العربية" for the user to select from.
- Q: Should the splash screen animation be redesigned from scratch per the spec, or evolve the existing scale-in animation? → A: Redesign from scratch — implement the drop-down animation as specified, replace the existing splash screen entirely.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Animated Splash Screen Experience (Priority: P1)

As a user launching the Wasla app for the first time (or any subsequent time), I see a branded animated splash screen that introduces the Wasla identity before transitioning to the onboarding page.

The splash screen plays through the following animation sequence:
1. A red circular logo drops down onto the screen with a smooth settling animation.
2. Once the circle settles, the letter "W" fades in inside the circle.
3. The remaining app name "ASLA" slides in from the right, appearing next to the logo.
4. A loading indicator with three animated dots appears below the logo area, signaling the app is preparing.
5. The entire splash screen remains visible for a total of 2 seconds.
6. After the 2-second duration, the app automatically navigates to the Onboarding page with a smooth transition.

**Why this priority**: The splash screen is the very first impression users have of the app. It establishes brand identity and provides visual feedback during app initialization. Without it, the app feels unpolished and unprofessional—critical for a graduation project demo.

**Independent Test**: Can be fully tested by launching the app and observing the complete animation sequence. Delivers brand identity value and a polished first impression independently of any other feature.

**Acceptance Scenarios**:

1. **Given** the user launches the app, **When** the app starts, **Then** a red circular logo animates downward onto the screen with a smooth drop-and-settle motion.
2. **Given** the red circle has settled on screen, **When** the settle animation completes, **Then** the letter "W" fades in at the center of the circle.
3. **Given** the "W" is visible inside the circle, **When** the "W" animation completes, **Then** the text "ASLA" slides in from the right and appears next to the logo to form "WASLA".
4. **Given** the full logo and name are visible, **When** the name animation completes, **Then** a loading indicator with three animated dots appears below the logo area.
5. **Given** the splash screen is fully visible with all elements, **When** a total of 2 seconds have elapsed since app launch, **Then** the app navigates to the Onboarding page with a smooth fade transition.
6. **Given** the user has a slow device, **When** the splash screen plays, **Then** the animation sequence remains smooth without frame drops or visual glitches.

---

### User Story 2 - Multilingual Onboarding Page (Priority: P2)

As a user arriving at the onboarding page (after the splash screen), I see a clean, branded welcome page with the Wasla logo centered, a "Log In" primary button, and a "New User" secondary button. I can switch the app language between English and Arabic, and my language choice is remembered across app restarts.

At the top-left of the onboarding page, a globe icon serves as the language selector. Tapping it allows me to switch between English and Arabic. When I switch languages, all visible text on the page updates immediately without a page reload or navigation. The selected language persists so that next time I open the app, it opens in my preferred language.

**Why this priority**: The onboarding page is the gateway to the app's core functionality (login/registration). Multilingual support is essential for a regional app targeting both English and Arabic speakers. This story delivers the complete first-time user experience and is the foundation for all subsequent user flows.

**Independent Test**: Can be fully tested by navigating to the onboarding page and verifying layout, button presence, language switching, and language persistence across app restarts. Delivers a complete welcome experience independently.

**Acceptance Scenarios**:

1. **Given** the splash screen has completed, **When** the onboarding page loads, **Then** the Wasla logo appears centered on the page.
2. **Given** the onboarding page is displayed, **When** the user views the page, **Then** a primary "Log In" button is visible below the logo.
3. **Given** the onboarding page is displayed, **When** the user views below the "Log In" button, **Then** a secondary "New User" button is visible.
4. **Given** the onboarding page is displayed, **When** the user looks at the top-left corner, **Then** a globe icon (language selector) is visible.
5. **Given** the app is displaying in English, **When** the user taps the globe icon, **Then** a dropdown menu appears listing "English" and "العربية".
6. **Given** the dropdown menu is visible, **When** the user selects "العربية", **Then** all visible text across the app updates to Arabic immediately and the dropdown closes.
7. **Given** the app is displaying in Arabic, **When** the user taps the globe icon and selects "English" from the dropdown, **Then** all visible text across the app updates to English immediately and the dropdown closes.
8. **Given** the user has selected Arabic as their language, **When** the user closes and reopens the app, **Then** the app displays in Arabic.
9. **Given** the app is displaying in Arabic, **When** the user views the layout, **Then** the text direction is right-to-left (RTL) and the layout mirrors appropriately.

---

### User Story 3 - Support Access from Onboarding (Priority: P3)

As a user on the onboarding page, I can tap a support/help icon at the top-right corner to navigate to a Support page where I can find help or contact information.

**Why this priority**: Support access is important for user confidence, especially for new users who may need help. However, it is lower priority because the core onboarding flow (splash → welcome → login/register) must work first.

**Independent Test**: Can be fully tested by tapping the support icon on the onboarding page and verifying navigation to a Support page. Delivers help accessibility independently.

**Acceptance Scenarios**:

1. **Given** the onboarding page is displayed, **When** the user looks at the top-right corner, **Then** a support/help icon is visible.
2. **Given** the support icon is visible, **When** the user taps the support icon, **Then** the app navigates to the Support page.
3. **Given** the user is on the Support page, **When** the user views the page, **Then** relevant help or contact information is displayed.
4. **Given** the user is on the Support page, **When** the user navigates back, **Then** the app returns to the Onboarding page with its previous state intact (including language selection).

---

### Edge Cases

- What happens when the user backgrounds the app during the splash screen animation? The animation should pause and resume or skip to the onboarding page when the app returns to the foreground.
- What happens when the device language is set to Arabic but the user has previously selected English in the app? The app-level language preference takes precedence over the device language.
- What happens when the user rapidly taps the language selector multiple times? The app should handle rapid language switches gracefully without UI glitches or crashes.
- What happens if persisted language data is corrupted or missing? The app defaults to English.
- What happens on first launch when no language preference has been set? The app defaults to English.
- What happens if the splash screen animation cannot complete (e.g., system interruption)? The app should still navigate to the onboarding page after the 2-second timeout.
- What happens when the "Log In" or "New User" buttons are tapped? They should navigate to their respective screens (Login and Registration). Note: The actual Login and Registration screens are outside the scope of this feature—only the navigation trigger is in scope.

## Requirements *(mandatory)*

### Functional Requirements

**Splash Screen**:

- **FR-001**: The app MUST display an animated splash screen on every app launch.
- **FR-002**: The splash screen MUST show a red circular logo that animates downward with a smooth drop-and-settle motion.
- **FR-003**: The letter "W" MUST fade in at the center of the red circle after the circle settles.
- **FR-004**: The text "ASLA" MUST slide in from the right next to the logo after the "W" appears.
- **FR-005**: A loading indicator with three animated dots MUST appear below the logo area after the name is fully visible.
- **FR-006**: The splash screen MUST remain visible for a total of 2 seconds from app launch.
- **FR-007**: The app MUST automatically navigate from the splash screen to the Onboarding page after the 2-second duration.
- **FR-008**: The transition from splash screen to onboarding page MUST use a smooth fade animation.

**Onboarding Page**:

- **FR-009**: The onboarding page MUST display the Wasla logo centered on the screen.
- **FR-010**: The onboarding page MUST display a primary "Log In" button below the logo.
- **FR-011**: The onboarding page MUST display a secondary "New User" button below the "Log In" button.
- **FR-012**: The onboarding page MUST display a globe icon (language selector) at the top-left corner.
- **FR-013**: The onboarding page MUST display a support/help icon at the top-right corner.

**Multilingual Support**:

- **FR-014**: The app MUST support English and Arabic as available languages.
- **FR-015**: Tapping the language selector MUST open a dropdown menu listing "English" and "العربية" as options. Selecting an option MUST switch the app language and close the dropdown.
- **FR-016**: Changing the language MUST update all visible text across the entire app immediately without navigation or page reload. The language setting is app-wide and applies to all current and future screens.
- **FR-017**: The selected language MUST persist across app restarts and apply globally on subsequent launches.
- **FR-018**: The app MUST default to English when no language preference has been previously set.
- **FR-019**: When Arabic is selected, the layout MUST switch to right-to-left (RTL) text direction.

**Navigation**:

- **FR-020**: Tapping the support/help icon MUST navigate the user to a Support page.
- **FR-021**: Tapping the "Log In" button MUST navigate the user to the Login screen.
- **FR-022**: Tapping the "New User" button MUST navigate the user to the Registration screen.

### Key Entities

- **Language Preference**: Represents the user's selected app language. Attributes: language code (e.g., "en", "ar"), persistence status. Stored locally on the device.
- **Onboarding State**: Represents whether the user has seen the onboarding flow. Attributes: has_seen_onboarding (boolean). May be used in future to skip onboarding on subsequent launches.

## Assumptions

- The Wasla brand color for the logo circle is red (#E6212B) as seen in the existing splash screen code.
- The Login and Registration screens are outside the scope of this feature. This spec only covers the navigation trigger (button tap) to those screens.
- The Support page content is a simple informational page. Its detailed content and design are outside the scope of this feature—this spec only covers navigation to it and basic content display.
- The language selector presents a simple two-option choice (English / Arabic). No language search or complex picker is needed for two languages.
- The splash screen 2-second duration is measured from the moment the splash screen becomes visible, not from cold boot start.
- Animation frame rate should target 60fps on mid-range devices.
- The existing `lib/splash_screen.dart` will be replaced entirely with a new implementation matching this spec. The current scale-in animation and navigation to HomeScreen will be superseded by the drop-down animation and navigation to the Onboarding page.

## Scope Boundaries

**In Scope**:
- Splash screen with animated logo sequence
- Onboarding welcome page with logo, buttons, and icons
- Language switching between English and Arabic
- Language persistence across app restarts
- RTL layout support for Arabic
- Navigation triggers to Login, Registration, and Support pages

**Out of Scope**:
- Login screen implementation
- Registration screen implementation
- Support page detailed content and design
- Additional languages beyond English and Arabic
- Onboarding skip logic for returning users (future enhancement)
- Backend integration or API calls
- Push notifications or analytics tracking

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The splash screen animation completes its full sequence (circle → W → ASLA → dots) within 2 seconds on all supported devices.
- **SC-002**: 100% of visible text on the onboarding page updates to the selected language within 1 second of language change.
- **SC-003**: The user's language preference persists correctly across 100% of app restarts.
- **SC-004**: The onboarding page layout matches the Figma design with zero visual deviation in spacing, typography, and color when reviewed side-by-side.
- **SC-005**: All navigation actions (Support, Log In, New User) respond within 0.5 seconds of user tap.
- **SC-006**: The splash screen animation runs at a consistent frame rate without visible stutter on mid-range devices.
- **SC-007**: Arabic RTL layout mirrors correctly with no overlapping elements or misaligned text.
- **SC-008**: The complete flow (splash → onboarding → any button action) can be completed by a first-time user without confusion or assistance.
