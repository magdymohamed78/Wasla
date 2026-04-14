import 'session_state.dart';

class RoleResolver {
  const RoleResolver();

  SessionRole resolve({required String? token, required int? customerId}) {
    if (token == null || token.isEmpty) {
      return SessionRole.guest;
    }

    if (customerId == null) {
      return SessionRole.lead;
    }

    return SessionRole.customer;
  }

  SessionRole resolveForUser(SessionUser? user) {
    return resolve(token: user?.token, customerId: user?.customerId);
  }
}
