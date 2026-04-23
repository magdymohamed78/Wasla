/// Domain entity representing a location in an offer
/// (origin, destination, or generic).
class OfferLocation {
  final String? locationType;
  final int addressIndex;
  final String? street;
  final String? zipCode;
  final String? city;
  final String? countryCode;
  final String? buildingType;
  final String? floor;
  final bool? hasLift;

  const OfferLocation({
    this.locationType,
    this.addressIndex = 0,
    this.street,
    this.zipCode,
    this.city,
    this.countryCode,
    this.buildingType,
    this.floor,
    this.hasLift,
  });

  /// Returns a display title for the location card header.
  /// Known types ("Origin", "Destination") are used directly;
  /// unknown or null types fall back to "Location".
  String get displayTitle {
    final type = locationType?.trim().toLowerCase();
    if (type == 'origin') return 'Origin';
    if (type == 'destination') return 'Destination';
    return 'Location';
  }

  /// Joins non-null address parts (street, city, countryCode) with ", ".
  String get formattedAddress {
    return [street, city, countryCode]
        .where((part) => part != null && part.trim().isNotEmpty)
        .join(', ');
  }
}
