# Feature Specification: Customer Offers Flow

**Feature Branch**: `033-add-offers-flow`  
**Created**: 2026-04-23  
**Status**: Draft  
**Input**: User description: "Build a complete customer offers flow with Offer Details, Accept Offer, and Reject Offer screens, including API-backed details, validations, localization, RTL support, and strict theme consistency."

## Clarifications

### Session 2026-04-23

- Q: To remove ambiguity in the acceptance payload, which payment method should be sent for this release? → A: Add payment method selection on Accept Offer screen.
- Q: For the selected payment method flow, what should happen after a successful accept response? → A: COD: show success and go to offers list; Online: open checkout URL directly.
- Q: If Online accept succeeds but no usable checkout URL is returned, what should the app do? → A: Show recoverable error, stay on Accept screen, allow retry or payment-method change.
- Q: After a successful Reject Offer submission, where should the app navigate? → A: Return to Offer Details for the same offer, refreshed with Rejected status.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review Offer Details (Priority: P1)

As a customer, I can open a full offer details screen from an offer card, so I can review pricing, services, locations, terms, and attachment before making a legally binding decision.

**Why this priority**: The customer must understand what they are accepting or rejecting; all downstream actions depend on this review experience.

**Independent Test**: Open an offer from the offers list, verify all sections render from offer details data, verify location rendering logic for one location and for origin-destination flow, and verify attachment download feedback.

**Acceptance Scenarios**:

1. **Given** a customer taps an offer card, **When** the details screen opens, **Then** the screen loads data for the tapped offer identifier and shows an app bar title with offer number and a status badge using the same status-color mapping as the offers list.
2. **Given** offer details include multiple service types, **When** service type section renders, **Then** each type appears as a chip and chips wrap across lines without clipping.
3. **Given** offer details include one location only, **When** locations section renders, **Then** exactly one location card is shown without connector arrows.
4. **Given** offer details include origin and destination, **When** locations section renders, **Then** cards are ordered Origin then Destination and visually connected as a vertical movement flow.
5. **Given** any location has an unknown or missing type, **When** its card title is rendered, **Then** the title falls back to Location.
6. **Given** service line items contain mixed optional fields, **When** item cards render, **Then** null fields are hidden and small-value fields are shown in a two-column layout.
7. **Given** an offer includes an attachment URL, **When** the customer taps download, **Then** the file is saved locally and user feedback confirms success or failure.

---

### User Story 2 - Accept Offer with Signature (Priority: P1)

As a customer, I can review a short summary, enter my digital signature, and confirm acceptance, so I can complete the legal acceptance flow with clear intent.

**Why this priority**: Acceptance is a high-value business action and must be validated, explicit, and safe.

**Independent Test**: Open accept flow from offer details, select payment method, submit with valid signature and checked confirmation, verify COD success returns to offers list and Online success opens checkout URL directly; validate required-field and invalid-signature behavior.

**Acceptance Scenarios**:

1. **Given** the customer opens the accept screen, **When** the page renders, **Then** it shows review header text, offer summary (offer number, company, total), payment method selection, signature input, confirmation checkbox, and primary/secondary actions.
2. **Given** signature is empty or does not start with SIG-, **When** customer submits, **Then** submission is blocked and an toast validation message is shown.
3. **Given** payment method is not selected, **When** customer submits, **Then** submission is blocked and a validation message is shown.
4. **Given** confirmation checkbox is not selected, **When** customer submits, **Then** submission is blocked and an toast validation message is shown.
5. **Given** valid COD payment method, valid signature, and confirmation, **When** customer submits acceptance, **Then** acceptance request is sent for the selected offer with COD and success feedback is shown before navigating to offers list.
6. **Given** valid Online payment method, valid signature, and confirmation, **When** customer submits acceptance, **Then** acceptance request is sent for the selected offer with Online and the returned checkout URL is opened directly.
7. **Given** customer taps Review Full Agreement, **When** action executes, **Then** user is returned to the offer details screen without data loss.
8. **Given** Online acceptance succeeds but checkout URL is missing or invalid, **When** response is handled, **Then** a recoverable error is shown and user remains on Accept screen with ability to retry submission or change payment method.
9. **Given** acceptance request fails, **When** failure is returned, **Then** the screen shows localized feedback using the same field/server/network failure handling pattern used in registration flows.

---

### User Story 3 - Reject Offer with Reason (Priority: P2)

As a customer, I can reject an offer with a required reason, so the company receives clear feedback and the offer reaches a terminal state intentionally.

**Why this priority**: Rejection is a critical alternative path and needs explicit user confirmation and traceable reason capture.

**Independent Test**: Open reject flow, verify warning summary, enforce required reason with max length, submit rejection successfully, verify navigation returns to the same offer details refreshed as Rejected, and verify cancel returns to previous screen.

**Acceptance Scenarios**:

1. **Given** the customer opens reject flow, **When** page renders, **Then** it shows warning header, reject-confirmation text, and summary card with offer number, status, company, and total.
2. **Given** rejection reason is empty, **When** customer submits, **Then** submission is blocked and a required validation message is shown.
3. **Given** rejection reason exceeds 2000 characters, **When** customer attempts submit, **Then** submission is blocked and length validation feedback is shown.
4. **Given** a valid reason, **When** customer submits, **Then** rejection request is sent for the selected offer and success feedback is shown before navigating to the same offer details refreshed with Rejected status.
5. **Given** customer taps Cancel, **When** action executes, **Then** user returns to the previous screen without sending a rejection request.

---

### Edge Cases

- Offer totals or discounts are negative values and must still be displayed with clear numeric sign formatting.
- Destination location is missing while origin exists.
- Locations array is empty or contains unknown location types.
- Location fields (street, city, country, floor, elevator) are partially missing.
- Service line item details contain long text values that might overflow narrow screens.
- Service line item details include unsupported or unexpected keys; known fields are shown and unknown values do not break rendering.
- Offer status value is unknown; badge remains visible with a neutral fallback style.
- Attachment metadata is missing (name or size) while download URL exists.
- Customer enters malformed signature text (wrong prefix, whitespace-only, or mixed-direction text).
- API returns terminal-state errors when user attempts accept or reject on already finalized offers.
- Network failures occur during details load, accept, reject, or download actions.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST open Offer Details when a customer taps an offer card and MUST load details using the selected offer identifier.
- **FR-002**: System MUST display Offer Details app bar with back action, offer number title, and status badge using the same status-color mapping rules as the offers listing experience.
- **FR-003**: System MUST present service types as one or more chips in wrapping layout; plain text-only rendering is not allowed.
- **FR-004**: System MUST render a total amount card that displays total amount value, EGP currency indicator, and VAT Included / Insurance Covered badges when corresponding data indicates they apply.
- **FR-005**: System MUST render an applied savings card showing discount amount.
- **FR-006**: System MUST render locations from API-provided locationType values and MUST NOT hardcode From/To labels.
- **FR-007**: System MUST sort displayed locations so Origin appears before Destination.
- **FR-008**: System MUST render one location card without connector flow when only one location is present.
- **FR-009**: System MUST render a vertical connected flow (Origin card, connector, Destination card) when both Origin and Destination are present.
- **FR-010**: System MUST label unknown or missing locationType values as Location.
- **FR-011**: System MUST render location cards with icon, title, address details (street, city, country), floor, and elevator value as Yes/No when available.
- **FR-012**: System MUST render itemized service cards for all service line items and show service type plus line total in each card header.
- **FR-013**: System MUST display supported service-detail fields (cleaningType, durationHours, numberOfStaff, fillNailHoles, withHighPressureCleaner, cleaningDate, cleaningStartTime, deliveryDate, deliveryTime, discount) when present.
- **FR-014**: System MUST hide null or empty service-detail fields and MUST use a two-column arrangement for compact scalar fields.
- **FR-015**: System MUST render Insurance and Included in Price sections using distinct visual containers and API-provided text content.
- **FR-016**: System MUST render an attachment row for offer PDF including file name, size, and a download action when attachment data is available.
- **FR-017**: System MUST reuse the same file-saving behavior and user-feedback pattern already used for digital signature download flows.
- **FR-018**: System MUST provide Accept Offer and Reject Offer actions from Offer Details.
- **FR-019**: System MUST provide an Accept Offer screen containing review header, offer summary, payment method selection (COD or Online), digital signature input, confirmation checkbox text, and primary/secondary actions.
- **FR-020**: System MUST validate digital signature as required and MUST enforce prefix SIG- before allowing acceptance submission.
- **FR-021**: System MUST require customer confirmation checkbox selection before allowing acceptance submission.
- **FR-022**: System MUST submit offer acceptance through the customer offer acceptance contract for the selected offer using all required payload values.
- **FR-023**: System MUST require payment method selection before acceptance submission and MUST send the selected method in the acceptance payload.
- **FR-023a**: System MUST handle successful COD acceptance by showing success feedback and navigating to offers list.
- **FR-023b**: System MUST handle successful Online acceptance by opening the checkout URL returned by the acceptance contract.
- **FR-023c**: System MUST treat missing or invalid checkout URL in successful Online acceptance response as a recoverable error state that keeps user on Accept screen and allows retry or payment-method change.
- **FR-024**: System MUST return to Offer Details when customer selects Review Full Agreement from Accept Offer.
- **FR-025**: System MUST provide a Reject Offer screen with warning presentation, summary card, rejection reason textarea, and submit/cancel actions.
- **FR-026**: System MUST enforce rejection reason as required with maximum length 2000 characters.
- **FR-027**: System MUST submit rejection through the customer offer rejection contract for the selected offer with the required rejection reason payload.
- **FR-027a**: System MUST navigate to the same Offer Details after successful rejection and refresh it to display Rejected status and updated actions state.
- **FR-028**: System MUST return to previous context when customer selects cancel on Reject Offer.
- **FR-029**: System MUST handle API failures for details, accept, and reject using the existing categorized error pattern (field, server, network) used by registration flows, including localized user-visible feedback and retry-safe state transitions.
- **FR-030**: System MUST localize all user-visible text; hardcoded UI strings are not allowed.
- **FR-031**: System MUST support right-to-left layouts for all three screens including cards, badges, chips, connectors, and action rows.
- **FR-032**: System MUST follow existing app visual tokens and spacing/typography/color system without introducing a redesigned style.
- **FR-033**: System MUST keep long text readable through wrapping or truncation strategies that preserve core information and action accessibility.

### Key Entities *(include if feature involves data)*

- **Customer Offer Details**: Full offer view model containing offer identity, company information, status, totals, discount, insurance text, included-in-price text, VAT flag, attachment URL/metadata, locations, and service line items.
- **Offer Location**: Location entry with type, address index, street, city, country, floor, and elevator indicator used for ordered movement flow rendering.
- **Offer Service Line Item**: Service entry containing service type, total line price, and dynamic service-details data with optional fields.
- **Offer Acceptance Submission**: Customer acceptance payload containing selected payment method and digital signature for a specific offer.
- **Offer Rejection Submission**: Customer rejection payload containing required free-text rejection reason for a specific offer.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of offer-card taps open the matching offer details screen for the selected offer identifier.
- **SC-002**: In at least 95% of normal mobile sessions, offer details content is visible within 2 seconds after opening the details screen.
- **SC-003**: 100% of validation tests block accept submission when payment method is not selected, signature is missing/invalid, or confirmation checkbox is not selected.
- **SC-004**: 100% of validation tests block reject submission when rejection reason is missing or longer than 2000 characters.
- **SC-005**: 100% of successful COD accept submissions show success feedback and navigate users to offers list.
- **SC-005a**: 100% of successful Online accept submissions open the returned checkout URL directly.
- **SC-005b**: 100% of Online acceptance responses without usable checkout URL keep user on Accept screen with recoverable error feedback and available retry path.
- **SC-006**: 100% of successful reject submissions show success feedback and navigate to the same offer details refreshed with Rejected status.
- **SC-007**: 100% of tested RTL scenarios preserve readable layout and correct visual ordering across details, accept, and reject screens.
- **SC-008**: In usability testing of the flow, at least 90% of customers can complete either accept or reject action without external assistance on first attempt.

## Assumptions

- Offer details response contains enough information to derive display-ready file name and size for attachment row; when metadata is missing, graceful placeholders are acceptable.
- Accept Offer supports explicit customer selection between COD and Online payment methods and forwards the selected value to the acceptance contract.
- Existing offers status-to-color mapping, toasts, and section-level loading/error patterns are available for reuse.
- Existing localization infrastructure already supports adding all new strings for both left-to-right and right-to-left languages.
- Offer location data will be one location or an origin/destination pair in normal operation; unexpected extra entries are rendered safely without blocking the screen.
- Online acceptance responses may occasionally omit a usable checkout URL, and this case is handled as a recoverable client error.
