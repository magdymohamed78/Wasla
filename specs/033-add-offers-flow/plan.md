# Implementation Plan: Customer Offers Flow

**Branch**: `033-add-offers-flow` | **Date**: 2026-04-23 | **Spec**: [spec.md](file:///D:/study/GitHup-Projects/Wasla/specs/033-add-offers-flow/spec.md)
**Input**: Feature specification from `/specs/033-add-offers-flow/spec.md`

## Summary

Build three screens — **Offer Details**, **Accept Offer**, and **Reject Offer** — backed by three API endpoints from the customer portal:

| Endpoint | Method | DTO |
|---|---|---|
| `/api/customer-portal/my/offers/{offerId}` | GET | `CustomerOfferDetailsDto` |
| `/api/customer-portal/my/offers/{offerId}/accept` | POST | `AcceptOfferDto` (digitalSignature + paymentMethod enum 0=COD, 1=Online) |
| `/api/customer-portal/my/offers/{offerId}/reject` | POST | `RejectOfferDto` (rejectionReason, max 2000 chars) |

The implementation follows Clean Architecture (constitution §I) within the existing `lib/features/offers/` module, reuses `OfferFilter.resolveColor` for status badges, `LoadStatus` for state management, and the categorized error pattern from `RequestDetailsCubit`.

## Technical Context

**Language/Version**: Dart 3.11 (Flutter stable, null-safe)
**Primary Dependencies**: `flutter_bloc`, `go_router`, `dio`, `intl`, `url_launcher`
**Storage**: N/A (all from API)
**Testing**: `flutter_test` (no existing tests in `test/`)
**Target Platform**: Android (mobile-app)
**Project Type**: mobile-app
**Performance Goals**: Details visible within 2 seconds (SC-002)
**Constraints**: RTL support required, localized strings only, centralized theme tokens only
**Scale/Scope**: 3 new screens, ~25 new files

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Gate | Status | Notes |
|---|---|---|---|
| 1 | Clean Architecture | ✅ | Data → Domain → Presentation layers |
| 2 | Feature-Based Structure | ✅ | All files under `lib/features/offers/` |
| 3 | Cubit State Management | ✅ | Separate Cubit per screen concern |
| 4 | Navigation Separation | ✅ | Routes declared in `AppRouter`, navigation via `context.push`/`context.go` |
| 5 | Figma Design Compliance | ⚠️ | No Figma available; follow existing app patterns |
| 6 | Centralized Theming | ✅ | `AppColors`, `AppTypography`, `AppDimensions` only |
| 7 | Widget Purity | ✅ | No business logic in widgets |
| 8 | Responsive Design | ✅ | Wrapping layouts, flexible widths |
| 9 | Widget Reusability | ✅ | Status badge, chips, location cards as reusable widgets |
| 10 | Testable Code | ✅ | DI, abstract repos, focused functions |
| 11 | Package-First | ✅ | `url_launcher` for checkout URL, `dio` for HTTP |

## Project Structure

### Documentation (this feature)

```text
specs/033-add-offers-flow/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (via /speckit.tasks)
```

### Source Code (repository root)

```text
lib/features/offers/
├── data/
│   ├── data_sources/
│   │   └── offers_remote_data_source.dart        # Dio calls for details/accept/reject
│   ├── models/
│   │   ├── offer_page_result_dto.dart             # (existing)
│   │   ├── customer_offer_details_dto.dart        # Maps CustomerOfferDetailsDto JSON
│   │   ├── offer_location_summary_dto.dart        # Maps OfferLocationSummaryDto JSON
│   │   ├── offer_service_line_item_summary_dto.dart # Maps OfferServiceLineItemSummaryDto JSON
│   │   ├── accept_offer_response_dto.dart         # Parses accept 200 (may have checkoutUrl)
│   │   └── additional_cost_summary_dto.dart       # Maps AdditionalCostSummaryDto
│   └── repositories/
│       └── offers_repository_impl.dart            # Implements abstract OffersRepository
├── domain/
│   ├── entities/
│   │   ├── offer_filter.dart                      # (existing)
│   │   ├── offer_page_result.dart                 # (existing)
│   │   ├── offer_status_counts.dart               # (existing)
│   │   ├── offer_summary_item.dart                # (existing)
│   │   ├── offer_details.dart                     # Domain entity for full offer details
│   │   ├── offer_location.dart                    # Domain entity for location
│   │   ├── offer_service_line_item.dart           # Domain entity for service line item
│   │   └── payment_method.dart                    # Enum: cod(0), online(1)
│   ├── repositories/
│   │   └── offers_repository.dart                 # Abstract: getDetails, acceptOffer, rejectOffer
│   └── use_cases/
│       ├── get_offer_details_use_case.dart
│       ├── accept_offer_use_case.dart
│       └── reject_offer_use_case.dart
├── presentation/
│   ├── cubit/
│   │   ├── customer_offers_cubit.dart             # (existing — listing)
│   │   ├── offer_details_cubit.dart               # New: load details
│   │   ├── offer_details_state.dart
│   │   ├── accept_offer_cubit.dart                # New: validate + submit acceptance
│   │   ├── accept_offer_state.dart
│   │   ├── reject_offer_cubit.dart                # New: validate + submit rejection
│   │   └── reject_offer_state.dart
│   ├── pages/
│   │   ├── customer_offers_page.dart              # (existing)
│   │   ├── offer_details_page.dart                # Replace placeholder with real impl
│   │   ├── accept_offer_page.dart                 # New
│   │   └── reject_offer_page.dart                 # New
│   └── widgets/
│       ├── offer_card.dart                        # (existing)
│       ├── offer_card_skeleton.dart                # (existing)
│       ├── offer_filter_tabs.dart                  # (existing)
│       ├── offer_status_badge.dart                 # Extracted reusable status badge
│       ├── offer_summary_card.dart                 # Shared summary (accept/reject pages)
│       ├── offer_total_card.dart                   # Total amount + VAT/Insurance badges
│       ├── offer_savings_card.dart                 # Applied discount
│       ├── offer_location_card.dart                # Single location card
│       ├── offer_locations_section.dart             # Origin→Destination connected flow
│       ├── offer_service_line_item_card.dart        # Individual service item with detail fields
│       ├── service_type_chips.dart                  # Wrapping chip list for service types
│       ├── offer_attachment_row.dart                # PDF attachment with download action
│       ├── offer_insurance_section.dart             # Insurance text section
│       ├── offer_included_in_price_section.dart     # Included-in-price text section
│       ├── payment_method_selector.dart             # COD / Online radio/selection UI
│       └── offer_details_skeleton.dart              # Shimmer loading placeholder
└── routing/                                         # (empty — routes in AppRouter)
```

**Structure Decision**: Feature-based under `lib/features/offers/` following the existing Clean Architecture boundary (Principle I & II). Routes stay in `lib/core/routing/app_router.dart`.

## Complexity Tracking

No constitution violations to justify.

## Research Summary (Phase 0)

### Decision 1: File download approach for PDF attachment
- **Decision**: Use `dio` for downloading + `path_provider` and `open_file` or system download handling
- **Rationale**: Spec says "reuse the same file-saving behavior and user-feedback pattern already used for digital signature download flows" (FR-017). Need to check for existing pattern in auth/settings features.
- **Alternatives**: `url_launcher` (opens browser, less control), custom download manager (overkill)

### Decision 2: Checkout URL opening for Online payment
- **Decision**: Use `url_launcher` package (`launchUrl` with external application mode)
- **Rationale**: Standard Flutter approach for opening external URLs. Already likely in dependencies.
- **Alternatives**: In-app WebView (heavier, not needed per spec)

### Decision 3: PaymentMethod enum mapping
- **Decision**: Map API integer enum (0=COD, 1=Online) to domain `PaymentMethod` enum
- **Rationale**: API uses `PaymentMethod` as int32 enum. The domain layer wraps this cleanly.
- **Alternatives**: Use raw int (violates Clean Architecture principle)

### Decision 4: Service details rendering
- **Decision**: Parse `serviceDetails` as `Map<String, dynamic>`, display known fields (cleaningType, durationHours, numberOfStaff, etc.), safely ignore unknown keys
- **Rationale**: API `serviceDetails` is untyped nullable JSON. Known fields from FR-013 will be rendered with i18n labels; unknown keys are skipped per edge case spec.
- **Alternatives**: Strongly-typed sealed class per service type (too rigid, API doesn't guarantee structure)

### Decision 5: Accept response handling
- **Decision**: Accept endpoint returns 200 with optional body. For Online payment, parse response for `checkoutUrl` string. For COD, no body needed.
- **Rationale**: Swagger shows 200 response with no schema specified. Based on description: "COD: Offer accepted. Online: Returns checkout URL." Handle as optional JSON body with `checkoutUrl` field.
- **Alternatives**: Separate DTOs per payment method (unnecessary complexity)

## Verification Plan

### Automated Tests
- No existing tests in `test/` directory. This project does not currently have automated testing infrastructure set up.

### Manual Verification
Since there are no automated tests, verification will be manual against a running API:

1. **Offer Details Screen**: Open an offer from the offers list → verify all sections render correctly (offer number in app bar, status badge, service type chips, total card, savings card, locations flow, service line items, insurance/included sections, attachment row)
2. **Accept Offer Screen**: From offer details tap Accept → verify payment method selector, signature input, confirmation checkbox, Review Full Agreement link → submit with valid data → verify COD navigates to offers list, Online opens checkout URL
3. **Reject Offer Screen**: From offer details tap Reject → verify warning, summary card, rejection reason textarea → submit → verify navigation back to refreshed offer details showing Rejected status
4. **Validation Tests**: Try submitting accept without payment method / without signature / without SIG- prefix / without checkbox → all should show toast errors. Try rejecting with empty reason / over 2000 chars → should show validation errors.
5. **Error Handling**: Test with network off → verify error states and retry. Test on already-finalized offer → verify appropriate error message.
6. **RTL Test**: Switch app to Arabic → verify all three screens layout correctly in RTL

> **Note**: The user should test these manually on an emulator/device connected to the API backend. If the user has preferred testing approaches, please advise.
