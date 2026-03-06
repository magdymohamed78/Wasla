// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'AppLocalizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingLogIn => 'Log In';

  @override
  String get onboardingNewUser => 'New User';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get supportPageTitle => 'Support';

  @override
  String get supportPageDescription =>
      'For support, please contact us at support@wasla.com';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginRememberMe => 'Remember me';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginSignIn => 'Sign In';

  @override
  String get loginSignUp => 'Don\'t have an account? Sign Up';

  @override
  String get loginSignUpAction => 'Sign Up';

  @override
  String get loginInvalidCredentials => 'Invalid email or password';

  @override
  String get loginEmailRequired => 'Email is required';

  @override
  String get loginPasswordRequired => 'Password is required';

  @override
  String get loginEmailInvalid => 'Please enter a valid email';

  @override
  String get loginUnexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get loginNoConnection =>
      'No internet connection. Please check your network.';

  @override
  String get loginRateLimited => 'Too many attempts. Please try again later.';

  @override
  String get loginSessionExpired => 'Session expired. Please sign in again.';

  @override
  String get loginErrorInvalidCredentials =>
      'Invalid credentials or inactive account.';

  @override
  String get loginErrorAccountNotSetup =>
      'Your account is not fully set up. Please contact support for help.';

  @override
  String get loginErrorRateLimit =>
      'Too many login attempts. Please try again later.';

  @override
  String get loginErrorNetwork =>
      'No internet connection. Please check your network and try again.';

  @override
  String get loginErrorServer =>
      'An unexpected error occurred. Please try again later.';

  @override
  String get forgotPasswordTitle => 'Forget Password ?';

  @override
  String get forgotPasswordDescription =>
      'Don\'t worry! It occurs. Please enter the email address linked with your account.';

  @override
  String get forgotPasswordEmailLabel => 'Enter Your Email Address';

  @override
  String get forgotPasswordEmailPlaceholder => 'yourmail@gmail.com';

  @override
  String get forgotPasswordSend => 'Send';

  @override
  String get forgotPasswordSuccess => 'Reset link sent successfully';

  @override
  String get forgotPasswordEmailRequired => 'Email is required';

  @override
  String get forgotPasswordEmailInvalid => 'Please enter a valid email';

  @override
  String get signUpTitle => 'Sign Up';

  @override
  String get signUpFirstName => 'First Name';

  @override
  String get signUpLastName => 'Last Name';

  @override
  String get signUpPhoneNumber => 'Phone Number';

  @override
  String get signUpEmail => 'Email Address';

  @override
  String get signUpEmailHint => 'youremail@gmail.com';

  @override
  String get signUpPassword => 'Password';

  @override
  String get signUpConfirmPassword => 'Confirm Password';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get signUpHaveAccount => 'Already have an account? Log In';

  @override
  String get signUpHaveAccountAction => 'Log In';

  @override
  String get signUpFirstNameRequired => 'First name is required';

  @override
  String get signUpLastNameRequired => 'Last name is required';

  @override
  String get signUpNameTooLong => 'Must be 100 characters or less';

  @override
  String get signUpPhoneTooLong => 'Must be 50 characters or less';

  @override
  String get signUpEmailRequired => 'Email is required';

  @override
  String get signUpEmailInvalid => 'Enter a valid email address';

  @override
  String get signUpPasswordRequired => 'Password is required';

  @override
  String get signUpPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get signUpConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get signUpConfirmPasswordMismatch => 'Passwords do not match';

  @override
  String get signUpErrorEmailInUse => 'This email is already registered';

  @override
  String get signUpErrorServer =>
      'Something went wrong. Please try again later.';

  @override
  String get signUpErrorNetwork =>
      'No internet connection. Please check your network.';

  @override
  String get signUpErrorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String get signUpSuccessMessage => 'You are successfully registered!';

  @override
  String get signUpSuccessButton => 'Let\'s Start';

  @override
  String get networkErrorNoConnection => 'No internet connection';

  @override
  String get networkErrorRetry => 'Retry';

  @override
  String get networkErrorServer => 'Server error. Please try again later.';

  @override
  String get otpVerificationTitle => 'Change Password';

  @override
  String get otpVerificationDescription =>
      'Enter the OTP sent to your email to proceed.';

  @override
  String otpVerificationTimerText(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get otpVerificationResend => 'Resend OTP';

  @override
  String get otpVerificationVerify => 'Verify';

  @override
  String get otpVerificationOtpRequired => 'Please enter the OTP code';

  @override
  String get otpVerificationOtpInvalid => 'Please enter a valid 6-digit code';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get changePasswordDescription =>
      'Your new password must be different from previously used passwords.';

  @override
  String get changePasswordNewPasswordLabel => 'New Password';

  @override
  String get changePasswordConfirmPasswordLabel => 'Confirm Password';

  @override
  String get changePasswordConfirm => 'Confirm';

  @override
  String get changePasswordMinLength =>
      'Password must be at least 6 characters';

  @override
  String get changePasswordMismatch => 'Passwords do not match';

  @override
  String get changePasswordSuccess => 'Password reset successfully';

  @override
  String get errorRateLimit => 'Too many requests. Please try again later.';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network and try again.';

  @override
  String get errorExpiredOtp =>
      'Your OTP has expired. Please request a new one.';

  @override
  String get errorPasswordPolicy =>
      'Password does not meet the minimum requirements.';

  @override
  String get errorServer =>
      'An unexpected error occurred. Please try again later.';
}
