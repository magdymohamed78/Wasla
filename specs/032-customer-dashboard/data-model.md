# Data Model: Customer Dashboard Home Section

## Entity: DashboardMetricType
- Purpose: Canonical identity for each dashboard card and interaction target.
- Values:
  - `totalOffers`
  - `acceptedOffers`
  - `pendingOffers`
  - `myReviews`

## Entity: DashboardMetricCard
- Purpose: Presentation model for one dashboard card.
- Fields:
  - `type: DashboardMetricType`
  - `titleKey: String` (localization key)
  - `value: int`
  - `iconToken: String` (symbolic icon identifier)
  - `accentVariant: String` (theme variant, not hard-coded color)
  - `isLoading: bool`
  - `hasError: bool`

## Entity: OfferMetricsSummary
- Purpose: Aggregated offer counters displayed in dashboard cards.
- Fields:
  - `total: int`
  - `accepted: int`
  - `pending: int`
- Source: Existing offer status counts model used by offers feature.

## Entity: MyReviewsCountSummary
- Purpose: Aggregated count used for dashboard `My Reviews` card.
- Fields:
  - `totalCount: int`
  - `isStale: bool`

## Entity: DashboardState
- Purpose: Combined home-dashboard state for section-level rendering.
- Fields:
  - `status: LoadStatus` (`initial | loading | success | error`)
  - `offerSummary: OfferMetricsSummary`
  - `reviewsSummary: MyReviewsCountSummary`
  - `errorCode: String?`
  - `lastSyncedAt: DateTime?`
- Notes:
  - Partial-failure support is required so unrelated Home sections keep rendering.

## Entity: CustomerReviewItem
- Purpose: One review record rendered in My Reviews list.
- Fields:
  - `reviewId: int`
  - `companyId: int`
  - `companyName: String?`
  - `companyLogoUrl: String?`
  - `customerFirstName: String?`
  - `rating: int` (1..5)
  - `reviewText: String?`
  - `createdAt: DateTime`
  - `updatedAt: DateTime?`

## Entity: CustomerReviewsPageResult
- Purpose: Normalized paginated result for My Reviews list view.
- Fields:
  - `items: List<CustomerReviewItem>`
  - `pageIndex: int`
  - `pageSize: int`
  - `totalCount: int`
  - `totalPages: int`
- Derived:
  - `hasReachedEnd = pageIndex >= totalPages || items.isEmpty`

## Entity: ReviewEditInput
- Purpose: Validated edit payload submitted to update endpoint.
- Fields:
  - `companyId: int`
  - `rating: int` (required, 1..5)
  - `reviewText: String?` (optional, whitespace-trimmed)

## Entity: ReviewDeleteAction
- Purpose: Confirmed deletion intent and target review identity.
- Fields:
  - `companyId: int`
  - `reviewId: int`
  - `confirmed: bool`

## Entity: MyReviewsState
- Purpose: Stateful model for paginated list + edit/delete flows.
- Fields:
  - `status: LoadStatus` (`initial | loading | success | empty | error`)
  - `items: List<CustomerReviewItem>`
  - `nextPageIndex: int`
  - `hasReachedEnd: bool`
  - `isLoadingMore: bool`
  - `isMutating: bool`
  - `errorCode: String?`

## Validation Rules
- `rating` is mandatory and must be in range `[1, 5]` before edit submit.
- `reviewText` is optional; if present it is trimmed before request serialization.
- `companyId` and `reviewId` must be positive for edit/delete operations.
- Infinite-scroll append must avoid duplicate review entries by `reviewId`.
- Dashboard count synchronization rules:
  - successful delete -> decrement `myReviews.totalCount` by 1 (floor at 0)
  - successful edit -> keep count unchanged

## State Transitions
- Dashboard section:
  - `initial -> loading -> success | error`
  - `success + sync event -> success` (count updates without full reload)
- My Reviews list:
  - `initial -> loading -> success | empty | error`
  - `success + loadMore -> success` (append)
  - `success + edit -> success` (in-place item update)
  - `success + delete -> success | empty` (remove item and recalc)
- Access guard:
  - non-customer route attempt -> redirect (no My Reviews state initialization)
