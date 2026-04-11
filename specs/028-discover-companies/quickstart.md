# Quickstart: Explore and Discover Companies for Leads

## 1) Prepare dependencies
1. Add pagination, debounce, image-cache, and skeleton dependencies.
2. Run dependency resolution and ensure no version conflicts.

## 2) Expand Home feature architecture
1. Convert `features/home` from placeholder-only to full Clean Architecture layers.
2. Add discovery entities, repository contracts, data models, and remote data source implementations.
3. Keep API mapping logic in data layer only.

## 3) Implement Home discovery screen
1. Replace placeholder Home page with vertical discovery layout.
2. First visible element must be search bar.
3. Add three horizontal sections in order:
   - Recommended Companies
   - Trending Companies
   - All Companies
4. Manage each section state independently (loading/success/empty/error).

## 4) Implement Explore screen
1. Add search field (`Search companies...`) and single-select service filter chips.
2. Apply 300ms debounce.
3. Use paginated vertical results list with infinite scrolling.
4. Support clear filters and empty-state recovery.

## 5) Implement Company Details
1. Add details route with `companyId` parameter.
2. Render header, contact, services, and reviews sections.
3. Handle missing logo/rating/services gracefully.

## 6) Implement restriction behavior
1. Block request-action attempts in lead context and show restriction card.
2. Continue button routes to onboarding/login.
3. Requests/Offers/Profile tabs show full-screen restriction with Browse Companies action.

## 7) Wire routing and guards
1. Update router to allow lead discovery entry flow.
2. Ensure Home -> Explore and card tap -> Company Details navigation.
3. Keep restriction gating deterministic in Cubit/state layer.

## 8) Validate quality gates
1. Verify theme token usage only.
2. Verify section-level retry/error isolation.
3. Verify city contains-match behavior and filter mapping.
4. Verify responsive behavior across target phone sizes.
5. Run static analysis and targeted widget/Cubit tests.

## Validation Log (2026-04-11)

- Step 1 (Dependencies): PASS.
   - Verified discovery dependencies are present in `pubspec.yaml` and resolved.

- Step 2 (Architecture Expansion): PASS.
   - Confirmed `features/home` has data/domain/presentation layers with mappers, repository, and use cases.

- Step 3 (Home Discovery): PASS.
   - Confirmed Home renders discovery sections with independent state handling and retry surfaces.

- Step 4 (Explore): PASS.
   - Confirmed debounced search, single-select filters, and paginated list are wired.

- Step 5 (Company Details): PASS.
   - Confirmed details page sections render with fallback-ready display and locale-aware review dates.

- Step 6 (Restriction Behavior): PASS.
   - Confirmed restricted tab experience for Requests/Offers/Profile with Browse Companies recovery action.

- Step 7 (Routing and Guards): PASS.
   - Confirmed routes for Home/Explore/Company and restricted tabs are registered and navigation paths resolve.

- Step 8 (Quality Gates): PASS.
   - Ran `flutter gen-l10n` after localization copy finalization.
   - Ran `flutter analyze lib/features/home` -> no issues.
   - Ran targeted Home test set -> 15 passed, 0 failed.
