import '../../domain/entities/update_portal_profile_input.dart';

class UpdateCustomerProfileDto {
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? country;

  const UpdateCustomerProfileDto({
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.address,
    this.city,
    this.zipCode,
    this.country,
  });

  factory UpdateCustomerProfileDto.fromDomain(UpdatePortalProfileInput input) {
    String? normalize(String? value) {
      final trimmed = value?.trim() ?? '';
      return trimmed.isEmpty ? null : trimmed;
    }

    return UpdateCustomerProfileDto(
      firstName: input.firstName.trim(),
      lastName: input.lastName.trim(),
      phoneNumber: normalize(input.phoneNumber),
      address: normalize(input.address),
      city: normalize(input.city),
      zipCode: normalize(input.zipCode),
      country: normalize(input.country),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'zipCode': zipCode,
      'country': country,
    };
  }
}
