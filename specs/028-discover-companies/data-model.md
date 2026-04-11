# Data Model: Explore and Discover Companies for Leads

## Entity: LeadAccessContext
- Purpose: Determines whether discovery restrictions apply.
- Fields:
  - `isAuthenticated: bool`
  - `leadId: int?`
  - `customerId: int?`
- Derived flags:
  - `isLeadContext = customerId == null`
  - `requiresRestrictionView = isLeadContext`

## Entity: CompanySummary
- Purpose: Unified card model used in Home and Explore lists.
- Fields:
  - `companyId: int`
  - `companyName: String`
  - `companyLogoUrl: String?`
  - `city: String?`
  - `country: String?`
  - `averageRating: double?`
  - `reviewCount: int?`
  - `serviceTypes: List<String>`
  - `trendDirection: TrendDirection?` (`improving`, `declining`, `neutral`)
  - `improvementDelta: double?`

## Entity: CompanyDetailsModel
- Purpose: Full details view model for selected company.
- Fields:
  - `companyId: int`
  - `companyName: String`
  - `companyLogoUrl: String?`
  - `contactEmail: String?`
  - `phoneNumber: String?`
  - `address: String?`
  - `city: String?`
  - `zipCode: String?`
  - `country: String?`
  - `averageRating: double?`
  - `reviewCount: int?`
  - `serviceCatalog: List<CompanyServiceItem>`
  - `recentReviews: List<CompanyReviewItem>`

## Entity: ExploreCriteria
- Purpose: Current search/filter criteria for Explore requests.
- Fields:
  - `searchText: String`
  - `cityQuery: String` (same input source; parsed as city-compatible text)
  - `selectedService: ServiceFilterOption`
  - `pageIndex: int`
  - `pageSize: int`

## Entity: ServiceFilterOption
- Purpose: Single-select filter option shown in Explore.
- Allowed values:
  - `allServices`
  - `move`
  - `cleaning`
  - `disposal`
  - `packing`
  - `unpacking`
  - `storage`
  - `transport`

## Entity: DiscoverySectionState<T>
- Purpose: Independent async state per Home section and Explore list.
- Fields:
  - `status: LoadStatus` (`initial`, `loading`, `success`, `empty`, `error`)
  - `items: List<T>`
  - `errorMessage: String?`
  - `canRetry: bool`

## Entity: ExplorePaginationState
- Purpose: Tracks incremental loading for Explore results.
- Fields:
  - `items: List<CompanySummary>`
  - `nextPageIndex: int?`
  - `isAppending: bool`
  - `appendError: String?`
  - `hasReachedEnd: bool`

## Entity: RestrictionPromptState
- Purpose: Request-action and restricted-tab gate rendering.
- Fields:
  - `message: String`
  - `actionLabel: String`
  - `destinationRoute: String`
  - `scope: RestrictionScope` (`requestAction`, `requestsTab`, `offersTab`, `profileTab`)

## Relationships
- `LeadAccessContext` determines whether `RestrictionPromptState` is shown.
- Home page holds three independent `DiscoverySectionState<CompanySummary>` values.
- Explore page combines `ExploreCriteria` + `ExplorePaginationState` for dynamic list rendering.
- `CompanyDetailsModel` links to `CompanySummary` via `companyId`.

## Validation and Mapping Rules
- Service filter is single-select.
- City matching is case-insensitive partial contains.
- UI service options map to backend contract values via dedicated mapper (e.g., `move -> Moving`).
- Missing logo uses placeholder UI; missing rating uses `No reviews yet`; missing service list is hidden.
