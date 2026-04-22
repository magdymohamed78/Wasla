import 'session_state.dart';
import 'token_claims_parser.dart';

class RoleResolver {
  final TokenClaimsParser _tokenClaimsParser;

  const RoleResolver({TokenClaimsParser? tokenClaimsParser})
    : _tokenClaimsParser = tokenClaimsParser ?? const TokenClaimsParser();

  SessionRole resolveForToken(String? token) {
    if (token == null || token.isEmpty) {
      return SessionRole.guest;
    }

    final claims = _tokenClaimsParser.parse(token);
    if (claims?.hasCustomerClaim == true) {
      return SessionRole.customer;
    }

    return SessionRole.lead;
  }

  bool hasCustomerAccess(String? token) {
    return resolveForToken(token) == SessionRole.customer;
  }

  int? customerIdFromToken(String? token) {
    return _tokenClaimsParser.parse(token)?.customerId;
  }

  SessionRole resolveForUser(SessionUser? user) {
    return resolveForToken(user?.token);
  }
}
