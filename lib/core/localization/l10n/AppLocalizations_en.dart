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
}
