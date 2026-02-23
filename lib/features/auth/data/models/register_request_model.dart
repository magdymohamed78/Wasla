class RegisterRequestModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;

  const RegisterRequestModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      json['phoneNumber'] = phoneNumber!;
    }
    return json;
  }
}
