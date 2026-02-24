import '../../domain/entities/login_entity.dart';

/// Data model for the refresh token API success response.
///
/// Maps from the JSON response to [LoginEntity].
/// ```json
/// {
///   "token": "string",
///   "refreshToken": "string",
///   "refreshTokenExpiry": "datetime",
///   "userId": 0,
///   "customerId": 0,
///   "leadId": 0,
///   "firstName": "string",
///   "lastName": "string",
///   "email": "string"
/// }
/// ```
class RefreshTokenResponseModel {
  final String token;
  final String refreshToken;
  final String refreshTokenExpiry;
  final int userId;
  final int? customerId;
  final int? leadId;
  final String firstName;
  final String lastName;
  final String email;

  const RefreshTokenResponseModel({
    required this.token,
    required this.refreshToken,
    required this.refreshTokenExpiry,
    required this.userId,
    this.customerId,
    this.leadId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  /// Creates a [RefreshTokenResponseModel] from a JSON map.
  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      refreshTokenExpiry: json['refreshTokenExpiry'] as String,
      userId: json['userId'] as int,
      customerId: json['customerId'] as int?,
      leadId: json['leadId'] as int?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
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
    );
  }
}
