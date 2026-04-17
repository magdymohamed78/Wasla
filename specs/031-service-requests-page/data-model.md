# Data Model: Service Requests Page

## Entity: RequestFilter
- Purpose: UI and query scope selector for request list views.
- Values:
  - `all`
  - `pending`
  - `inProgress`
  - `closed`
  - `expired`
- Derived query behavior:
  - `all` -> status omitted
  - other values -> mapped canonical status query value

## Entity: RequestStatusCounts
- Purpose: Badge counts shown on horizontal filter tabs.
- Fields:
  - `all: int`
  - `pending: int`
  - `inProgress: int`
  - `closed: int`
  - `expired: int`
  - `unknown: int`
- Source: backend `statusCounts` object + normalization map.

## Entity: RequestSummaryItem
- Purpose: Card-level summary used in preview and full lists.
- Fields:
  - `serviceRequestId: int`
  - `referenceNumber: String?`
  - `companyId: int`
  - `companyName: String?`
  - `companyLogoUrl: String?`
  - `serviceType: String?`
  - `rawStatus: String?`
  - `normalizedFilter: RequestFilter`
  - `preferredDate: DateTime?`
  - `createdAt: DateTime`
  - `hasOffer: bool`
  - `offerId: int?`

## Entity: RequestPageResult
- Purpose: Structured paginated result returned from list endpoint.
- Fields:
  - `items: List<RequestSummaryItem>`
  - `pageIndex: int`
  - `pageSize: int`
  - `totalCount: int`
  - `totalPages: int`
  - `statusCounts: RequestStatusCounts`
- Derived:
  - `hasReachedEnd = pageIndex >= totalPages || items.isEmpty`

## Entity: RequestPreviewSlice
- Purpose: Main page preview model limited to max 5 cards.
- Fields:
  - `activeFilter: RequestFilter`
  - `items: List<RequestSummaryItem>` (0..5)
  - `statusCounts: RequestStatusCounts`
  - `isLoading: bool`
  - `errorCode: String?`

## Entity: RequestDetailsCompact
- Purpose: Compact details payload rendered by details page.
- Fields:
  - `serviceRequestId: int`
  - `referenceNumber: String?`
  - `companyId: int`
  - `companyName: String?`
  - `companyLogoUrl: String?`
  - `serviceType: String?`
  - `status: String?`
  - `preferredDate: DateTime?`
  - `createdAt: DateTime`

## Entity: FullRequestListState
- Purpose: Full-page state for one filter with pagination.
- Fields:
  - `filter: RequestFilter`
  - `items: List<RequestSummaryItem>`
  - `nextPageIndex: int`
  - `hasReachedEnd: bool`
  - `isInitialLoading: bool`
  - `isLoadingMore: bool`
  - `errorCode: String?`

## Entity: RequestDetailsState
- Purpose: Details-page state model.
- Fields:
  - `serviceRequestId: int`
  - `status: LoadStatus`
  - `details: RequestDetailsCompact?`
  - `errorCode: String?`

## Validation Rules
- `serviceRequestId` must be positive before details fetch/navigation.
- Preview item count must never exceed 5 on main page.
- Unknown statuses are retained in `all` and excluded from explicit filter tabs.
- `createdAt` must be parsed and locale-formatted for display; if parsing fails, fallback display should be safe and non-crashing.
- Pagination append must prevent duplicates by `serviceRequestId`.

## State Transitions
- Main page:
  - `initial -> loading -> success|empty|error`
  - `success(filter A) -> loading(filter B) -> success|empty|error`
- Full page:
  - `initial -> loading -> success|empty|error`
  - `success + loadMore -> success|error(loadMore)`
- Details page:
  - `initial -> loading -> success|error`
