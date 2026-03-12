import '../../domain/entities/login_entity.dart';

enum RegisterStatus { initial, loading, success, failure }

enum RegisterErrorCategory { field, server, network }

enum RegisterErrorCode {
  emailAlreadyRegistered,
  validationError,
  badRequest,
  networkError,
  serverError,
  unexpectedError,
  missingSignature,
}

class RegisterState {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String password;
  final String confirmPassword;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final RegisterStatus status;
  final RegisterErrorCode? errorCode;
  final RegisterErrorCategory? errorCategory;
  final LoginEntity? user;
  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? phoneError;
  final bool hasSubmitted;
  final bool firstNameTouched;
  final bool lastNameTouched;
  final bool phoneTouched;
  final bool emailTouched;
  final bool passwordTouched;
  final bool confirmPasswordTouched;
  final String? serverErrorMessage;
  final String? digitalSignature;

  const RegisterState({
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.status = RegisterStatus.initial,
    this.errorCode,
    this.errorCategory,
    this.user,
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.phoneError,
    this.hasSubmitted = false,
    this.firstNameTouched = false,
    this.lastNameTouched = false,
    this.phoneTouched = false,
    this.emailTouched = false,
    this.passwordTouched = false,
    this.confirmPasswordTouched = false,
    this.serverErrorMessage,
    this.digitalSignature,
  });

  RegisterState copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? password,
    String? confirmPassword,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    RegisterStatus? status,
    RegisterErrorCode? errorCode,
    RegisterErrorCategory? errorCategory,
    LoginEntity? user,
    String? firstNameError,
    String? lastNameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? phoneError,
    bool? hasSubmitted,
    bool? firstNameTouched,
    bool? lastNameTouched,
    bool? phoneTouched,
    bool? emailTouched,
    bool? passwordTouched,
    bool? confirmPasswordTouched,
    String? serverErrorMessage,
    String? digitalSignature,
  }) {
    return RegisterState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      status: status ?? this.status,
      errorCode: errorCode,
      errorCategory: errorCategory,
      user: user ?? this.user,
      firstNameError: firstNameError,
      lastNameError: lastNameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      phoneError: phoneError,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      firstNameTouched: firstNameTouched ?? this.firstNameTouched,
      lastNameTouched: lastNameTouched ?? this.lastNameTouched,
      phoneTouched: phoneTouched ?? this.phoneTouched,
      emailTouched: emailTouched ?? this.emailTouched,
      passwordTouched: passwordTouched ?? this.passwordTouched,
      confirmPasswordTouched: confirmPasswordTouched ?? this.confirmPasswordTouched,
      serverErrorMessage: serverErrorMessage,
      digitalSignature: digitalSignature ?? this.digitalSignature,
    );
  }
}
