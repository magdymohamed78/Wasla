import '../../../../core/session/session_state.dart';

class SettingsState {
  final String? firstName;
  final String? lastName;
  final String fullName;
  final String initials;
  final SessionRole role;

  const SettingsState({
    this.firstName,
    this.lastName,
    this.fullName = '',
    this.initials = '',
    this.role = SessionRole.guest,
  });

  SettingsState copyWith({
    String? firstName,
    String? lastName,
    String? fullName,
    String? initials,
    SessionRole? role,
  }) {
    return SettingsState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      initials: initials ?? this.initials,
      role: role ?? this.role,
    );
  }
}
