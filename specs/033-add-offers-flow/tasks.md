# Tasks: Customer Offers Flow

**Input**: Design documents from `/specs/033-add-offers-flow/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/ ✅

**Tests**: Not requested in feature specification. Test tasks are omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Mobile (Flutter)**: `lib/features/offers/`, `lib/core/`
- Localization: `lib/core/localization/l10n/app_en.arb` and `app_ar.arb`
- Routing: `lib/core/routing/app_router.dart`
- DI: `lib/app.dart`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add new dependency, create domain entities and data models shared across all user stories

- [x] T001 Add `url_launcher: ^6.2.0` dependency to `pubspec.yaml` and run `flutter pub get`
- [x] T002 [P] Create `PaymentMethod` enum in `lib/features/offers/domain/entities/payment_method.dart` with values `cod(0)` and `online(1)`, including `toApiValue()` and `fromApiValue(int)` helpers
- [x] T003 [P] Create `OfferLocation` domain entity in `lib/features/offers/domain/entities/offer_location.dart` with all fields from data-model.md (locationType, addressIndex, street, zipCode, city, countryCode, buildingType, floor, hasLift) and computed properties (`displayTitle`, `formattedAddress`)
- [x] T004 [P] Create `AdditionalCostSummary` domain entity in `lib/features/offers/domain/entities/additional_cost_summary.dart` with fields: description (nullable String), price (double)
- [x] T005 [P] Create `OfferServiceLineItem` domain entity in `lib/features/offers/domain/entities/offer_service_line_item.dart` with fields from data-model.md (serviceType, totalLinePrice, serviceDetails as `Map<String, dynamic>?`, additionalCosts as `List<AdditionalCostSummary>`)
- [x] T006 Create `OfferDetails` domain entity in `lib/features/offers/domain/entities/offer_details.dart` with all fields from data-model.md and computed properties (hasDiscount, isAccepted, isRejected, isPending, canAccept, canReject, hasAttachment, originLocation, destinationLocation, hasMultipleLocations). Depends on T003, T004, T005

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Data layer DTOs, remote data source, repository interface & implementation, use cases, and DI wiring that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T007 [P] Create `OfferLocationSummaryDto` model in `lib/features/offers/data/models/offer_location_summary_dto.dart` with `fromJson` factory and `toDomain()` mapping to `OfferLocation` entity
- [x] T008 [P] Create `AdditionalCostSummaryDto` model in `lib/features/offers/data/models/additional_cost_summary_dto.dart` with `fromJson` factory and `toDomain()` mapping to `AdditionalCostSummary` entity
- [x] T009 [P] Create `OfferServiceLineItemSummaryDto` model in `lib/features/offers/data/models/offer_service_line_item_summary_dto.dart` with `fromJson` factory and `toDomain()` mapping to `OfferServiceLineItem`. Service details parsed as `Map<String, dynamic>?`. Depends on T008
- [x] T010 Create `CustomerOfferDetailsDto` model in `lib/features/offers/data/models/customer_offer_details_dto.dart` with `fromJson` factory and `toDomain()` mapping to `OfferDetails` entity. Include status normalization via `OfferFilter.fromQueryValue`. Depends on T007, T009
- [x] T011 [P] Create `AcceptOfferResponseDto` model in `lib/features/offers/data/models/accept_offer_response_dto.dart` to parse optional JSON response body with `checkoutUrl` field
- [x] T012 Create `OffersRemoteDataSource` in `lib/features/offers/data/data_sources/offers_remote_data_source.dart` with three methods: `getOfferDetails(int offerId)`, `acceptOffer(int offerId, String digitalSignature, int paymentMethod)`, `rejectOffer(int offerId, String rejectionReason)` using Dio HTTP client with existing auth interceptor patterns. Depends on T010, T011
- [x] T013 Create abstract `OffersRepository` interface in `lib/features/offers/domain/repositories/offers_repository.dart` with methods: `getOfferDetails({required int offerId})` returning `Future<OfferDetails>`, `acceptOffer({required int offerId, required String digitalSignature, required PaymentMethod paymentMethod})` returning `Future<String?>` (optional checkoutUrl), `rejectOffer({required int offerId, required String rejectionReason})` returning `Future<void>`
- [x] T014 Create `OffersRepositoryImpl` in `lib/features/offers/data/repositories/offers_repository_impl.dart` implementing `OffersRepository` using `OffersRemoteDataSource`. Depends on T012, T013
- [x] T015 [P] Create `GetOfferDetailsUseCase` in `lib/features/offers/domain/use_cases/get_offer_details_use_case.dart` wrapping `OffersRepository.getOfferDetails`
- [x] T016 [P] Create `AcceptOfferUseCase` in `lib/features/offers/domain/use_cases/accept_offer_use_case.dart` wrapping `OffersRepository.acceptOffer`
- [x] T017 [P] Create `RejectOfferUseCase` in `lib/features/offers/domain/use_cases/reject_offer_use_case.dart` wrapping `OffersRepository.rejectOffer`
- [x] T018 Wire `OffersRepository` and use cases into DI in `lib/app.dart`: instantiate `OffersRemoteDataSource` with the existing Dio instance, create `OffersRepositoryImpl`, create use case instances, and register them as `RepositoryProvider` entries in the `MultiRepositoryProvider`. Depends on T014, T015, T016, T017

**Checkpoint**: Foundation ready — all data layer, domain layer, and DI wiring complete. User story implementation can now begin.

---

## Phase 3: User Story 1 — Review Offer Details (Priority: P1) 🎯 MVP

**Goal**: Customer can open a full offer details screen from an offer card, review pricing, services, locations, terms, and attachment before making a decision.

**Independent Test**: Open an offer from the offers list → verify all sections render from offer details data → verify location rendering logic for one location and for origin-destination flow → verify attachment download feedback.

### Implementation for User Story 1

- [x] T019 [P] [US1] Create `OfferDetailsCubit` and `OfferDetailsState` in `lib/features/offers/presentation/cubit/offer_details_cubit.dart` and `lib/features/offers/presentation/cubit/offer_details_state.dart`. State holds: `LoadStatus status`, `OfferDetails? details`, `String? errorCode`. Cubit has `load()` method using `GetOfferDetailsUseCase` with DioException handling for 404/403/generic errors following the `RequestDetailsCubit` pattern
- [x] T020 [P] [US1] Create `OfferStatusBadge` widget in `lib/features/offers/presentation/widgets/offer_status_badge.dart` — reusable status badge using `OfferFilter.resolveColor` with the same styling as `_StatusBadge` in offer_card.dart (extract and share)
- [x] T021 [P] [US1] Create `ServiceTypeChips` widget in `lib/features/offers/presentation/widgets/service_type_chips.dart` — wrapping `Wrap` layout displaying service types as chips (FR-003). Split `serviceTypeOverall` by comma/semicolon into multiple chips
- [x] T022 [P] [US1] Create `OfferTotalCard` widget in `lib/features/offers/presentation/widgets/offer_total_card.dart` — card showing total amount with EGP currency, VAT Included badge (when `costsIncludeVAT == true`), and Insurance Covered badge (when `insurance` is non-null) per FR-004
- [x] T023 [P] [US1] Create `OfferSavingsCard` widget in `lib/features/offers/presentation/widgets/offer_savings_card.dart` — card showing discount amount when `hasDiscount` is true (FR-005)
- [x] T024 [P] [US1] Create `OfferLocationCard` widget in `lib/features/offers/presentation/widgets/offer_location_card.dart` — single location card with icon, title (from `displayTitle`), address details (street, city, country), floor, and elevator indicator (Yes/No) per FR-011. Hide null fields
- [x] T025 [US1] Create `OfferLocationsSection` widget in `lib/features/offers/presentation/widgets/offer_locations_section.dart` — renders one `OfferLocationCard` without connector when single location (FR-008), or vertical connected flow (Origin → connector line → Destination) when both present (FR-009). Sort by Origin before Destination (FR-007). Depends on T024
- [x] T026 [P] [US1] Create `OfferServiceLineItemCard` widget in `lib/features/offers/presentation/widgets/offer_service_line_item_card.dart` — card with service type + line total in header, dynamic service detail fields rendered from known keys (cleaningType, durationHours, numberOfStaff, fillNailHoles, withHighPressureCleaner, cleaningDate, cleaningStartTime, deliveryDate, deliveryTime, discount) with i18n labels. Boolean fields as Yes/No. Null fields hidden. Compact scalar fields in two-column layout (FR-013, FR-014). Additional costs listed below
- [x] T027 [P] [US1] Create `OfferInsuranceSection` widget in `lib/features/offers/presentation/widgets/offer_insurance_section.dart` — distinct visual container showing insurance text content (FR-015)
- [x] T028 [P] [US1] Create `OfferIncludedInPriceSection` widget in `lib/features/offers/presentation/widgets/offer_included_in_price_section.dart` — distinct visual container showing included-in-price text content (FR-015)
- [x] T029 [P] [US1] Create `OfferAttachmentRow` widget in `lib/features/offers/presentation/widgets/offer_attachment_row.dart` — row showing PDF file name, size, and download action icon button. On tap, download using Dio and save to device, show toast success/failure feedback (FR-016, FR-017)
- [x] T030 [P] [US1] Create `OfferDetailsSkeleton` widget in `lib/features/offers/presentation/widgets/offer_details_skeleton.dart` — shimmer loading placeholder matching the details layout structure
- [x] T031 [US1] Replace the placeholder `OfferDetailsPage` in `lib/features/offers/presentation/pages/offer_details_page.dart` with full implementation: BlocProvider for `OfferDetailsCubit`, scrollable body with all sections (app bar with offer number + status badge, service type chips, total card, savings card, locations section, service line item cards, insurance section, included-in-price section, attachment row), Accept/Reject action buttons at bottom (FR-018). Handle loading/error/success states. Depends on T019-T030
- [x] T032 [US1] Add all Offer Details localization strings to `lib/core/localization/l10n/app_en.arb` and `lib/core/localization/l10n/app_ar.arb`: section titles (locations, services, insurance, includedInPrice, attachment), field labels for service details (cleaningType, durationHours, etc.), action buttons (acceptOffer, rejectOffer, downloadAttachment, reviewFullAgreement), status labels, error messages, yes/no labels, location fallback title, currency label (EGP), badge texts (vatIncluded, insuranceCovered)
- [x] T033 [US1] Regenerate localization files by running `flutter gen-l10n` and verify `AppLocalizations.dart` includes all new getters

**Checkpoint**: User Story 1 complete — customer can open offer details from list, view all sections, and see Accept/Reject buttons. The details screen is fully functional and independently testable.

---

## Phase 4: User Story 2 — Accept Offer with Signature (Priority: P1)

**Goal**: Customer can review summary, select payment method, enter digital signature, confirm, and submit acceptance. COD → success → offers list. Online → open checkout URL.

**Independent Test**: Open accept flow from offer details → select payment method → submit with valid signature and checked confirmation → verify COD success returns to offers list and Online success opens checkout URL → validate required-field and invalid-signature behavior.

### Implementation for User Story 2

- [x] T034 [P] [US2] Create `AcceptOfferState` in `lib/features/offers/presentation/cubit/accept_offer_state.dart` with fields: `LoadStatus status`, `PaymentMethod? selectedPaymentMethod`, `String signature`, `bool isConfirmed`, `String? errorCode`, `bool isSubmitting`, `String? checkoutUrl`
- [x] T035 [P] [US2] Create `AcceptOfferCubit` in `lib/features/offers/presentation/cubit/accept_offer_cubit.dart` with methods: `selectPaymentMethod(PaymentMethod)`, `updateSignature(String)`, `toggleConfirmation()`, `submit()`. Validation: signature must be non-empty and start with "SIG-" (FR-020), payment method must be selected (FR-023), confirmation checkbox must be selected (FR-021). On submit: call `AcceptOfferUseCase`. Handle COD success (emit success state), Online success with checkoutUrl (emit with url), Online success without valid checkoutUrl (emit recoverable error per FR-023c). Handle API errors using categorized pattern (FR-029)
- [x] T036 [P] [US2] Create `OfferSummaryCard` widget in `lib/features/offers/presentation/widgets/offer_summary_card.dart` — reusable summary card showing offer number, company name, and total amount. Used in both accept and reject pages
- [x] T037 [P] [US2] Create `PaymentMethodSelector` widget in `lib/features/offers/presentation/widgets/payment_method_selector.dart` — radio button or segmented control for selecting COD or Online payment method with localized labels and icons
- [x] T038 [US2] Create `AcceptOfferPage` in `lib/features/offers/presentation/pages/accept_offer_page.dart`: BlocProvider for `AcceptOfferCubit`, scrollable body with review header text, `OfferSummaryCard`, `PaymentMethodSelector`, signature `TextFormField` with SIG- prefix hint, confirmation checkbox with legal text, "Review Full Agreement" text button that navigates back to offer details (FR-024), primary Submit button and secondary Cancel button. BlocListener to handle: COD success → toast + navigate to offers list, Online success → open checkout URL via `url_launcher`, recoverable error → show error toast and stay on page, API errors → show localized error feedback. Depends on T034, T035, T036, T037
- [x] T039 [US2] Add Accept Offer route to `lib/core/routing/app_router.dart`: define `acceptOfferPath` as `/my/offers/:offerId/accept`, add `static String acceptOfferLocation(int offerId)` helper, add GoRoute entry that extracts offerId and creates `AcceptOfferPage` with the offerId and offer details passed as extra
- [x] T040 [US2] Wire navigation from Offer Details Accept button to Accept Offer route in `lib/features/offers/presentation/pages/offer_details_page.dart` using `context.push(AppRouter.acceptOfferLocation(offerId))`
- [x] T041 [US2] Add all Accept Offer localization strings to `lib/core/localization/l10n/app_en.arb` and `lib/core/localization/l10n/app_ar.arb`: review header, confirmation text, signature placeholder, signature validation errors (required, invalidPrefix), payment method labels (cashOnDelivery, onlinePayment), payment method required error, confirmation required error, submit button, cancel button, success messages (acceptedCod, acceptedOnline), checkout URL error, review full agreement label
- [x] T042 [US2] Regenerate localization files by running `flutter gen-l10n`

**Checkpoint**: User Story 2 complete — customer can accept offers with COD or Online payment. Accept flow is independently testable from offer details.

---

## Phase 5: User Story 3 — Reject Offer with Reason (Priority: P2)

**Goal**: Customer can reject an offer with a required reason, and the app navigates back to refreshed offer details showing Rejected status.

**Independent Test**: Open reject flow from offer details → verify warning summary → enforce required reason with max length → submit → verify navigation returns to same offer details refreshed as Rejected → verify cancel returns to previous screen.

### Implementation for User Story 3

- [x] T043 [P] [US3] Create `RejectOfferState` in `lib/features/offers/presentation/cubit/reject_offer_state.dart` with fields: `LoadStatus status`, `String rejectionReason`, `String? errorCode`, `bool isSubmitting`
- [x] T044 [P] [US3] Create `RejectOfferCubit` in `lib/features/offers/presentation/cubit/reject_offer_cubit.dart` with methods: `updateReason(String)`, `submit()`. Validation: reason must be non-empty (FR-026), max 2000 characters (FR-026). On submit: call `RejectOfferUseCase`. Handle success → emit success. Handle API errors using categorized pattern (FR-029)
- [x] T045 [US3] Create `RejectOfferPage` in `lib/features/offers/presentation/pages/reject_offer_page.dart`: BlocProvider for `RejectOfferCubit`, scrollable body with warning header (icon + warning-styled text), `OfferSummaryCard` (reused from T036) showing offer number, status, company, and total, rejection reason `TextField` with max length 2000 and character counter, primary Submit button and secondary Cancel button. BlocListener to handle: success → toast + navigate to offer details with refresh (FR-027a), cancel → pop back (FR-028), API errors → show localized error feedback. Depends on T043, T044, T036
- [x] T046 [US3] Add Reject Offer route to `lib/core/routing/app_router.dart`: define `rejectOfferPath` as `/my/offers/:offerId/reject`, add `static String rejectOfferLocation(int offerId)` helper, add GoRoute entry
- [x] T047 [US3] Wire navigation from Offer Details Reject button to Reject Offer route in `lib/features/offers/presentation/pages/offer_details_page.dart` using `context.push(AppRouter.rejectOfferLocation(offerId))`
- [x] T048 [US3] Implement offer details refresh mechanism: when navigating back from reject success to offer details, ensure the `OfferDetailsCubit.load()` is called again so the screen reflects the updated Rejected status. Use `GoRouter` result or `PopScope` callback pattern
- [x] T049 [US3] Add all Reject Offer localization strings to `lib/core/localization/l10n/app_en.arb` and `lib/core/localization/l10n/app_ar.arb`: warning header, reject confirmation text, reason placeholder, reason validation errors (required, tooLong), submit button, cancel button, success message
- [x] T050 [US3] Regenerate localization files by running `flutter gen-l10n`

**Checkpoint**: User Story 3 complete — customer can reject offers with reason. All three screens are independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T051 [P] Verify RTL layout for all three screens (details, accept, reject) by switching app locale to Arabic: ensure cards, badges, chips, connectors, action rows, and text fields render correctly in right-to-left (FR-031)
- [x] T052 [P] Review all widgets for edge cases: negative totals/discounts display with sign formatting, empty locations array, unknown location types fallback to "Location", missing attachment metadata, long text wrapping/truncation in service detail fields (per spec edge cases)
- [x] T053 [P] Ensure Accept/Reject buttons are conditionally shown only for Pending status offers on the details page. Hide them for Accepted, Rejected, and Expired offers
- [x] T054 [P] Verify that the details page refresh after reject navigates correctly back and shows updated Rejected status and hides action buttons
- [x] T055 [P] Test error states: network failure on details load shows error with retry, accept/reject API failures show localized error feedback, already-finalized offer errors are handled gracefully
- [x] T056 Run `flutter analyze` to verify no lint warnings across all new files and fix any issues

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 entities — BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Phase 2 foundation
- **User Story 2 (Phase 4)**: Depends on Phase 2 foundation + Phase 3 (needs details page with Accept button and route)
- **User Story 3 (Phase 5)**: Depends on Phase 2 foundation + Phase 3 (needs details page with Reject button and route)
- **Polish (Phase 6)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Phase 2 — No dependencies on other stories. This is the MVP.
- **User Story 2 (P1)**: Can start after Phase 3 — Needs the Offer Details page Accept button wiring and `OfferDetails` entity for summary
- **User Story 3 (P2)**: Can start after Phase 3 — Needs the Offer Details page Reject button wiring and `OfferSummaryCard` from US2 (T036)

### Within Each User Story

- Cubit + State before page (page depends on cubit)
- Widgets before page (page composes widgets)
- Page before route registration
- Route before navigation wiring
- Localization strings before UI code (or concurrent if labels are known)

### Parallel Opportunities

- **Phase 1**: T002, T003, T004, T005 can all run in parallel (different entity files)
- **Phase 2**: T007, T008, T011 can run in parallel; T015, T016, T017 can run in parallel
- **Phase 3**: T019-T030 widgets and cubit can mostly run in parallel (different files)
- **Phase 4**: T034, T035, T036, T037 can run in parallel
- **Phase 5**: T043, T044 can run in parallel
- **Cross-story**: US2 and US3 widget tasks (T036 OfferSummaryCard) can be shared — build once in US2, reuse in US3

---

## Parallel Example: User Story 1

```bash
# Launch all widgets for User Story 1 together:
Task: "Create OfferStatusBadge widget in .../widgets/offer_status_badge.dart"
Task: "Create ServiceTypeChips widget in .../widgets/service_type_chips.dart"
Task: "Create OfferTotalCard widget in .../widgets/offer_total_card.dart"
Task: "Create OfferSavingsCard widget in .../widgets/offer_savings_card.dart"
Task: "Create OfferLocationCard widget in .../widgets/offer_location_card.dart"
Task: "Create OfferServiceLineItemCard widget in .../widgets/offer_service_line_item_card.dart"
Task: "Create OfferInsuranceSection widget in .../widgets/offer_insurance_section.dart"
Task: "Create OfferIncludedInPriceSection widget in .../widgets/offer_included_in_price_section.dart"
Task: "Create OfferAttachmentRow widget in .../widgets/offer_attachment_row.dart"
Task: "Create OfferDetailsSkeleton widget in .../widgets/offer_details_skeleton.dart"

# After all widgets complete, assemble the page:
Task: "Replace placeholder OfferDetailsPage with full implementation"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (entities + dependency)
2. Complete Phase 2: Foundational (data layer, DI wiring)
3. Complete Phase 3: User Story 1 (Offer Details screen)
4. **STOP and VALIDATE**: Open offer from list, verify all sections render
5. Demo-ready: customer can review full offer details

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Offer Details works → Demo (MVP!)
3. Add User Story 2 → Accept flow works → Demo
4. Add User Story 3 → Reject flow works → Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (details page + all widgets)
   - After US1 page exists: Developer B starts User Story 2, Developer C starts User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- All localization strings must be added for both `app_en.arb` and `app_ar.arb`
- After editing ARB files, always run `flutter gen-l10n` to regenerate
- The `OfferSummaryCard` (T036) is shared between US2 and US3 — built in US2 phase, reused in US3
