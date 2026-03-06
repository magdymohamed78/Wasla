/// Data model for the reset password API request body.
///
/// Maps to: `POST /api/Auth/reset-password`
/// ```json
/// {
///   "email": "string",
///   "otp": "string",
///   "newPassword": "string",
///   "confirmNewPassword": "string"
/// }
/// ```
class ResetPasswordRequestModel {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmNewPassword;

  const ResetPasswordRequestModel({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  /// Converts this model to a JSON map for the API request.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    };
  }
}
