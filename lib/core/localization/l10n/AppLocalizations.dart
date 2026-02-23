import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'AppLocalizations_ar.dart';
import 'AppLocalizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/AppLocalizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @onboardingLogIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get onboardingLogIn;

  /// No description provided for @onboardingNewUser.
  ///
  /// In en, this message translates to:
  /// **'New User'**
  String get onboardingNewUser;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @supportPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportPageTitle;

  /// No description provided for @supportPageDescription.
  ///
  /// In en, this message translates to:
  /// **'For support, please contact us at support@wasla.com'**
  String get supportPageDescription;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginTitle;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get loginRememberMe;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignIn;

  /// No description provided for @loginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get loginSignUp;

  /// No description provided for @loginSignUpAction.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get loginSignUpAction;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get loginInvalidCredentials;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get loginEmailRequired;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get loginPasswordRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get loginEmailInvalid;

  /// No description provided for @loginUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get loginUnexpectedError;

  /// No description provided for @loginNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get loginNoConnection;

  /// No description provided for @loginRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get loginRateLimited;

  /// No description provided for @loginSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get loginSessionExpired;

  /// No description provided for @loginErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials or inactive account.'**
  String get loginErrorInvalidCredentials;

  /// No description provided for @loginErrorAccountNotSetup.
  ///
  /// In en, this message translates to:
  /// **'Your account is not fully set up. Please contact support for help.'**
  String get loginErrorAccountNotSetup;

  /// No description provided for @loginErrorRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many login attempts. Please try again later.'**
  String get loginErrorRateLimit;

  /// No description provided for @loginErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get loginErrorNetwork;

  /// No description provided for @loginErrorServer.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again later.'**
  String get loginErrorServer;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forget Password ?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! It occurs. Please enter the email address linked with your account.'**
  String get forgotPasswordDescription;

  /// No description provided for @forgotPasswordEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email Address'**
  String get forgotPasswordEmailLabel;

  /// No description provided for @forgotPasswordEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'yourmail@gmail.com'**
  String get forgotPasswordEmailPlaceholder;

  /// No description provided for @forgotPasswordSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get forgotPasswordSend;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent successfully'**
  String get forgotPasswordSuccess;

  /// No description provided for @forgotPasswordEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get forgotPasswordEmailRequired;

  /// No description provided for @forgotPasswordEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get forgotPasswordEmailInvalid;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpTitle;

  /// No description provided for @signUpFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get signUpFirstName;

  /// No description provided for @signUpLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get signUpLastName;

  /// No description provided for @signUpPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get signUpPhoneNumber;

  /// No description provided for @signUpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get signUpEmail;

  /// No description provided for @signUpEmailHint.
  ///
  /// In en, this message translates to:
  /// **'youremail@gmail.com'**
  String get signUpEmailHint;

  /// No description provided for @signUpPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signUpPassword;

  /// No description provided for @signUpConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signUpConfirmPassword;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @signUpHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log In'**
  String get signUpHaveAccount;

  /// No description provided for @signUpHaveAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get signUpHaveAccountAction;

  /// No description provided for @signUpFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get signUpFirstNameRequired;

  /// No description provided for @signUpLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get signUpLastNameRequired;

  /// No description provided for @signUpNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Must be 100 characters or less'**
  String get signUpNameTooLong;

  /// No description provided for @signUpPhoneTooLong.
  ///
  /// In en, this message translates to:
  /// **'Must be 50 characters or less'**
  String get signUpPhoneTooLong;

  /// No description provided for @signUpEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get signUpEmailRequired;

  /// No description provided for @signUpEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get signUpEmailInvalid;

  /// No description provided for @signUpPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get signUpPasswordRequired;

  /// No description provided for @signUpPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get signUpPasswordTooShort;

  /// No description provided for @signUpConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get signUpConfirmPasswordRequired;

  /// No description provided for @signUpConfirmPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get signUpConfirmPasswordMismatch;

  /// No description provided for @signUpErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get signUpErrorEmailInUse;

  /// No description provided for @signUpErrorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get signUpErrorServer;

  /// No description provided for @signUpErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get signUpErrorNetwork;

  /// No description provided for @signUpErrorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get signUpErrorUnexpected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
