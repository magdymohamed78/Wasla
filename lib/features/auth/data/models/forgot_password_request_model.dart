/// Data model for the forgot password API request body.
///
/// Maps to: `POST /api/Auth/forgot-password`
/// ```json
/// { "email": "string" }
/// ```
class ForgotPasswordRequestModel {
  final String email;

  const ForgotPasswordRequestModel({
    required this.email,
  });

  /// Converts this model to a JSON map for the API request.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
