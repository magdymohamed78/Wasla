# Research: Customer Offers Flow

**Feature**: 033-add-offers-flow | **Date**: 2026-04-23

## R1: File Download for PDF Attachment (FR-016, FR-017)

**Context**: Offer details include a `pdfUrl` for attachment download. The spec requires reusing the "same file-saving behavior and user-feedback pattern already used for digital signature download flows."

**Research**: Searched codebase for existing download patterns. No dedicated download utility found in `core/utils/`. The auth feature handles digital signature display but not file downloads to device storage.

- **Decision**: Use `dio` for downloading (already a project dependency) + `path_provider` to get device download directory + show toast feedback on success/failure
- **Rationale**: `dio` supports progress tracking and is already configured with auth interceptors. A shared utility function can be created in `core/utils/file_download_helper.dart` for reuse.
- **Alternatives Rejected**:
  - `url_launcher` — opens browser, no download progress, user leaves app
  - `flutter_downloader` package — external dependency with native platform setup; overkill for single-file downloads

## R2: Opening Checkout URL for Online Payment (FR-023b)

**Context**: Online payment acceptance returns a Stripe checkout URL that must be opened directly.

- **Decision**: Use `url_launcher` package with `launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication)`
- **Rationale**: Standard Flutter approach. Stripe checkout is a web page that works best in external browser.
- **Package Check**: `url_launcher` — 4,800+ pub points, 7,600+ likes, actively maintained, null-safe ✅
- **Alternatives Rejected**: In-app WebView (adds complexity, Stripe may not support all payment flows in embedded views)

## R3: PaymentMethod Enum Mapping

**Context**: API `PaymentMethod` is `int32` enum: `0` = COD, `1` = Online.

- **Decision**: Create `lib/features/offers/domain/entities/payment_method.dart` with `enum PaymentMethod { cod, online }` and `int toApiValue()` / `static PaymentMethod fromApiValue(int)` helpers
- **Rationale**: Domain isolation per constitution §I
- **Alternatives Rejected**: Raw integer passing (violates domain abstraction)

## R4: Service Details Rendering (FR-013, FR-014)

**Context**: `serviceDetails` field in `OfferServiceLineItemSummaryDto` is untyped JSON (`nullable: true`, no schema). Known fields per spec: `cleaningType`, `durationHours`, `numberOfStaff`, `fillNailHoles`, `withHighPressureCleaner`, `cleaningDate`, `cleaningStartTime`, `deliveryDate`, `deliveryTime`, `discount`.

- **Decision**: Parse as `Map<String, dynamic>?`. Define a `knownServiceDetailKeys` list with i18n label mappings. Iterate known keys, display if present and non-null; skip unknown keys. Boolean fields render as Yes/No. Use two-column layout for compact scalar fields.
- **Rationale**: API is flexible; multiple service types share the same details map. Hard-typing would break on new service types.
- **Alternatives Rejected**: Sealed classes per service type (rigid, breaks on new types without client update)

## R5: Accept Response Handling

**Context**: Accept endpoint (`POST /accept`) returns 200 with description: "COD: Offer accepted. Online: Returns checkout URL." No response schema in swagger.

- **Decision**: Try parsing response body as JSON with optional `checkoutUrl` string field. If paymentMethod was Online and `checkoutUrl` is present + valid → open it. If Online but no valid URL → show recoverable error (FR-023c). If COD → ignore body, show success.
- **Rationale**: Defensive parsing handles both cases safely.
- **Alternatives Rejected**: Assuming response always has body (fragile for COD case)

## R6: url_launcher Package Availability

**Research**: Checked `pubspec.yaml` — `url_launcher` is NOT currently listed as a dependency. Needs to be added.

- **Decision**: Add `url_launcher: ^6.2.0` to `pubspec.yaml`
- **Package Check**: Official Flutter team package, 160+ pub points, highest tier ✅
