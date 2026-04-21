import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_cubit.dart';
import '../../../../core/session/session_state.dart';
import '../../../../features/home/domain/use_cases/customer_profile_use_cases.dart';
import '../../../../features/home/domain/use_cases/lead_profile_use_cases.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SessionCubit _sessionCubit;
  final GetCustomerProfileUseCase? _getCustomerProfileUseCase;
  final GetLeadProfileUseCase? _getLeadProfileUseCase;
  StreamSubscription<SessionState>? _sessionSubscription;

  SettingsCubit({
    required SessionCubit sessionCubit,
    GetCustomerProfileUseCase? getCustomerProfileUseCase,
    GetLeadProfileUseCase? getLeadProfileUseCase,
  }) : _sessionCubit = sessionCubit,
       _getCustomerProfileUseCase = getCustomerProfileUseCase,
       _getLeadProfileUseCase = getLeadProfileUseCase,
       super(const SettingsState()) {
    _syncFromSession(_sessionCubit.state);
    _sessionSubscription = _sessionCubit.stream.listen(_syncFromSession);
  }

  Future<void> loadProfile() async {
    final role = _sessionCubit.state.role;

    emit(state.copyWith(isLoading: true));

    try {
      if (role == SessionRole.customer && _getCustomerProfileUseCase != null) {
        final profile = await _getCustomerProfileUseCase();
        emit(
          state.copyWith(
            firstName: profile.firstName?.trim() ?? '',
            lastName: profile.lastName?.trim() ?? '',
            fullName: _buildFullName(
              _capitalizeNamePart(profile.firstName ?? ''),
              _capitalizeNamePart(profile.lastName ?? ''),
            ),
            initials: _buildInitials(
              _capitalizeNamePart(profile.firstName ?? ''),
              _capitalizeNamePart(profile.lastName ?? ''),
            ),
            isLoading: false,
          ),
        );
        return;
      }

      if (role == SessionRole.lead && _getLeadProfileUseCase != null) {
        final profile = await _getLeadProfileUseCase();
        emit(
          state.copyWith(
            firstName: profile.firstName?.trim() ?? '',
            lastName: profile.lastName?.trim() ?? '',
            fullName: _buildFullName(
              _capitalizeNamePart(profile.firstName ?? ''),
              _capitalizeNamePart(profile.lastName ?? ''),
            ),
            initials: _buildInitials(
              _capitalizeNamePart(profile.firstName ?? ''),
              _capitalizeNamePart(profile.lastName ?? ''),
            ),
            isLoading: false,
          ),
        );
        return;
      }
    } catch (_) {
      // Keep session-synced data on failure
    }

    emit(state.copyWith(isLoading: false));
  }

  void reload() {
    _syncFromSession(_sessionCubit.state);
  }

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    return super.close();
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
