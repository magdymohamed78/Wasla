import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_cubit.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/domain/entities/login_entity.dart';
import '../../../home/domain/entities/customer_portal_content.dart';
import '../../../home/domain/use_cases/customer_portal_use_cases.dart';
import 'customer_profile_edit_state.dart';

class CustomerProfileEditCubit extends Cubit<CustomerProfileEditState> {
  final GetCustomerProfileUseCase _getCustomerProfileUseCase;
  final UpdateCustomerProfileUseCase _updateCustomerProfileUseCase;
  final SessionCubit _sessionCubit;

  CustomerProfileEditCubit({
    required GetCustomerProfileUseCase getCustomerProfileUseCase,
    required UpdateCustomerProfileUseCase updateCustomerProfileUseCase,
    required SessionCubit sessionCubit,
  }) : _getCustomerProfileUseCase = getCustomerProfileUseCase,
       _updateCustomerProfileUseCase = updateCustomerProfileUseCase,
       _sessionCubit = sessionCubit,
       super(const CustomerProfileEditState());

  Future<void> load() async {
    emit(
      state.copyWith(
        status: CustomerProfileEditStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final profile = await _getCustomerProfileUseCase();
      emit(
        state.copyWith(
          status: CustomerProfileEditStatus.initial,
          profile: profile,
          firstName: profile.firstName ?? '',
          lastName: profile.lastName ?? '',
          email: profile.email ?? '',
          phoneNumber: profile.phoneNumber ?? '',
          address: profile.address ?? '',
          city: profile.city ?? '',
          zipCode: profile.zipCode ?? '',
          country: profile.country ?? '',
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
          status: CustomerProfileEditStatus.failure,
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
          status: CustomerProfileEditStatus.initial,
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
        status: CustomerProfileEditStatus.saving,
        clearErrorMessage: true,
        hasSubmitted: true,
      ),
    );

    try {
      final updated = await _updateCustomerProfileUseCase(
        UpdatePortalProfileInput(
          firstName: state.firstName,
          lastName: state.lastName,
          phoneNumber: state.phoneNumber,
          address: state.address,
          city: state.city,
          zipCode: state.zipCode,
          country: state.country,
        ),
      );

      await _syncSessionName(
        firstName: updated.firstName ?? state.firstName,
        lastName: updated.lastName ?? state.lastName,
        email: updated.email ?? state.email,
      );

      emit(
        state.copyWith(
          status: CustomerProfileEditStatus.success,
          profile: updated,
          firstName: updated.firstName ?? '',
          lastName: updated.lastName ?? '',
          email: updated.email ?? '',
          phoneNumber: updated.phoneNumber ?? '',
          address: updated.address ?? '',
          city: updated.city ?? '',
          zipCode: updated.zipCode ?? '',
          country: updated.country ?? '',
          clearFirstNameError: true,
          clearLastNameError: true,
          clearPhoneError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CustomerProfileEditStatus.failure,
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
