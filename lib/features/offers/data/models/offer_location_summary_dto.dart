import '../../../home/data/models/json_helpers.dart';
import '../../domain/entities/offer_location.dart';

/// Data transfer object for [OfferLocationSummaryDto] from the API.
class OfferLocationSummaryDto {
  final String? locationType;
  final int addressIndex;
  final String? street;
  final String? zipCode;
  final String? city;
  final String? countryCode;
  final String? buildingType;
  final String? floor;
  final bool? hasLift;

  const OfferLocationSummaryDto({
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

  factory OfferLocationSummaryDto.fromJson(Map<String, dynamic> json) {
    return OfferLocationSummaryDto(
      locationType: asString(json['locationType']),
      addressIndex: asInt(json['addressIndex']),
      street: asString(json['street']),
      zipCode: asString(json['zipCode']),
      city: asString(json['city']),
      countryCode: asString(json['countryCode']),
      buildingType: asString(json['buildingType']),
      floor: asString(json['floor']),
      hasLift: json['hasLift'] as bool?,
    );
  }

  OfferLocation toDomain() {
    return OfferLocation(
      locationType: locationType,
      addressIndex: addressIndex,
      street: street,
      zipCode: zipCode,
      city: city,
      countryCode: countryCode,
      buildingType: buildingType,
      floor: floor,
      hasLift: hasLift,
    );
  }
}
