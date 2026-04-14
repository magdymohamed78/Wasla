enum SessionRole { guest, lead, customer }

enum SessionLifecycleStatus { initial, loading, ready, failure }

enum PendingActionType { requestService }

class SessionUser {
  static const Object _unset = Object();

  final String token;
  final String? refreshToken;
  final String? refreshTokenExpiry;
  final int userId;
  final int? leadId;
  final int? customerId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? digitalSignature;

  const SessionUser({
    required this.token,
    this.refreshToken,
    this.refreshTokenExpiry,
    required this.userId,
    this.leadId,
    this.customerId,
    this.firstName,
    this.lastName,
    this.email,
    this.digitalSignature,
  });

  bool get hasToken => token.isNotEmpty;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'token': token,
      'refreshToken': refreshToken,
      'refreshTokenExpiry': refreshTokenExpiry,
      'userId': userId,
      'leadId': leadId,
      'customerId': customerId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'digitalSignature': digitalSignature,
    };
  }

  SessionUser copyWith({
    String? token,
    Object? refreshToken = _unset,
    Object? refreshTokenExpiry = _unset,
    int? userId,
    Object? leadId = _unset,
    Object? customerId = _unset,
    Object? firstName = _unset,
    Object? lastName = _unset,
    Object? email = _unset,
    Object? digitalSignature = _unset,
  }) {
    return SessionUser(
      token: token ?? this.token,
      refreshToken: identical(refreshToken, _unset)
          ? this.refreshToken
          : refreshToken as String?,
      refreshTokenExpiry: identical(refreshTokenExpiry, _unset)
          ? this.refreshTokenExpiry
          : refreshTokenExpiry as String?,
      userId: userId ?? this.userId,
      leadId: identical(leadId, _unset) ? this.leadId : leadId as int?,
      customerId: identical(customerId, _unset)
          ? this.customerId
          : customerId as int?,
      firstName: identical(firstName, _unset)
          ? this.firstName
          : firstName as String?,
      lastName: identical(lastName, _unset)
          ? this.lastName
          : lastName as String?,
      email: identical(email, _unset) ? this.email : email as String?,
      digitalSignature: identical(digitalSignature, _unset)
          ? this.digitalSignature
          : digitalSignature as String?,
    );
  }
}

class PendingIntent {
  static const Object _unset = Object();

  final PendingActionType action;
  final int companyId;
  final DateTime createdAt;
  final String? sourceRoute;

  const PendingIntent({
    required this.action,
    required this.companyId,
    required this.createdAt,
    this.sourceRoute,
  });

  bool get isValidForContinuation {
    return action == PendingActionType.requestService && companyId > 0;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'action': action.name,
      'companyId': companyId,
      'createdAt': createdAt.toIso8601String(),
      'sourceRoute': sourceRoute,
    };
  }

  factory PendingIntent.fromJson(Map<String, dynamic> json) {
    final actionRaw = json['action']?.toString();
    final action = PendingActionType.values
        .where((item) => item.name == actionRaw)
        .toList();
    if (action.isEmpty) {
      throw const FormatException('Unsupported pending intent action');
    }

    final companyIdRaw = json['companyId'];
    final companyId = companyIdRaw is int
        ? companyIdRaw
        : int.tryParse(companyIdRaw?.toString() ?? '');

    return PendingIntent(
      action: action.first,
      companyId: companyId ?? -1,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      sourceRoute: json['sourceRoute'] as String?,
    );
  }

  PendingIntent copyWith({
    PendingActionType? action,
    int? companyId,
    DateTime? createdAt,
    Object? sourceRoute = _unset,
  }) {
    return PendingIntent(
      action: action ?? this.action,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
      sourceRoute: identical(sourceRoute, _unset)
          ? this.sourceRoute
          : sourceRoute as String?,
    );
  }
}

class SessionState {
  static const Object _unset = Object();

  final SessionLifecycleStatus status;
  final SessionUser? user;
  final SessionRole role;
  final bool isRefreshingToken;
  final int refreshAttemptCount;
  final String? lastAuthError;
  final PendingIntent? pendingIntent;

  const SessionState({
    this.status = SessionLifecycleStatus.initial,
    this.user,
    this.role = SessionRole.guest,
    this.isRefreshingToken = false,
    this.refreshAttemptCount = 0,
    this.lastAuthError,
    this.pendingIntent,
  });

  bool get isAuthenticated => user?.hasToken ?? false;

  bool get hasPendingIntent => pendingIntent != null;

  bool get canAttemptRefresh => refreshAttemptCount < 1;

  SessionState copyWith({
    SessionLifecycleStatus? status,
    Object? user = _unset,
    SessionRole? role,
    bool? isRefreshingToken,
    int? refreshAttemptCount,
    Object? lastAuthError = _unset,
    Object? pendingIntent = _unset,
  }) {
    return SessionState(
      status: status ?? this.status,
      user: identical(user, _unset) ? this.user : user as SessionUser?,
      role: role ?? this.role,
      isRefreshingToken: isRefreshingToken ?? this.isRefreshingToken,
      refreshAttemptCount: refreshAttemptCount ?? this.refreshAttemptCount,
      lastAuthError: identical(lastAuthError, _unset)
          ? this.lastAuthError
          : lastAuthError as String?,
      pendingIntent: identical(pendingIntent, _unset)
          ? this.pendingIntent
          : pendingIntent as PendingIntent?,
    );
  }
}
