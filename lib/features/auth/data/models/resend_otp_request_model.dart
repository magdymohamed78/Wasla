/// Data model for the resend OTP API request body.
///
/// Maps to: `POST /api/Auth/resend-otp`
/// ```json
/// { "email": "string" }
/// ```
class ResendOtpRequestModel {
  final String email;

  const ResendOtpRequestModel({
    required this.email,
  });

  /// Converts this model to a JSON map for the API request.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
