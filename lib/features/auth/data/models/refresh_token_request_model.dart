/// Data model for the refresh token API request body.
///
/// Maps to: `POST /api/customer-portal/refresh-token`
/// ```json
/// { "refreshToken": "string" }
/// ```
class RefreshTokenRequestModel {
  final String refreshToken;

  const RefreshTokenRequestModel({
    required this.refreshToken,
  });

  /// Converts this model to a JSON map for the API request.
  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}
