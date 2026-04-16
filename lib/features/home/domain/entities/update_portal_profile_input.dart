class UpdatePortalProfileInput {
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? country;

  const UpdatePortalProfileInput({
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.address,
    this.city,
    this.zipCode,
    this.country,
  });
}
