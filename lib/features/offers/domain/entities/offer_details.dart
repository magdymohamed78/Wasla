import 'offer_location.dart';
import 'offer_service_line_item.dart';
import 'offer_filter.dart';

/// Full offer details domain entity loaded from the
/// `GET /api/customer-portal/my/offers/{offerId}` endpoint.
class OfferDetails {
  final int offerId;
  final String? offerNumber;
  final int companyId;
  final String? companyName;
  final String? status;

  /// Normalized filter for color mapping via [OfferFilter.resolveColor].
  final OfferFilter normalizedFilter;

  final String? serviceTypeOverall;
  final double totalAmount;
  final double discountAmount;
  final DateTime? issueDate;
  final DateTime? acceptDate;
  final String? digitalSignature;
  final String? rejectionReason;
  final String? insurance;
  final String? includedInPrice;
  final bool? costsIncludeVAT;
  final String? pdfUrl;
  final List<OfferLocation> locations;
  final List<OfferServiceLineItem> serviceLineItems;

  const OfferDetails({
    required this.offerId,
    this.offerNumber,
    this.companyId = 0,
    this.companyName,
    this.status,
    this.normalizedFilter = OfferFilter.all,
    this.serviceTypeOverall,
    this.totalAmount = 0,
    this.discountAmount = 0,
    this.issueDate,
    this.acceptDate,
    this.digitalSignature,
    this.rejectionReason,
    this.insurance,
    this.includedInPrice,
    this.costsIncludeVAT,
    this.pdfUrl,
    this.locations = const [],
    this.serviceLineItems = const [],
  });

  // ── Computed properties ────────────────────────────────────────

  bool get hasDiscount => discountAmount > 0;

  bool get isAccepted => status?.toLowerCase() == 'accepted';

  bool get isRejected => status?.toLowerCase() == 'rejected';

  bool get isPending =>
      status?.toLowerCase() == 'pending' || status?.toLowerCase() == 'sent';

  /// Only pending offers can be accepted.
  bool get canAccept => isPending;

  /// Only pending offers can be rejected.
  bool get canReject => isPending;

  bool get hasAttachment => pdfUrl != null && pdfUrl!.isNotEmpty;

  OfferLocation? get originLocation => locations.where(
    (l) => l.locationType?.toLowerCase() == 'origin',
  ).firstOrNull;

  OfferLocation? get destinationLocation => locations.where(
    (l) => l.locationType?.toLowerCase() == 'destination',
  ).firstOrNull;

  bool get hasMultipleLocations => locations.length > 1;
}
