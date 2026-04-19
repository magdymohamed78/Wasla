# Quickstart: Customer Dashboard Home Section

## 1) Prerequisites
1. Ensure dependencies are installed: `flutter pub get`.
2. Add rating dependency if missing: `flutter pub add flutter_rating_bar`.
3. Work on branch `032-add-customer-dashboard`.

## 2) Build data/domain foundations
1. Add customer reviews DTO/entity mapping based on `CompanyReviewDto` fields.
2. Add reviews API methods to customer-portal remote data source:
   - list my reviews (paged)
   - update review by company id
   - delete review by company id
3. Expose reviews operations through `CustomerPortalRepositoryImpl` via a dedicated reviews repository interface.
4. Implement tolerant parser for `/my/reviews` payload shape (paged object or array).

## 3) Implement Cubit state layers
1. Create `DashboardCubit` + `DashboardState` for card metrics and section-level load/error handling.
2. Create `MyReviewsCubit` + `MyReviewsState` for paginated list, edit, delete, and pull-to-refresh flows.
3. Ensure mutation success events can synchronize Home `My Reviews` count in-session.

## 4) Implement Home dashboard UI
1. Insert customer-only dashboard section in Home below search and above companies sections.
2. Build 2x2 grid cards with theme tokens only.
3. Add entry and tap animations with lightweight Flutter animation primitives.
4. Add dashboard skeleton and inline retry states without blocking other Home sections.

## 5) Implement My Reviews page
1. Create route and page for `/my/reviews`.
2. Render paginated review cards with company identity, stars, text, date, and actions.
3. Build edit modal:
   - rating selector using `flutter_rating_bar`
   - optional text input
   - validation: rating required, comment optional + trimmed
4. Build delete confirmation modal (Yes/No) and remove item on success.
5. Show success feedback using `ToastUtils`.

## 6) Routing and access guards
1. Add query-driven offers navigation contract:
   - `/my/offers?filter=accepted`
   - `/my/offers?filter=pending`
2. Parse `filter` query on offers route and initialize active tab accordingly.
3. Add My Reviews route guard behavior:
   - guest -> login
   - authenticated non-customer -> home

## 7) Localization, RTL, and responsive checks
1. Add localization keys for dashboard titles, My Reviews labels, modal actions, and feedback text.
2. Validate Arabic RTL alignment for cards, icons, list item layout, and dialog actions.
3. Validate layout on 360dp, 414dp, and 768dp targets.

## 8) Verification checklist
1. Customer role sees dashboard in required position; non-customer does not.
2. Total/Accepted/Pending cards match offers-tab counts.
3. Card taps navigate to correct destination and filter context.
4. My Reviews list loads paginated data and supports pull-to-refresh.
5. Edit enforces rating requirement and applies trimmed optional comment.
6. Delete requires confirmation and updates list immediately.
7. Home My Reviews count syncs in same session after edit/delete rules.
8. No full-screen blocking loaders are introduced.

## 9) Validation commands
1. `flutter analyze`
2. `flutter test`

## 10) Implementation validation notes (2026-04-19)

### Command outcomes
1. `flutter analyze` -> PASS (no issues found).
2. `flutter test` -> FAIL (repository currently has no `*_test.dart` files under `test/`).

### Phase 6 coverage notes
1. Localization usage finalized in dashboard/reviews UI with generated keys and localized fallbacks (`companyDetailsUnknownCompany`, `requestDetailsNotAvailable`).
2. RTL/responsive pass applied:
   - adaptive dashboard grid columns/spacing for 360dp, 414dp, and tablet widths.
   - directional paddings on reviews page shells and list containers.
3. DI verification completed: `CustomerReviewsRepository` remains provided from the portal composite in `app.dart` and supports both dashboard metrics and My Reviews workflows.

### End-to-end scenario status
1. Dashboard visibility and role gating: IMPLEMENTED (code-path verified).
2. Metric-card navigation targets and offers-filter routing: IMPLEMENTED (code-path verified).
3. My Reviews pagination/edit/delete/feedback and in-session dashboard count sync: IMPLEMENTED (code-path verified).
4. Device/runtime walkthrough: PENDING (not executed in this environment).
