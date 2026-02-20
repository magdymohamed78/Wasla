/// Entity representing a successful login response.
///
/// Contains user identity information and authentication token.
/// Part of the domain layer — no framework dependencies.
class LoginEntity {
  final String token;
  final int userId;
  final int customerId;
  final String firstName;
  final String lastName;
  final String email;

  const LoginEntity({
    required this.token,
    required this.userId,
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}
