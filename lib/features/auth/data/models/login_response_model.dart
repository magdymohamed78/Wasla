import '../../domain/entities/login_entity.dart';

/// Data model for the login API success response.
///
/// Maps from the JSON response to [LoginEntity].
/// ```json
/// {
///   "token": "string",
///   "refreshToken": "string | null",
///   "refreshTokenExpiry": "datetime | null",
///   "userId": 0,
///   "customerId": 0,
///   "leadId": 0,
///   "firstName": "string",
///   "lastName": "string",
///   "email": "string"
/// }
/// ```
class LoginResponseModel {
  final String token;
  final String? refreshToken;
  final String? refreshTokenExpiry;
  final int userId;
  final int? customerId;
  final int? leadId; 
  final String firstName;
  final String lastName;
  final String email;
  final String? digitalSignature;

  const LoginResponseModel({
    required this.token,
    this.refreshToken,
    this.refreshTokenExpiry,
    required this.userId,
    this.customerId,
    this.leadId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.digitalSignature,
  });

  /// Creates a [LoginResponseModel] from a JSON map.
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      refreshTokenExpiry: json['refreshTokenExpiry'] as String?,
      userId: json['userId'] as int,
      customerId: json['customerId'] as int?,
      leadId: json['leadId'] as int?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      digitalSignature: json['digitalSignature'] as String?,
    );
  }

  /// Converts this data model to a domain [LoginEntity].
  LoginEntity toEntity() {
    return LoginEntity(
      token: token,
      refreshToken: refreshToken,
      refreshTokenExpiry: refreshTokenExpiry,
      userId: userId,
      customerId: customerId,
      leadId: leadId, 
      firstName: firstName,
      lastName: lastName,
      email: email,
      digitalSignature: digitalSignature,
    );
  }
}
