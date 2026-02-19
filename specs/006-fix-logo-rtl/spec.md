# Feature Specification: Fix Logo RTL Alignment

**Feature Branch**: `006-fix-logo-rtl`  
**Created**: 2026-02-19  
**Status**: Draft  
**Input**: User description: "Update onboarding layout to ensure WaslaLogo remains visually fixed (LTR-aligned) regardless of app language direction. When switching to Arabic (RTL), only textual content should mirror. Branding elements such as WaslaLogo must remain in their original left-aligned position per Figma design. This must not break RTL behavior for other UI components."

## Clarifications

### Session 2026-02-19

- Q: Should the Wasla logo group move from its current centered position to left-aligned, or stay centered and simply not mirror in RTL? → A: Stay centered — keep the current centered position, just ensure internal content doesn't flip in RTL.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Logo Stays LTR-Aligned in RTL Mode (Priority: P1)

As a user viewing the onboarding page in Arabic (RTL), I see the Wasla logo (red circle with "W" and the "ASLA" text) remain centered on the screen — exactly as it appears in the English (LTR) layout. The logo does not mirror, flip, or reorder when the app language changes to Arabic.

**Why this priority**: Brand consistency is the core purpose of this feature. The Wasla logo is the primary branding element and must appear in a fixed, predictable position regardless of language direction, per the Figma design. If this fails, the entire feature fails.

**Independent Test**: Can be fully tested by switching the app language to Arabic on the onboarding page and visually confirming the logo remains in its LTR-aligned position. Delivers brand consistency independently.

**Acceptance Scenarios**:

1. **Given** the app is displaying in English (LTR), **When** the user views the onboarding page, **Then** the Wasla logo group (red circle "W" + "ASLA" text) appears centered on the screen.
2. **Given** the app is displaying in English (LTR), **When** the user switches the language to Arabic (RTL), **Then** the Wasla logo group remains centered in the exact same screen position — it does not mirror or reorder.
3. **Given** the app is displaying in Arabic (RTL), **When** the user views the onboarding page, **Then** the internal reading order of the logo group is always left-to-right: red circle "W" on the left, "ASLA" text on the right.
4. **Given** the app is displaying in Arabic (RTL), **When** the user switches the language back to English (LTR), **Then** the logo remains in its designed position with no visual change or flicker.

---

### User Story 2 - Textual Content Properly Mirrors in RTL (Priority: P2)

As a user viewing the onboarding page in Arabic, I see all textual UI elements (buttons, labels, and interactive controls) properly mirror according to RTL conventions. The "Log In" and "New User" buttons display Arabic text and respect RTL alignment. The header elements (language selector and support icon) swap sides as expected in RTL. Only the Wasla logo is exempt from mirroring.

**Why this priority**: Correct RTL behavior for all non-branding elements is essential for Arabic-speaking users to have a natural, usable experience. This must work alongside the logo fix — if RTL mirroring breaks for regular content, the feature is incomplete.

**Independent Test**: Can be fully tested by switching the app to Arabic and verifying that button text, header layout, and other textual elements follow standard RTL conventions while the logo stays fixed.

**Acceptance Scenarios**:

1. **Given** the app is displaying in Arabic (RTL), **When** the user views the onboarding page header, **Then** the language selector and support icon follow standard RTL positioning (language selector on the right, support icon on the left).
2. **Given** the app is displaying in Arabic (RTL), **When** the user views the "Log In" and "New User" buttons, **Then** the button text is displayed in Arabic with proper RTL text alignment.
3. **Given** the app is displaying in Arabic (RTL), **When** the user views any directional padding or margins on text elements, **Then** start/end spacing mirrors correctly per RTL conventions.
4. **Given** the app is switched from English to Arabic, **When** all non-branding text elements update, **Then** no existing RTL behavior in the header, buttons, or other UI components is broken.

---

### Edge Cases

- What happens when the user rapidly toggles between English and Arabic? The logo must remain stable in its LTR position with no visual jitter, flicker, or momentary misplacement during language transitions.
- What happens on devices with very small screens where the logo might be clipped? The logo should scale down proportionally while maintaining its LTR-aligned position.
- What happens if additional branding elements are added in the future (e.g., a tagline)? The fix should establish a pattern where branding elements can be easily kept in LTR alignment without ad-hoc overrides.
- What happens if the system locale is Arabic but the app language is English? The logo position must depend on the app's language direction, not the system locale — and it must remain LTR-aligned in both cases.

## Assumptions

- The Wasla logo group stays in its current centered position on the onboarding page. This feature ensures the internal content order ("W" circle then "ASLA" text) does not flip or mirror in RTL mode.
- "LTR-aligned" in this context refers to the internal reading order of the logo group (left-to-right: circle then text), not the logo's position on screen.
- The internal reading order of the logo group ("W" circle on left, "ASLA" text on right) is already correctly handled and should be preserved.
- Only the onboarding page is in scope. Other screens that may display the Wasla logo or branding are not affected by this change.
- The header row (language selector + support icon) should continue to mirror in RTL as it currently does — this is correct behavior for interactive UI controls.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Wasla logo group (red circle with "W" + "ASLA" text) MUST remain centered on the onboarding page and its internal content order MUST NOT mirror or flip regardless of the app's current language direction.
- **FR-002**: The internal content order of the Wasla logo group MUST always read left-to-right: the red "W" circle on the left, followed by the "ASLA" text on the right, in both LTR and RTL modes.
- **FR-003**: All non-branding textual content on the onboarding page (button labels, header controls, directional spacing) MUST continue to mirror correctly when the app is in RTL mode.
- **FR-004**: The language selector and support icon in the onboarding header MUST continue to swap positions according to standard RTL layout rules.
- **FR-005**: Switching between English and Arabic MUST NOT cause the logo to visually shift, flicker, or temporarily appear in a mirrored position.
- **FR-006**: The logo alignment fix MUST NOT introduce regressions to RTL behavior on any other UI component within the onboarding page or elsewhere in the app.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The Wasla logo group remains centered and its internal content order ("W" circle on left, "ASLA" text on right) is identical in both English (LTR) and Arabic (RTL) modes — verified by visual comparison showing zero layout difference.
- **SC-002**: 100% of non-branding text elements on the onboarding page correctly mirror when switching to Arabic.
- **SC-003**: Language switching between English and Arabic on the onboarding page completes with no visible logo movement or flicker — the logo appears stationary throughout the transition.
- **SC-004**: All existing acceptance scenarios from the original onboarding spec (001-app-onboarding) continue to pass after this change.
