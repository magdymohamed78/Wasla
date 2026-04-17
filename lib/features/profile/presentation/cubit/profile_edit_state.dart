enum ProfileEditStatus { initial, loading, saving, success, failure }

class ProfileEditState {
  final ProfileEditStatus status;
  final DateTime? createdAt;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;
  final String city;
  final String zipCode;
  final String country;
  final String? firstNameError;
  final String? lastNameError;
  final String? phoneError;
  final String? errorMessage;
  final bool hasSubmitted;

  const ProfileEditState({
    this.status = ProfileEditStatus.initial,
    this.createdAt,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phoneNumber = '',
    this.address = '',
    this.city = '',
    this.zipCode = '',
    this.country = '',
    this.firstNameError,
    this.lastNameError,
    this.phoneError,
    this.errorMessage,
    this.hasSubmitted = false,
  });

  bool get isLoading => status == ProfileEditStatus.loading;

  bool get isSaving => status == ProfileEditStatus.saving;

  ProfileEditState copyWith({
    ProfileEditStatus? status,
    DateTime? createdAt,
    bool clearCreatedAt = false,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? address,
    String? city,
    String? zipCode,
    String? country,
    String? firstNameError,
    bool clearFirstNameError = false,
    String? lastNameError,
    bool clearLastNameError = false,
    String? phoneError,
    bool clearPhoneError = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? hasSubmitted,
  }) {
    return ProfileEditState(
      status: status ?? this.status,
      createdAt: clearCreatedAt ? null : (createdAt ?? this.createdAt),
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      firstNameError: clearFirstNameError
          ? null
          : (firstNameError ?? this.firstNameError),
      lastNameError: clearLastNameError
          ? null
          : (lastNameError ?? this.lastNameError),
      phoneError: clearPhoneError ? null : (phoneError ?? this.phoneError),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }
}
