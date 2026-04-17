import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_cubit.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/domain/entities/login_entity.dart';
import '../../../home/domain/entities/update_portal_profile_input.dart';
import 'profile_edit_state.dart';

class ProfileEditFields {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;
  final String city;
  final String zipCode;
  final String country;
  final DateTime? createdAt;

  const ProfileEditFields({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phoneNumber = '',
    this.address = '',
    this.city = '',
    this.zipCode = '',
    this.country = '',
    this.createdAt,
  });
}

typedef ProfileLoader = Future<ProfileEditFields> Function();
typedef ProfileSaver =
    Future<ProfileEditFields> Function(UpdatePortalProfileInput input);

class ProfileEditCubit extends Cubit<ProfileEditState> {
  final ProfileLoader _loader;
  final ProfileSaver _saver;
  final SessionCubit _sessionCubit;

  ProfileEditCubit({
    required ProfileLoader loader,
    required ProfileSaver saver,
    required SessionCubit sessionCubit,
  }) : _loader = loader,
       _saver = saver,
       _sessionCubit = sessionCubit,
       super(const ProfileEditState());

  Future<void> load() async {
    emit(
      state.copyWith(
        status: ProfileEditStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final profile = await _loader();
      emit(
        state.copyWith(
          status: ProfileEditStatus.initial,
          createdAt: profile.createdAt,
          firstName: profile.firstName,
          lastName: profile.lastName,
          email: profile.email,
          phoneNumber: profile.phoneNumber,
          address: profile.address,
          city: profile.city,
          zipCode: profile.zipCode,
          country: profile.country,
          clearFirstNameError: true,
          clearLastNameError: true,
          clearPhoneError: true,
          clearErrorMessage: true,
          hasSubmitted: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileEditStatus.failure,
          errorMessage: 'profile_load_failed',
        ),
      );
    }
  }

  void firstNameChanged(String value) {
    final error = state.hasSubmitted ? Validators.validateName(value) : null;
    emit(
      state.copyWith(
        firstName: value,
        firstNameError: error,
        clearFirstNameError: !state.hasSubmitted || error == null,
        clearErrorMessage: true,
      ),
    );
  }

  void lastNameChanged(String value) {
    final error = state.hasSubmitted ? Validators.validateName(value) : null;
    emit(
      state.copyWith(
        lastName: value,
        lastNameError: error,
        clearLastNameError: !state.hasSubmitted || error == null,
        clearErrorMessage: true,
      ),
    );
  }

  void phoneChanged(String value) {
    final error = state.hasSubmitted ? Validators.validatePhone(value) : null;
    emit(
      state.copyWith(
        phoneNumber: value,
        phoneError: error,
        clearPhoneError: !state.hasSubmitted || error == null,
        clearErrorMessage: true,
      ),
    );
  }

  void addressChanged(String value) {
    emit(state.copyWith(address: value, clearErrorMessage: true));
  }

  void cityChanged(String value) {
    emit(state.copyWith(city: value, clearErrorMessage: true));
  }

  void zipCodeChanged(String value) {
    emit(state.copyWith(zipCode: value, clearErrorMessage: true));
  }

  void countryChanged(String value) {
    emit(state.copyWith(country: value, clearErrorMessage: true));
  }

  Future<void> save() async {
    final firstError = Validators.validateName(state.firstName);
    final lastError = Validators.validateName(state.lastName);
    final phoneError = Validators.validatePhone(state.phoneNumber);

    if (firstError != null || lastError != null || phoneError != null) {
      emit(
        state.copyWith(
          status: ProfileEditStatus.initial,
          firstNameError: firstError,
          lastNameError: lastError,
          phoneError: phoneError,
          hasSubmitted: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ProfileEditStatus.saving,
        clearErrorMessage: true,
        hasSubmitted: true,
      ),
    );

    try {
      final input = UpdatePortalProfileInput(
        firstName: state.firstName,
        lastName: state.lastName,
        phoneNumber: state.phoneNumber,
        address: state.address,
        city: state.city,
        zipCode: state.zipCode,
        country: state.country,
      );

      final updated = await _saver(input);

      await _syncSessionName(
        firstName: updated.firstName,
        lastName: updated.lastName,
        email: updated.email,
      );

      emit(
        state.copyWith(
          status: ProfileEditStatus.success,
          createdAt: updated.createdAt,
          firstName: updated.firstName,
          lastName: updated.lastName,
          email: updated.email,
          phoneNumber: updated.phoneNumber,
          address: updated.address,
          city: updated.city,
          zipCode: updated.zipCode,
          country: updated.country,
          clearFirstNameError: true,
          clearLastNameError: true,
          clearPhoneError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileEditStatus.failure,
          errorMessage: 'profile_update_failed',
        ),
      );
    }
  }

  Future<void> _syncSessionName({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final currentUser = _sessionCubit.state.user;
    if (currentUser == null) {
      return;
    }

    final refreshed = LoginEntity(
      token: currentUser.token,
      refreshToken: currentUser.refreshToken,
      refreshTokenExpiry: currentUser.refreshTokenExpiry,
      userId: currentUser.userId,
      customerId: currentUser.customerId,
      leadId: currentUser.leadId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      digitalSignature: currentUser.digitalSignature,
    );

    await _sessionCubit.syncRefreshedSession(refreshed);
  }
}
