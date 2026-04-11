# Contract: Discovery and Explore API Integration

## Purpose
Define stable client-side integration rules for Home discovery, Explore search/filter, and Company Details in lead context.

## Endpoints and Query Contract

### 1) All Companies / Explore Source
- Endpoint: `GET /api/customer-portal/companies`
- Query parameters:
  - `pageIndex` (int)
  - `pageSize` (int)
  - `search` (string, company name)
  - `city` (string, case-insensitive contains on backend/query behavior)
  - `serviceType` (string)
  - `sortBy` (optional, default `rating`)
- Response item schema: `PublicCompanyListDto[]`

### 2) Recommended Companies
- Endpoint: `GET /api/customer-portal/recommended-companies`
- Query parameters:
  - `ServiceType` (string)
  - `PageIndex` (int)
  - `PageSize` (int)
- Response schema: `RecommendedCompanyDtoPaginatedResult`

### 3) Trending Companies
- Endpoint: `GET /api/customer-portal/trending-companies`
- Query parameters:
  - `ServiceType` (string)
  - `PageIndex` (int)
  - `PageSize` (int)
- Response schema: `TrendingCompanyDtoPaginatedResult`

### 4) Company Details
- Endpoint: `GET /api/customer-portal/companies/{companyId}`
- Path parameters:
  - `companyId` (int)
- Response schema: `PublicCompanyDetailsDto`

### 5) Company Reviews (optional extended paging)
- Endpoint: `GET /api/customer-portal/companies/{companyId}/reviews`
- Query parameters:
  - `pageIndex` (int)
  - `pageSize` (int)
- Response: paged review list (schema as defined by backend)

## UI-to-API Mapping Contract

### Service Filter Mapping
- `All Services -> null`
- `Move -> Moving`
- `Cleaning -> Cleaning`
- `Disposal -> Disposal`
- `Packing -> Packing`
- `Unpacking -> Unpacking`
- `Storage -> Storage`
- `Transport -> Transport`

### Search Mapping
- Search field input maps to:
  - `search` for company name intent
  - `city` for city filtering intent
- Client can send both fields simultaneously when needed.

## Response Normalization Contract
- `companyLogoUrl == null` -> show local placeholder image.
- `averageRating == null or reviewCount == 0` -> show `No reviews yet` fallback text.
- Missing service arrays (`services`, `serviceTypes`, `serviceCatalog`) -> hide service tags/section.
- Trending indicator derives from:
  - `improvementDelta > 0` -> improving
  - `improvementDelta < 0` -> declining
  - `improvementDelta == 0` or missing -> neutral/hidden

## State and Error Contract
- Home sections are independent:
  - One section error MUST NOT block others.
  - Failed section shows inline error + retry.
- Explore search behavior:
  - 300ms debounce
  - ignore/cancel stale requests
  - avoid duplicate identical query requests
- Empty Explore results show dedicated empty-state card with clear-filters action.

## Restriction and Navigation Contract
- In lead context, Request Service action is always blocked and shows restriction card.
- Restriction Continue action routes to onboarding/login flow.
- Restricted bottom tabs (Requests, Offers, Profile) show full-screen restriction view with Browse Companies action routing to Home.

## Routing Contract
- Company details route requires `companyId` parameter and opens corresponding details screen.
- Home search-bar tap always routes to Explore.
