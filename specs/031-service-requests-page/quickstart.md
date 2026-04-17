# Quickstart: Service Requests Page

## 1) Prerequisites
1. Ensure dependencies are installed: `flutter pub get`.
2. Work on branch `feature/031-service-requests-page`.
3. Confirm backend connectivity to customer-portal endpoints.

## 2) Build data/domain foundations
1. Add paginated list response model for customer requests including `statusCounts`.
2. Add compact details model in requests feature domain.
3. Implement requests repository methods:
   - list by page/filter
   - fetch details by request id
4. Keep status normalization logic centralized in domain/use case layer.

## 3) Implement presentation state
1. Create/extend Requests List Cubit for:
   - initial load
   - tab change reload
   - empty/error handling
   - preview cap (max 5)
2. Create Request Details Cubit for:
   - details loading
   - success/error state
3. Create full-list pagination Cubit state (or extension of list cubit) for incremental loading.

## 4) Implement UI screens and widgets
1. Main Requests page:
   - AppBar title `Requests`
   - Header section text
   - Horizontal filter tabs with counts
   - Preview cards (<=5)
   - `LOADING MORE REQUESTS...` action
2. Full filtered page:
   - Filter-specific context
   - Incremental paginated loading
3. Request Details page:
   - Compact field rendering only
4. Loading states:
   - Card-shaped skeleton placeholders for initial and incremental loading

## 5) Routing and navigation
1. Ensure main customer requests route enters Requests page.
2. Add full-list route with filter parameterization.
3. Add details route requiring `serviceRequestId`.
4. Wire `View Request` to details route.
5. Wire empty/error primary CTA to browse companies destination and secondary CTA to retry.

## 6) Localization and RTL
1. Add/verify localization keys for:
   - titles/headers
   - filter labels
   - CTA labels
   - empty/error copy
2. Validate RTL alignment and date rendering in Arabic locale.

## 7) Verification checklist
1. Customer can open requests page and switch all filters.
2. Preview never exceeds five cards.
3. `LOADING MORE REQUESTS...` opens filter-scoped full page.
4. Full page paginates with append and stops at end.
5. `View Request` opens details for exact id.
6. Empty/error states show two actions (Browse Companies, Retry).
7. Dates are locale-aware in English and Arabic.

## 8) Validation commands
1. `flutter analyze`
2. `flutter test` (if tests exist for this feature path)

---

## Implementation Outcomes

**Analyzer result**: `No issues found!` (0 errors, 0 warnings, 0 infos)

**Date**: 2026-04-17

### Files Created (20 new)

**Domain layer:**
- `lib/features/requests/domain/entities/request_filter.dart`
- `lib/features/requests/domain/entities/request_status_counts.dart`
- `lib/features/requests/domain/entities/request_page_result.dart`
- `lib/features/requests/domain/entities/request_details_compact.dart`
- `lib/features/requests/domain/use_cases/request_status_normalization_use_case.dart`

**Data layer:**
- `lib/features/requests/data/models/request_page_result_dto.dart`
- `lib/features/requests/data/models/request_details_compact_dto.dart`
- `lib/features/requests/data/repositories/requests_repository_impl.dart`
- `lib/features/home/domain/use_cases/get_customer_service_request_details_use_case.dart`

**Presentation layer:**
- `lib/features/requests/presentation/cubit/customer_requests_state.dart`
- `lib/features/requests/presentation/cubit/full_request_list_state.dart`
- `lib/features/requests/presentation/cubit/full_request_list_cubit.dart`
- `lib/features/requests/presentation/cubit/request_details_state.dart`
- `lib/features/requests/presentation/cubit/request_details_cubit.dart`
- `lib/features/requests/presentation/widgets/request_filter_tabs.dart`
- `lib/features/requests/presentation/widgets/request_card.dart`
- `lib/features/requests/presentation/widgets/request_card_skeleton.dart`
- `lib/features/requests/presentation/pages/request_details_page.dart`
- `lib/features/requests/presentation/pages/customer_requests_full_page.dart`

### Files Modified (7)

- `lib/core/localization/l10n/app_en.arb` — 28 new localization keys
- `lib/core/localization/l10n/app_ar.arb` — 28 new localization keys
- `lib/core/routing/app_router.dart` — route constants, location helpers, GoRoute entries
- `lib/features/home/domain/entities/customer_service_request_summary.dart` — added `companyLogoUrl`
- `lib/features/home/data/models/customer_service_request_summary_dto.dart` — added `companyLogoUrl` parsing
- `lib/features/home/data/data_sources/customer_requests_remote_data_source.dart` — paged + details methods
- `lib/features/home/data/data_sources/customer_portal_remote_data_source.dart` — paged + details contract
- `lib/features/home/domain/repositories/customer_requests_repository.dart` — paged + details methods
- `lib/features/home/data/repositories/customer_portal_repository_impl.dart` — full mapping implementation
- `lib/features/home/domain/use_cases/get_customer_service_requests_use_case.dart` — added `getPaged()`
- `lib/features/home/domain/use_cases/customer_portal_use_cases.dart` — export new use case
- `lib/features/requests/presentation/cubit/customer_requests_cubit.dart` — refactored for paged + filters
- `lib/features/requests/presentation/pages/customer_requests_page.dart` — full rebuild with tabs/CTAs
- `lib/app.dart` — inject `GetCustomerServiceRequestDetailsUseCase`

### Verification Checklist Status

| # | Scenario | Status |
|---|----------|--------|
| 1 | Customer can open requests page and switch all filters | Implemented — `CustomerRequestsCubit.changeFilter()` |
| 2 | Preview never exceeds five cards | Implemented — `CustomerRequestsState.maxPreviewItems = 5` |
| 3 | Load More opens filter-scoped full page | Implemented — `requestsFullListLocation(filter:)` |
| 4 | Full page paginates with append and stops at end | Implemented — `FullRequestListCubit.loadMore()` with duplicate guard + `hasReachedEnd` |
| 5 | View Request opens details for exact id | Implemented — `requestDetailsLocation(serviceRequestId)` |
| 6 | Empty/error states show two actions | Implemented — Browse Companies primary + Retry secondary |
| 7 | Dates are locale-aware in EN and AR | Implemented — `DateFormat.yMMMd(locale)` with `Localizations.localeOf(context)` |

### Architecture Notes

- Status normalization uses canonical mapping: Pending/New/Submitted → pending, InProgress/OfferSent/Assigned/Scheduled → inProgress, Completed/Rejected/Cancelled/Accepted → closed, Expired → expired, unknown → all-only
- Paged API returns `statusCounts` alongside items; counts are normalized and cached in cubit state
- Details page handles 404 (not found), 403 (access denied), and generic errors with distinct messages
- Duplicate-by-ID guard prevents re-appending same items during pagination
- All widgets use theme tokens (`AppColors`, `AppDimensions`, `AppTypography`) — no hardcoded values
- RTL is inherently supported via Flutter's directional layout (Row/Column with start alignment)
