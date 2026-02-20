import '../../domain/entities/login_entity.dart';

/// Data model for the login API success response.
///
/// Maps from the JSON response to [LoginEntity].
/// ```json
/// {
///   "token": "string",
///   "userId": 0,
///   "customerId": 0,
///   "firstName": "string",
///   "lastName": "string",
///   "email": "string"
/// }
/// ```
class LoginResponseModel {
  final String token;
  final int userId;
  final int customerId;
  final String firstName;
  final String lastName;
  final String email;

  const LoginResponseModel({
    required this.token,
    required this.userId,
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  /// Creates a [LoginResponseModel] from a JSON map.
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String,
      userId: json['userId'] as int,
      customerId: json['customerId'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
    );
  }

  /// Converts this data model to a domain [LoginEntity].
  LoginEntity toEntity() {
    return LoginEntity(
      token: token,
      userId: userId,
      customerId: customerId,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }
}
