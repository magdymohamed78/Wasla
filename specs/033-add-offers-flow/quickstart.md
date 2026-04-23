# Quickstart: Customer Offers Flow

**Feature**: 033-add-offers-flow | **Date**: 2026-04-23

## Overview

This feature adds three screens to the Wasla customer portal within the existing `lib/features/offers/` module:

1. **Offer Details** — Full offer view with sections for service types, total, savings, locations, service line items, insurance, included-in-price, and PDF attachment
2. **Accept Offer** — Acceptance flow with payment method selection (COD/Online), digital signature input, and confirmation checkbox
3. **Reject Offer** — Rejection flow with warning summary and required reason textarea

## Prerequisites

- Flutter SDK (stable channel, Dart 3.11+)
- Running API backend with customer portal endpoints
- Authenticated customer session (JWT with `customerId` claim)

## Quick Setup

```bash
# 1. Switch to feature branch
git checkout 033-add-offers-flow

# 2. Install dependencies (adds url_launcher)
flutter pub get

# 3. Run the app
flutter run
```

## Navigation Flow

```
Offers List → tap card → Offer Details
                           ├── Accept → Accept Offer Page
                           │              ├── COD success → Offers List
                           │              └── Online success → External checkout URL
                           └── Reject → Reject Offer Page
                                          └── success → Offer Details (refreshed, Rejected)
```

## Key Architecture Decisions

| Decision | Choice | Why |
|---|---|---|
| State management | 3 separate Cubits (details/accept/reject) | Clean separation per screen responsibility |
| Service details rendering | Dynamic `Map<String, dynamic>` | API schema is untyped; adapts to future service types |
| Payment method | Domain enum mapped from API int | Clean Architecture §I |
| Checkout URL | `url_launcher` external browser | Standard Flutter approach, Stripe compatibility |
| PDF download | `dio` + `path_provider` | Reuses existing HTTP layer with auth interceptors |

## File Map (new/modified files)

- `data/data_sources/offers_remote_data_source.dart` — API calls
- `data/models/customer_offer_details_dto.dart` — JSON parsing
- `data/models/offer_location_summary_dto.dart` — Location JSON
- `data/models/offer_service_line_item_summary_dto.dart` — Line item JSON
- `data/models/accept_offer_response_dto.dart` — Accept response
- `data/models/additional_cost_summary_dto.dart` — Additional cost JSON
- `data/repositories/offers_repository_impl.dart` — Repository implementation
- `domain/entities/offer_details.dart` — Domain entity
- `domain/entities/offer_location.dart` — Domain entity
- `domain/entities/offer_service_line_item.dart` — Domain entity
- `domain/entities/payment_method.dart` — Enum
- `domain/repositories/offers_repository.dart` — Abstract interface
- `domain/use_cases/get_offer_details_use_case.dart`
- `domain/use_cases/accept_offer_use_case.dart`
- `domain/use_cases/reject_offer_use_case.dart`
- `presentation/cubit/offer_details_cubit.dart` + state
- `presentation/cubit/accept_offer_cubit.dart` + state
- `presentation/cubit/reject_offer_cubit.dart` + state
- `presentation/pages/offer_details_page.dart` — Replaces placeholder
- `presentation/pages/accept_offer_page.dart` — New
- `presentation/pages/reject_offer_page.dart` — New
- `presentation/widgets/` — ~12 new widget files

## Localization

All user-visible text must be added to the localization ARB files. No hardcoded strings allowed (FR-030).
