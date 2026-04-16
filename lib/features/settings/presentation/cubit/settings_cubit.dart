import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_state.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SessionCubit _sessionCubit;

  SettingsCubit({required SessionCubit sessionCubit})
    : _sessionCubit = sessionCubit,
      super(const SettingsState()) {
    _syncFromSession(_sessionCubit.state);
  }

  void _syncFromSession(SessionState sessionState) {
    final user = sessionState.user;
    final firstName = _capitalizeNamePart(user?.firstName ?? '');
    final lastName = _capitalizeNamePart(user?.lastName ?? '');
    final fullName = _buildFullName(firstName, lastName);
    final initials = _buildInitials(firstName, lastName);

    emit(
      SettingsState(
        firstName: firstName,
        lastName: lastName,
        fullName: fullName,
        initials: initials,
        role: sessionState.role,
      ),
    );
  }

  String _buildFullName(String firstName, String lastName) {
    final parts = [firstName, lastName].where((p) => p.isNotEmpty);
    return parts.isEmpty ? '' : parts.join(' ');
  }

  String _capitalizeNamePart(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';

    return trimmed
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(_capitalizeWord)
        .join(' ');
  }

  String _capitalizeWord(String word) {
    if (word.isEmpty) return '';
    final first = word[0].toUpperCase();
    final rest = word.length > 1 ? word.substring(1).toLowerCase() : '';
    return '$first$rest';
  }

  String _buildInitials(String firstName, String lastName) {
    if (firstName.isNotEmpty) {
      return firstName[0].toUpperCase();
    }
    if (lastName.isNotEmpty) {
      return lastName[0].toUpperCase();
    }
    return '';
  }
}
