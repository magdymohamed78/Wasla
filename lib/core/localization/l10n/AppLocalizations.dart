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
  /// **'Enter a valid email address'**
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

  /// No description provided for @signUpNameLettersOnly.
  ///
  /// In en, this message translates to:
  /// **'Name must contain letters only'**
  String get signUpNameLettersOnly;

  /// No description provided for @signUpPhoneTooLong.
  ///
  /// In en, this message translates to:
  /// **'Must be 50 characters or less'**
  String get signUpPhoneTooLong;

  /// No description provided for @signUpPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be exactly 11 digits'**
  String get signUpPhoneInvalid;

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
  /// **'Enter a password'**
  String get signUpPasswordRequired;

  /// No description provided for @signUpPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use 8+ characters'**
  String get signUpPasswordTooShort;

  /// No description provided for @signUpPasswordMissingUppercase.
  ///
  /// In en, this message translates to:
  /// **'Add an uppercase letter'**
  String get signUpPasswordMissingUppercase;

  /// No description provided for @signUpPasswordMissingNumber.
  ///
  /// In en, this message translates to:
  /// **'Add a number'**
  String get signUpPasswordMissingNumber;

  /// No description provided for @signUpPasswordMissingSpecial.
  ///
  /// In en, this message translates to:
  /// **'Add a special character'**
  String get signUpPasswordMissingSpecial;

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

  /// No description provided for @signUpSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You are successfully registered!'**
  String get signUpSuccessMessage;

  /// No description provided for @signUpSuccessButton.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start'**
  String get signUpSuccessButton;

  /// No description provided for @networkErrorNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get networkErrorNoConnection;

  /// No description provided for @networkErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get networkErrorRetry;

  /// No description provided for @networkErrorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get networkErrorServer;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get otpVerificationTitle;

  /// No description provided for @otpVerificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP sent to your email to proceed.'**
  String get otpVerificationDescription;

  /// No description provided for @otpVerificationTimerText.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String otpVerificationTimerText(int seconds);

  /// No description provided for @otpVerificationResend.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get otpVerificationResend;

  /// No description provided for @otpVerificationVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otpVerificationVerify;

  /// No description provided for @otpVerificationOtpRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP code'**
  String get otpVerificationOtpRequired;

  /// No description provided for @otpVerificationOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit code'**
  String get otpVerificationOtpInvalid;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from previously used passwords.'**
  String get changePasswordDescription;

  /// No description provided for @changePasswordNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get changePasswordNewPasswordLabel;

  /// No description provided for @changePasswordConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get changePasswordConfirmPasswordLabel;

  /// No description provided for @changePasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get changePasswordConfirm;

  /// No description provided for @changePasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get changePasswordMinLength;

  /// No description provided for @changePasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get changePasswordMismatch;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get changePasswordSuccess;

  /// No description provided for @errorRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get errorRateLimit;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get errorNetwork;

  /// No description provided for @errorExpiredOtp.
  ///
  /// In en, this message translates to:
  /// **'Your OTP has expired. Please request a new one.'**
  String get errorExpiredOtp;

  /// No description provided for @errorPasswordPolicy.
  ///
  /// In en, this message translates to:
  /// **'Password does not meet the minimum requirements.'**
  String get errorPasswordPolicy;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again later.'**
  String get errorServer;

  /// No description provided for @signatureModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Digital Signature'**
  String get signatureModalTitle;

  /// No description provided for @signatureModalGuidance.
  ///
  /// In en, this message translates to:
  /// **'Please keep this signature safe. You will need it later to approve offers.'**
  String get signatureModalGuidance;

  /// No description provided for @signatureModalDownloadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save signature. Please try again.'**
  String get signatureModalDownloadError;

  /// No description provided for @signatureModalOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get signatureModalOk;

  /// No description provided for @signatureModalDownloadButton.
  ///
  /// In en, this message translates to:
  /// **'Download signature'**
  String get signatureModalDownloadButton;

  /// No description provided for @signUpErrorMissingSignature.
  ///
  /// In en, this message translates to:
  /// **'Registration incomplete. Please try again or contact support.'**
  String get signUpErrorMissingSignature;

  /// No description provided for @signatureModalCopySuccess.
  ///
  /// In en, this message translates to:
  /// **'Signature copied to clipboard.'**
  String get signatureModalCopySuccess;

  /// No description provided for @forgotPasswordNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'Email not registered. Please sign up first.'**
  String get forgotPasswordNotRegistered;

  /// No description provided for @forgotPasswordInactiveAccount.
  ///
  /// In en, this message translates to:
  /// **'Account exists but is inactive — please contact support.'**
  String get forgotPasswordInactiveAccount;

  /// No description provided for @forgotPasswordSignUp.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get forgotPasswordSignUp;

  /// No description provided for @forgotPasswordSignUpAction.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get forgotPasswordSignUpAction;

  /// No description provided for @forgotPasswordContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get forgotPasswordContactSupport;

  /// No description provided for @forgotPasswordRateLimitWait.
  ///
  /// In en, this message translates to:
  /// **'Try again in {seconds}s'**
  String forgotPasswordRateLimitWait(int seconds);

  /// No description provided for @passwordRuleMinLength.
  ///
  /// In en, this message translates to:
  /// **'8+ characters'**
  String get passwordRuleMinLength;

  /// No description provided for @passwordRuleNumber.
  ///
  /// In en, this message translates to:
  /// **'1+ number'**
  String get passwordRuleNumber;

  /// No description provided for @passwordRuleUppercase.
  ///
  /// In en, this message translates to:
  /// **'1+ uppercase letter'**
  String get passwordRuleUppercase;

  /// No description provided for @passwordRuleSpecial.
  ///
  /// In en, this message translates to:
  /// **'1+ special character (!@#\$%^&*)'**
  String get passwordRuleSpecial;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get passwordStrengthMedium;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// No description provided for @passwordStrengthHelperFeedback.
  ///
  /// In en, this message translates to:
  /// **'Please choose a stronger password.'**
  String get passwordStrengthHelperFeedback;

  /// No description provided for @homeSearchForServicesOrCompanies.
  ///
  /// In en, this message translates to:
  /// **'Search for services or companies'**
  String get homeSearchForServicesOrCompanies;

  /// No description provided for @homeRecommendedCompanies.
  ///
  /// In en, this message translates to:
  /// **'Recommended Companies'**
  String get homeRecommendedCompanies;

  /// No description provided for @homeTrendingCompanies.
  ///
  /// In en, this message translates to:
  /// **'Trending Companies'**
  String get homeTrendingCompanies;

  /// No description provided for @homeAllCompanies.
  ///
  /// In en, this message translates to:
  /// **'All Companies'**
  String get homeAllCompanies;

  /// CTA button label that opens the full companies list for a home section.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAll;

  /// No description provided for @navigationHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigationHome;

  /// Bottom navigation item label that opens the Companies dropdown menu.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get navigationCompanies;

  /// No description provided for @navigationSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get navigationSignIn;

  /// No description provided for @navigationRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get navigationRequests;

  /// No description provided for @navigationOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get navigationOffers;

  /// No description provided for @navigationProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navigationProfile;

  /// Bottom navigation item label for role-specific settings destination.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navigationSettings;

  /// No description provided for @navigationAllCompanies.
  ///
  /// In en, this message translates to:
  /// **'All Companies'**
  String get navigationAllCompanies;

  /// No description provided for @navigationRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get navigationRecommended;

  /// No description provided for @navigationTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get navigationTrending;

  /// No description provided for @a11yCompaniesDropdownButton.
  ///
  /// In en, this message translates to:
  /// **'Open companies options'**
  String get a11yCompaniesDropdownButton;

  /// No description provided for @a11ySettingsTabButton.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get a11ySettingsTabButton;

  /// No description provided for @a11yViewAllButton.
  ///
  /// In en, this message translates to:
  /// **'View all companies in this section'**
  String get a11yViewAllButton;

  /// No description provided for @exploreSearchCompanies.
  ///
  /// In en, this message translates to:
  /// **'Search companies...'**
  String get exploreSearchCompanies;

  /// No description provided for @exploreSearchCity.
  ///
  /// In en, this message translates to:
  /// **'City...'**
  String get exploreSearchCity;

  /// No description provided for @exploreAllServices.
  ///
  /// In en, this message translates to:
  /// **'All Services'**
  String get exploreAllServices;

  /// No description provided for @exploreMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get exploreMove;

  /// No description provided for @exploreCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get exploreCleaning;

  /// No description provided for @exploreDisposal.
  ///
  /// In en, this message translates to:
  /// **'Disposal'**
  String get exploreDisposal;

  /// No description provided for @explorePacking.
  ///
  /// In en, this message translates to:
  /// **'Packing'**
  String get explorePacking;

  /// No description provided for @exploreUnpacking.
  ///
  /// In en, this message translates to:
  /// **'Unpacking'**
  String get exploreUnpacking;

  /// No description provided for @exploreStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get exploreStorage;

  /// No description provided for @exploreTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get exploreTransport;

  /// No description provided for @exploreNoCompaniesFound.
  ///
  /// In en, this message translates to:
  /// **'No companies found'**
  String get exploreNoCompaniesFound;

  /// No description provided for @exploreTryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search filters'**
  String get exploreTryAdjustingFilters;

  /// No description provided for @exploreClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get exploreClearFilters;

  /// No description provided for @restrictionLoginOrRegister.
  ///
  /// In en, this message translates to:
  /// **'Sign in to unlock this destination.'**
  String get restrictionLoginOrRegister;

  /// No description provided for @restrictionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get restrictionContinue;

  /// No description provided for @restrictionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get restrictionCancel;

  /// No description provided for @restrictionBrowseCompanies.
  ///
  /// In en, this message translates to:
  /// **'Back to Companies'**
  String get restrictionBrowseCompanies;

  /// No description provided for @restrictionRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Requests require sign in'**
  String get restrictionRequestsTitle;

  /// No description provided for @restrictionOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers require sign in'**
  String get restrictionOffersTitle;

  /// No description provided for @restrictionProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile requires sign in'**
  String get restrictionProfileTitle;

  /// No description provided for @restrictionRequestsMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to track and manage your requests.'**
  String get restrictionRequestsMessage;

  /// No description provided for @restrictionOffersMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view and compare your offers.'**
  String get restrictionOffersMessage;

  /// No description provided for @restrictionProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your profile and settings.'**
  String get restrictionProfileMessage;

  /// No description provided for @requestFlowContinuePromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to request this service'**
  String get requestFlowContinuePromptTitle;

  /// No description provided for @requestFlowContinuePromptMessage.
  ///
  /// In en, this message translates to:
  /// **'Continue to sign in so you can request service from this company.'**
  String get requestFlowContinuePromptMessage;

  /// No description provided for @requestFlowLeadReloginPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish setup to continue'**
  String get requestFlowLeadReloginPromptTitle;

  /// No description provided for @requestFlowLeadReloginPromptMessage.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again to continue and unlock your full customer access.'**
  String get requestFlowLeadReloginPromptMessage;

  /// No description provided for @requestFlowSuccessGoToRequests.
  ///
  /// In en, this message translates to:
  /// **'Go to Requests'**
  String get requestFlowSuccessGoToRequests;

  /// No description provided for @requestFlowMissingCompany.
  ///
  /// In en, this message translates to:
  /// **'Please choose a company before submitting your request.'**
  String get requestFlowMissingCompany;

  /// No description provided for @homeNoReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get homeNoReviewsYet;

  /// No description provided for @homeRecommendedLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recommended companies.'**
  String get homeRecommendedLoadFailed;

  /// No description provided for @homeTrendingLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load trending companies.'**
  String get homeTrendingLoadFailed;

  /// No description provided for @homeAllCompaniesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load companies.'**
  String get homeAllCompaniesLoadFailed;

  /// No description provided for @explorePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explorePageTitle;

  /// No description provided for @explorePagePlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Explore content is coming soon.'**
  String get explorePagePlaceholderMessage;

  /// No description provided for @companyDetailsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Company Details'**
  String get companyDetailsPageTitle;

  /// No description provided for @companyDetailsContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get companyDetailsContactInfo;

  /// No description provided for @companyDetailsServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get companyDetailsServices;

  /// No description provided for @companyDetailsRecentReviews.
  ///
  /// In en, this message translates to:
  /// **'Recent Reviews'**
  String get companyDetailsRecentReviews;

  /// No description provided for @companyDetailsNoContactInfo.
  ///
  /// In en, this message translates to:
  /// **'No contact information available.'**
  String get companyDetailsNoContactInfo;

  /// No description provided for @companyDetailsNoServicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No services listed.'**
  String get companyDetailsNoServicesAvailable;

  /// No description provided for @companyDetailsNoReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews available yet.'**
  String get companyDetailsNoReviewsYet;

  /// No description provided for @companyDetailsRequestService.
  ///
  /// In en, this message translates to:
  /// **'Request Service'**
  String get companyDetailsRequestService;

  /// No description provided for @companyDetailsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load company details.'**
  String get companyDetailsLoadFailed;

  /// No description provided for @companyDetailsLoadMoreReviews.
  ///
  /// In en, this message translates to:
  /// **'Load more reviews'**
  String get companyDetailsLoadMoreReviews;

  /// No description provided for @companyDetailsAnonymousReviewer.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get companyDetailsAnonymousReviewer;

  /// No description provided for @companyDetailsNoComment.
  ///
  /// In en, this message translates to:
  /// **'No comment provided.'**
  String get companyDetailsNoComment;

  /// No description provided for @companyDetailsUnknownCompany.
  ///
  /// In en, this message translates to:
  /// **'Unknown company'**
  String get companyDetailsUnknownCompany;

  /// No description provided for @companyDetailsUnnamedService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get companyDetailsUnnamedService;

  /// No description provided for @companyDetailsInvalidCompanyId.
  ///
  /// In en, this message translates to:
  /// **'Invalid company ID.'**
  String get companyDetailsInvalidCompanyId;

  /// No description provided for @companyDetailsViewAllReviews.
  ///
  /// In en, this message translates to:
  /// **'View All Reviews'**
  String get companyDetailsViewAllReviews;

  /// No description provided for @companyDetailsPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Company details for ID: {companyId}'**
  String companyDetailsPlaceholderBody(String companyId);

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get homeGreeting;

  /// No description provided for @companyReviewsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'All Reviews'**
  String get companyReviewsPageTitle;

  /// No description provided for @homeGreetingWithName.
  ///
  /// In en, this message translates to:
  /// **'Hello, {firstName}'**
  String homeGreetingWithName(String firstName);

  /// No description provided for @notificationsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsPageTitle;

  /// No description provided for @notificationsPagePlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Notifications content is coming soon.'**
  String get notificationsPagePlaceholderMessage;

  /// No description provided for @settingsEditProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get settingsEditProfileTitle;

  /// No description provided for @settingsEditProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get settingsEditProfileSubtitle;

  /// No description provided for @settingsDigitalSignatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Digital Signature'**
  String get settingsDigitalSignatureTitle;

  /// No description provided for @settingsDigitalSignatureMasked.
  ///
  /// In en, this message translates to:
  /// **'*********'**
  String get settingsDigitalSignatureMasked;

  /// No description provided for @settingsSignaturePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Password'**
  String get settingsSignaturePasswordTitle;

  /// No description provided for @settingsSignaturePasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get settingsSignaturePasswordHint;

  /// No description provided for @settingsSignaturePasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get settingsSignaturePasswordSubmit;

  /// No description provided for @settingsSignatureCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get settingsSignatureCopied;

  /// No description provided for @settingsSignatureLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Please try again after 15 minutes.'**
  String get settingsSignatureLocked;

  /// No description provided for @settingsChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settingsChangePasswordTitle;

  /// No description provided for @settingsCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get settingsCurrentPassword;

  /// No description provided for @settingsNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get settingsNewPassword;

  /// No description provided for @settingsConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get settingsConfirmNewPassword;

  /// No description provided for @settingsChangePasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settingsChangePasswordSubmit;

  /// No description provided for @settingsChangePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get settingsChangePasswordSuccess;

  /// No description provided for @settingsSectionAccountManagement.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT MANAGEMENT'**
  String get settingsSectionAccountManagement;

  /// No description provided for @settingsSectionDigitalSignature.
  ///
  /// In en, this message translates to:
  /// **'DIGITAL SIGNATURE'**
  String get settingsSectionDigitalSignature;

  /// No description provided for @settingsSectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'SECURITY & AUTHENTICATION'**
  String get settingsSectionSecurity;

  /// No description provided for @settingsSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'APPLICATION PREFERENCES'**
  String get settingsSectionPreferences;

  /// No description provided for @settingsSecuritySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Security & Authentication'**
  String get settingsSecuritySectionTitle;

  /// No description provided for @settingsLogoutCurrent.
  ///
  /// In en, this message translates to:
  /// **'Log Out Current Session'**
  String get settingsLogoutCurrent;

  /// No description provided for @settingsLogoutAll.
  ///
  /// In en, this message translates to:
  /// **'Log Out All Devices'**
  String get settingsLogoutAll;

  /// No description provided for @settingsLogoutAllSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Terminate all active sessions\nacross your logged-in platforms.'**
  String get settingsLogoutAllSubtitle;

  /// No description provided for @settingsLogoutAllConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout All Devices?'**
  String get settingsLogoutAllConfirmTitle;

  /// No description provided for @settingsLogoutAllConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will sign you out from all devices.'**
  String get settingsLogoutAllConfirmMessage;

  /// No description provided for @settingsLogoutAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get settingsLogoutAllConfirm;

  /// No description provided for @settingsLogoutAllCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsLogoutAllCancel;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @profileRoleLead.
  ///
  /// In en, this message translates to:
  /// **'Lead'**
  String get profileRoleLead;

  /// No description provided for @profileRoleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get profileRoleCustomer;

  /// No description provided for @profileEditPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditPageTitle;

  /// No description provided for @profilePersonalDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get profilePersonalDetailsTitle;

  /// No description provided for @profileAddressInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Address Information'**
  String get profileAddressInformationTitle;

  /// No description provided for @profileConnectedCompaniesTitle.
  ///
  /// In en, this message translates to:
  /// **'Connected Companies'**
  String get profileConnectedCompaniesTitle;

  /// No description provided for @profileConnectedCompaniesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No connected companies'**
  String get profileConnectedCompaniesEmptyTitle;

  /// No description provided for @profileConnectedCompaniesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Connect with a company to start receiving offers and service requests.'**
  String get profileConnectedCompaniesEmptyMessage;

  /// No description provided for @profileFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileFullNameLabel;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhoneLabel;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get profileMemberSince;

  /// No description provided for @profileStreetAddress.
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get profileStreetAddress;

  /// No description provided for @profileCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profileCityLabel;

  /// No description provided for @profileZipCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get profileZipCodeLabel;

  /// No description provided for @profileCityZipLabel.
  ///
  /// In en, this message translates to:
  /// **'City / Zip'**
  String get profileCityZipLabel;

  /// No description provided for @profileCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profileCountryLabel;

  /// No description provided for @profileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profileSaveChanges;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileSaveSuccess;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Unable to update profile. Please try again.'**
  String get profileSaveError;

  /// No description provided for @profileCompanyCustomerId.
  ///
  /// In en, this message translates to:
  /// **'Customer ID'**
  String get profileCompanyCustomerId;

  /// No description provided for @profileCompanyRequestedAt.
  ///
  /// In en, this message translates to:
  /// **'Requested At'**
  String get profileCompanyRequestedAt;

  /// No description provided for @profileCompanyRespondedAt.
  ///
  /// In en, this message translates to:
  /// **'Responded At'**
  String get profileCompanyRespondedAt;

  /// No description provided for @profileCompanyStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get profileCompanyStatusPending;

  /// No description provided for @profileCompanyStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get profileCompanyStatusAccepted;

  /// No description provided for @profileCompanyStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get profileCompanyStatusRejected;

  /// No description provided for @profileCompanyStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get profileCompanyStatusUnknown;

  /// No description provided for @profileCompanyLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More (+{count})'**
  String profileCompanyLoadMore(int count);

  /// No description provided for @requestsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requestsPageTitle;

  /// No description provided for @requestsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Requests'**
  String get requestsHeaderTitle;

  /// No description provided for @requestsHeaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Track and manage your service requests'**
  String get requestsHeaderDescription;

  /// No description provided for @requestsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get requestsFilterAll;

  /// No description provided for @requestsFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get requestsFilterPending;

  /// No description provided for @requestsFilterOfferSent.
  ///
  /// In en, this message translates to:
  /// **'Offer Sent'**
  String get requestsFilterOfferSent;

  /// No description provided for @requestsFilterDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get requestsFilterDeclined;

  /// No description provided for @requestsFilterExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get requestsFilterExpired;

  /// No description provided for @requestsCardViewRequest.
  ///
  /// In en, this message translates to:
  /// **'View Request'**
  String get requestsCardViewRequest;

  /// No description provided for @requestsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No requests yet'**
  String get requestsEmptyTitle;

  /// No description provided for @requestsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your service requests will appear here once you submit one.'**
  String get requestsEmptyMessage;

  /// No description provided for @requestsEmptyBrowseCompanies.
  ///
  /// In en, this message translates to:
  /// **'Browse Companies'**
  String get requestsEmptyBrowseCompanies;

  /// No description provided for @requestsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get requestsErrorTitle;

  /// No description provided for @requestsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your requests. Please try again.'**
  String get requestsErrorMessage;

  /// No description provided for @requestsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get requestsRetry;

  /// No description provided for @requestsLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more requests...'**
  String get requestsLoadMore;

  /// No description provided for @requestsDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestsDetailsTitle;

  /// No description provided for @requestsDetailsReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get requestsDetailsReference;

  /// No description provided for @requestsDetailsCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get requestsDetailsCompany;

  /// No description provided for @requestsDetailsStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get requestsDetailsStatus;

  /// No description provided for @requestsDetailsServiceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get requestsDetailsServiceType;

  /// No description provided for @requestsDetailsPreferredDate.
  ///
  /// In en, this message translates to:
  /// **'Preferred Date'**
  String get requestsDetailsPreferredDate;

  /// No description provided for @requestsDetailsSubmissionDate.
  ///
  /// In en, this message translates to:
  /// **'Submission Date'**
  String get requestsDetailsSubmissionDate;

  /// No description provided for @requestsDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Request not found.'**
  String get requestsDetailsNotFound;

  /// No description provided for @requestsDetailsAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have access to this request.'**
  String get requestsDetailsAccessDenied;

  /// No description provided for @requestsFullPageTitle.
  ///
  /// In en, this message translates to:
  /// **'All Requests'**
  String get requestsFullPageTitle;

  /// No description provided for @requestsFullPageEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No requests in this category'**
  String get requestsFullPageEmptyTitle;

  /// No description provided for @requestsFullPageEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Try switching to a different filter or browse companies.'**
  String get requestsFullPageEmptyMessage;

  /// No description provided for @requestsFullPageLoadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get requestsFullPageLoadingMore;

  /// No description provided for @requestsDateNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get requestsDateNotAvailable;
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
