/// Parses the optional response body from the accept offer endpoint.
///
/// - **COD**: Body may be empty or absent — [checkoutUrl] will be null.
/// - **Online**: Body contains a `checkoutUrl` string for Stripe checkout.
class AcceptOfferResponseDto {
  final String? checkoutUrl;

  const AcceptOfferResponseDto({this.checkoutUrl});

  factory AcceptOfferResponseDto.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AcceptOfferResponseDto();
    }
    final raw = json['checkoutUrl'];
    return AcceptOfferResponseDto(
      checkoutUrl: (raw is String && raw.trim().isNotEmpty) ? raw.trim() : null,
    );
  }
}
