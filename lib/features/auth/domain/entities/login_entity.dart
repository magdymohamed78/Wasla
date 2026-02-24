/// Entity representing a successful login response.
///
/// Contains user identity information and authentication token.
/// Part of the domain layer — no framework dependencies.
class LoginEntity {
  final String token;
  final String? refreshToken;
  final String? refreshTokenExpiry;
  final int userId;
  final int? customerId;
  final int? leadId;
  final String firstName;
  final String lastName;
  final String email;

  const LoginEntity({
    required this.token,
    this.refreshToken,
    this.refreshTokenExpiry,
    required this.userId,
    this.customerId,
    this.leadId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}
