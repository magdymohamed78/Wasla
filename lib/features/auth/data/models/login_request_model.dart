/// Data model for the login API request body.
///
/// Maps to: `POST /api/customer-portal/login`
/// ```json
/// { "email": "string", "password": "string", "rememberMe": "boolean" }
/// ```
class LoginRequestModel {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequestModel({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  /// Converts this model to a JSON map for the API request.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'rememberMe': rememberMe,
    };
  }
}
