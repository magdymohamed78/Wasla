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
  String get forgotPasswordEmailInvalid => 'Enter a valid email address';

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
  String get signUpNameLettersOnly => 'Name must contain letters only';

  @override
  String get signUpPhoneTooLong => 'Must be 50 characters or less';

  @override
  String get signUpPhoneInvalid => 'Phone number must be exactly 11 digits';

  @override
  String get signUpEmailRequired => 'Email is required';

  @override
  String get signUpEmailInvalid => 'Enter a valid email address';

  @override
  String get signUpPasswordRequired => 'Enter a password';

  @override
  String get signUpPasswordTooShort => 'Use 8+ characters';

  @override
  String get signUpPasswordMissingUppercase => 'Add an uppercase letter';

  @override
  String get signUpPasswordMissingNumber => 'Add a number';

  @override
  String get signUpPasswordMissingSpecial => 'Add a special character';

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

  @override
  String get signatureModalTitle => 'Your Digital Signature';

  @override
  String get signatureModalGuidance =>
      'Please keep this signature safe. You will need it later to approve offers.';

  @override
  String get signatureModalDownloadError =>
      'Failed to save signature. Please try again.';

  @override
  String get signatureModalOk => 'OK';

  @override
  String get signatureModalDownloadButton => 'Download signature';

  @override
  String get signUpErrorMissingSignature =>
      'Registration incomplete. Please try again or contact support.';

  @override
  String get signatureModalCopySuccess => 'Signature copied to clipboard.';

  @override
  String get forgotPasswordNotRegistered =>
      'Email not registered. Please sign up first.';

  @override
  String get forgotPasswordInactiveAccount =>
      'Account exists but is inactive — please contact support.';

  @override
  String get forgotPasswordSignUp => 'Don\'t have an account? Sign Up';

  @override
  String get forgotPasswordSignUpAction => 'Sign Up';

  @override
  String get forgotPasswordContactSupport => 'Contact Support';

  @override
  String forgotPasswordRateLimitWait(int seconds) {
    return 'Try again in ${seconds}s';
  }

  @override
  String get passwordRuleMinLength => '8+ characters';

  @override
  String get passwordRuleNumber => '1+ number';

  @override
  String get passwordRuleUppercase => '1+ uppercase letter';

  @override
  String get passwordRuleSpecial => '1+ special character (!@#\$%^&*)';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthMedium => 'Medium';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get passwordStrengthHelperFeedback =>
      'Please choose a stronger password.';

  @override
  String get homeSearchForServicesOrCompanies =>
      'Search for services or companies';

  @override
  String get homeRecommendedCompanies => 'Recommended Companies';

  @override
  String get homeTrendingCompanies => 'Trending Companies';

  @override
  String get homeAllCompanies => 'All Companies';

  @override
  String get homeViewAll => 'View All';

  @override
  String get navigationHome => 'Home';

  @override
  String get navigationCompanies => 'Companies';

  @override
  String get navigationSignIn => 'Sign In';

  @override
  String get navigationRequests => 'Requests';

  @override
  String get navigationOffers => 'Offers';

  @override
  String get navigationProfile => 'Profile';

  @override
  String get navigationSettings => 'Settings';

  @override
  String get navigationAllCompanies => 'All Companies';

  @override
  String get navigationRecommended => 'Recommended';

  @override
  String get navigationTrending => 'Trending';

  @override
  String get a11yCompaniesDropdownButton => 'Open companies options';

  @override
  String get a11ySettingsTabButton => 'Open settings';

  @override
  String get a11yViewAllButton => 'View all companies in this section';

  @override
  String get exploreSearchCompanies => 'Search companies...';

  @override
  String get exploreSearchCity => 'City...';

  @override
  String get exploreAllServices => 'All Services';

  @override
  String get exploreMove => 'Move';

  @override
  String get exploreCleaning => 'Cleaning';

  @override
  String get exploreDisposal => 'Disposal';

  @override
  String get explorePacking => 'Packing';

  @override
  String get exploreUnpacking => 'Unpacking';

  @override
  String get exploreStorage => 'Storage';

  @override
  String get exploreTransport => 'Transport';

  @override
  String get exploreNoCompaniesFound => 'No companies found';

  @override
  String get exploreTryAdjustingFilters => 'Try adjusting your search filters';

  @override
  String get exploreClearFilters => 'Clear filters';

  @override
  String get restrictionLoginOrRegister =>
      'Sign in to unlock this destination.';

  @override
  String get restrictionContinue => 'Continue';

  @override
  String get restrictionCancel => 'Cancel';

  @override
  String get restrictionBrowseCompanies => 'Back to Companies';

  @override
  String get restrictionRequestsTitle => 'Requests require sign in';

  @override
  String get restrictionOffersTitle => 'Offers require sign in';

  @override
  String get restrictionProfileTitle => 'Profile requires sign in';

  @override
  String get restrictionRequestsMessage =>
      'Sign in to track and manage your requests.';

  @override
  String get restrictionOffersMessage =>
      'Sign in to view and compare your offers.';

  @override
  String get restrictionProfileMessage =>
      'Sign in to access your profile and settings.';

  @override
  String get requestFlowContinuePromptTitle =>
      'Sign in to request this service';

  @override
  String get requestFlowContinuePromptMessage =>
      'Continue to sign in so you can request service from this company.';

  @override
  String get requestFlowLeadReloginPromptTitle => 'Finish setup to continue';

  @override
  String get requestFlowLeadReloginPromptMessage =>
      'Please sign in again to continue and unlock your full customer access.';

  @override
  String get requestFlowSuccessGoToRequests => 'Go to Requests';

  @override
  String get requestFlowMissingCompany =>
      'Please choose a company before submitting your request.';

  @override
  String get homeNoReviewsYet => 'No reviews yet';

  @override
  String get homeRecommendedLoadFailed =>
      'Failed to load recommended companies.';

  @override
  String get homeTrendingLoadFailed => 'Failed to load trending companies.';

  @override
  String get homeAllCompaniesLoadFailed => 'Failed to load companies.';

  @override
  String get explorePageTitle => 'Explore';

  @override
  String get explorePagePlaceholderMessage => 'Explore content is coming soon.';

  @override
  String get companyDetailsPageTitle => 'Company Details';

  @override
  String get companyDetailsContactInfo => 'Contact Information';

  @override
  String get companyDetailsServices => 'Services';

  @override
  String get companyDetailsRecentReviews => 'Recent Reviews';

  @override
  String get companyDetailsNoContactInfo => 'No contact information available.';

  @override
  String get companyDetailsNoServicesAvailable => 'No services listed.';

  @override
  String get companyDetailsNoReviewsYet => 'No reviews available yet.';

  @override
  String get companyDetailsRequestService => 'Request Service';

  @override
  String get companyDetailsLoadFailed => 'Unable to load company details.';

  @override
  String get companyDetailsLoadMoreReviews => 'Load more reviews';

  @override
  String get companyDetailsAnonymousReviewer => 'Anonymous';

  @override
  String get companyDetailsNoComment => 'No comment provided.';

  @override
  String get companyDetailsUnknownCompany => 'Unknown company';

  @override
  String get companyDetailsUnnamedService => 'Service';

  @override
  String get companyDetailsInvalidCompanyId => 'Invalid company ID.';

  @override
  String get companyDetailsViewAllReviews => 'View All Reviews';

  @override
  String companyDetailsReviewsSectionTitle(int count) {
    return 'Reviews ($count)';
  }

  @override
  String companyDetailsPlaceholderBody(String companyId) {
    return 'Company details for ID: $companyId';
  }

  @override
  String get homeGreeting => 'Hello';

  @override
  String get companyReviewsPageTitle => 'All Reviews';

  @override
  String get companyReviewsSortLabel => 'Sort reviews';

  @override
  String get companyReviewsSortNewestFirst => 'Newest first';

  @override
  String get companyReviewsSortOldestFirst => 'Oldest first';

  @override
  String get companyReviewsSortHighestRating => 'Highest rating';

  @override
  String get companyReviewsSortLowestRating => 'Lowest rating';

  @override
  String get companyReviewsWriteReview => 'Write a Review';

  @override
  String get companyReviewsWriteHint => 'Write your review...';

  @override
  String get companyReviewsWriteSubmit => 'Submit';

  @override
  String get companyReviewsWriteSuccess => 'Review submitted successfully.';

  @override
  String get companyReviewsWriteErrorBadRequest =>
      'Review not submitted due to inappropriate language. Please edit and try again.';

  @override
  String get companyReviewsWriteErrorUnauthorized =>
      'Please sign in to submit a review.';

  @override
  String get companyReviewsWriteErrorForbidden =>
      'Only customers can submit reviews.';

  @override
  String get companyReviewsWriteErrorNotFound =>
      'This company could not be found.';

  @override
  String get companyReviewsWriteErrorConflict =>
      'You already reviewed this company.';

  @override
  String get companyReviewsWriteErrorServer =>
      'Unable to submit review right now. Please try again.';

  @override
  String get companyReviewsWriteErrorNetwork =>
      'Please check your internet connection and try again.';

  @override
  String get companyReviewsEligibilityInfo =>
      'You can only review companies you are connected with. Submit a service request and wait for acceptance, or manage connections from your profile.';

  @override
  String get companyReviewsViewProfile => 'View Profile';

  @override
  String homeGreetingWithName(String firstName) {
    return 'Hello, $firstName';
  }

  @override
  String get notificationsPageTitle => 'Notifications';

  @override
  String get notificationsPagePlaceholderMessage =>
      'Notifications content is coming soon.';

  @override
  String get settingsEditProfileTitle => 'Edit Profile';

  @override
  String get settingsEditProfileSubtitle => 'Update your personal information';

  @override
  String get settingsDigitalSignatureTitle => 'Digital Signature';

  @override
  String get settingsDigitalSignatureMasked => '*********';

  @override
  String get settingsSignaturePasswordTitle => 'Verify Password';

  @override
  String get settingsSignaturePasswordHint => 'Enter your password';

  @override
  String get settingsSignaturePasswordSubmit => 'Verify';

  @override
  String get settingsSignatureCopied => 'Copied to clipboard';

  @override
  String get settingsSignatureLocked =>
      'Too many failed attempts. Please try again after 15 minutes.';

  @override
  String get settingsChangePasswordTitle => 'Change Password';

  @override
  String get settingsCurrentPassword => 'Current Password';

  @override
  String get settingsNewPassword => 'New Password';

  @override
  String get settingsConfirmNewPassword => 'Confirm New Password';

  @override
  String get settingsChangePasswordSubmit => 'Change Password';

  @override
  String get settingsChangePasswordSuccess => 'Password changed successfully';

  @override
  String get settingsSectionAccountManagement => 'ACCOUNT MANAGEMENT';

  @override
  String get settingsSectionDigitalSignature => 'DIGITAL SIGNATURE';

  @override
  String get settingsSectionSecurity => 'SECURITY & AUTHENTICATION';

  @override
  String get settingsSectionPreferences => 'APPLICATION PREFERENCES';

  @override
  String get settingsSecuritySectionTitle => 'Security & Authentication';

  @override
  String get settingsLogoutCurrent => 'Log Out Current Session';

  @override
  String get settingsLogoutAll => 'Log Out All Devices';

  @override
  String get settingsLogoutAllSubtitle =>
      'Terminate all active sessions\nacross your logged-in platforms.';

  @override
  String get settingsLogoutAllConfirmTitle => 'Logout All Devices?';

  @override
  String get settingsLogoutAllConfirmMessage =>
      'This will sign you out from all devices.';

  @override
  String get settingsLogoutAllConfirm => 'Confirm';

  @override
  String get settingsLogoutAllCancel => 'Cancel';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get profileRoleLead => 'Lead';

  @override
  String get profileRoleCustomer => 'Customer';

  @override
  String get profileEditPageTitle => 'Edit Profile';

  @override
  String get profilePersonalDetailsTitle => 'Personal Details';

  @override
  String get profileAddressInformationTitle => 'Address Information';

  @override
  String get profileConnectedCompaniesTitle => 'Connected Companies';

  @override
  String get profileConnectedCompaniesEmptyTitle => 'No connected companies';

  @override
  String get profileConnectedCompaniesEmptyMessage =>
      'Connect with a company to start receiving offers and service requests.';

  @override
  String get profileFullNameLabel => 'Full Name';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profilePhoneLabel => 'Phone';

  @override
  String get profileMemberSince => 'Member Since';

  @override
  String get profileStreetAddress => 'Street Address';

  @override
  String get profileCityLabel => 'City';

  @override
  String get profileZipCodeLabel => 'Zip Code';

  @override
  String get profileCityZipLabel => 'City / Zip';

  @override
  String get profileCountryLabel => 'Country';

  @override
  String get profileSaveChanges => 'Save Changes';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileSaveSuccess => 'Profile updated successfully';

  @override
  String get profileSaveError => 'Unable to update profile. Please try again.';

  @override
  String get profileCompanyCustomerId => 'Customer ID';

  @override
  String get profileCompanyRequestedAt => 'Requested At';

  @override
  String get profileCompanyRespondedAt => 'Responded At';

  @override
  String get profileCompanyStatusPending => 'Pending';

  @override
  String get profileCompanyStatusAccepted => 'Accepted';

  @override
  String get profileCompanyStatusRejected => 'Rejected';

  @override
  String get profileCompanyStatusUnknown => 'Unknown';

  @override
  String profileCompanyLoadMore(int count) {
    return 'Load More (+$count)';
  }

  @override
  String get requestsPageTitle => 'Requests';

  @override
  String get requestsHeaderTitle => 'Service Requests';

  @override
  String get requestsHeaderDescription =>
      'Track and manage your service requests';

  @override
  String get requestsFilterAll => 'All';

  @override
  String get requestsFilterPending => 'Pending';

  @override
  String get requestsFilterOfferSent => 'Offer Sent';

  @override
  String get requestsFilterDeclined => 'Declined';

  @override
  String get requestsFilterExpired => 'Expired';

  @override
  String get requestsCardViewRequest => 'View Request';

  @override
  String get requestsEmptyTitle => 'No requests yet';

  @override
  String get requestsEmptyMessage =>
      'Your service requests will appear here once you submit one.';

  @override
  String get requestsEmptyBrowseCompanies => 'Browse Companies';

  @override
  String get requestsErrorTitle => 'Something went wrong';

  @override
  String get requestsErrorMessage =>
      'Unable to load your requests. Please try again.';

  @override
  String get requestsRetry => 'Retry';

  @override
  String get requestsLoadMore => 'Loading more requests...';

  @override
  String get requestsDetailsTitle => 'Request Details';

  @override
  String get requestsDetailsReference => 'Reference';

  @override
  String get requestsDetailsCompany => 'Company';

  @override
  String get requestsDetailsStatus => 'Status';

  @override
  String get requestsDetailsServiceType => 'Service Type';

  @override
  String get requestsDetailsPreferredDate => 'Preferred Date';

  @override
  String get requestsDetailsSubmissionDate => 'Submission Date';

  @override
  String get requestsDetailsNotFound => 'Request not found.';

  @override
  String get requestsDetailsAccessDenied =>
      'You do not have access to this request.';

  @override
  String get requestsFullPageTitle => 'All Requests';

  @override
  String get requestsFullPageEmptyTitle => 'No requests in this category';

  @override
  String get requestsFullPageEmptyMessage =>
      'Try switching to a different filter or browse companies.';

  @override
  String get requestsFullPageLoadingMore => 'Loading more...';

  @override
  String get requestsDateNotAvailable => 'N/A';

  @override
  String get requestDetailsFromPickup => 'FROM (PICKUP)';

  @override
  String get requestDetailsToDropoff => 'TO (DROP-OFF)';

  @override
  String get requestDetailsPreferredDate => 'Preferred Date';

  @override
  String get requestDetailsTimeSlot => 'Time Slot';

  @override
  String get requestDetailsCustomerNotes => 'Customer Notes';

  @override
  String get requestDetailsLinkedOffer => 'Linked Offer';

  @override
  String get requestDetailsEstimatedTotal => 'Estimated Total';

  @override
  String get requestDetailsViewOffer => 'View Offer Details';

  @override
  String get offerDetailsTitle => 'Offer Details';

  @override
  String get requestDetailsNotAvailable => 'N/A';

  @override
  String get offersPageTitle => 'Offers';

  @override
  String get offersEmptyTitle => 'No offers yet';

  @override
  String get offersEmptyMessage =>
      'You don\'t have any offers yet. Submit a service request to receive quotes!';

  @override
  String get offersExploreCompanies => 'Explore Companies';

  @override
  String get offersBackToRequests => 'Back to Requests';

  @override
  String get offersFilterAll => 'All';

  @override
  String get offersFilterPending => 'Pending';

  @override
  String get offersFilterAccepted => 'Accepted';

  @override
  String get offersFilterRejected => 'Rejected';

  @override
  String get offersFilterExpired => 'Expired';

  @override
  String get offersTotalAmount => 'Total Amount';

  @override
  String get offersIssueDate => 'Issue Date';

  @override
  String get offersAcceptDate => 'Accept Date';

  @override
  String get offersErrorTitle => 'Something went wrong';

  @override
  String get offersErrorMessage =>
      'Unable to load your offers. Please try again.';

  @override
  String get offersRetry => 'Retry';

  @override
  String get newRequestPageTitle => 'New Service Request';

  @override
  String get newRequestStepServiceType => 'Service Type';

  @override
  String get newRequestStepLocations => 'Locations';

  @override
  String get newRequestStepSchedule => 'Schedule & Details';

  @override
  String newRequestStepProgress(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get newRequestChooseCategory => 'Choose a category';

  @override
  String get newRequestHelperText =>
      'Pick one or more services. A separate request is created for each.';

  @override
  String get newRequestServiceTypesPlaceholder => 'Choose service types';

  @override
  String get newRequestServiceTypesHelper =>
      'Select one or more services to request from this company.';

  @override
  String get newRequestServiceTypesDone => 'Done';

  @override
  String get newRequestNoServicesAvailable => 'No services available';

  @override
  String get newRequestValidationRequired => 'This field is required';

  @override
  String get newRequestValidationStreetRequired => 'Street is required';

  @override
  String get newRequestValidationCityRequired => 'City is required';

  @override
  String get newRequestValidationCityInvalid => 'Please enter a valid city';

  @override
  String get newRequestValidationCountryRequired => 'Country is required';

  @override
  String get newRequestValidationServiceType =>
      'Please select at least one service';

  @override
  String get newRequestFromTitle => 'From (Pickup)';

  @override
  String get newRequestToTitle => 'To (Drop-off)';

  @override
  String get newRequestStreetLabel => 'Street';

  @override
  String get newRequestStreetPlaceholder => 'Enter street name';

  @override
  String get newRequestCityLabel => 'City';

  @override
  String get newRequestCityPlaceholder => 'Enter city';

  @override
  String get newRequestZipCodeLabel => 'Zip Code';

  @override
  String get newRequestZipCodePlaceholder => 'Enter zip code (optional)';

  @override
  String get newRequestCountryLabel => 'Country';

  @override
  String get newRequestCountryPlaceholder => 'Enter country';

  @override
  String get newRequestPreferredDate => 'Preferred Date';

  @override
  String get newRequestTimeSlot => 'Preferred Time Slot';

  @override
  String get newRequestMorning => 'Morning (8:00 - 12:00)';

  @override
  String get newRequestAfternoon => 'Afternoon (12:00 - 17:00)';

  @override
  String get newRequestEvening => 'Evening (17:00 - 20:00)';

  @override
  String get newRequestNotes => 'Notes';

  @override
  String get newRequestNotesHint => 'Add any additional details...';

  @override
  String get newRequestInfoBox =>
      'Your request will be sent to the company for review. You\'ll receive an offer if approved.';

  @override
  String get newRequestButtonNext => 'Next';

  @override
  String get newRequestButtonBack => 'Back';

  @override
  String get newRequestButtonSubmit => 'Submit Request';

  @override
  String get newRequestSuccessMessage =>
      'Service request(s) submitted successfully!';

  @override
  String get newRequestSubmitting => 'Submitting...';

  @override
  String get newRequestServicesLoadFailed =>
      'Failed to load services. Please try again.';

  @override
  String get homeServices => 'Services';

  @override
  String get moreLabell => 'More';

  @override
  String get homeDashboardTotalOffers => 'Total Offers';

  @override
  String get homeDashboardAcceptedOffers => 'Accepted Offers';

  @override
  String get homeDashboardPendingOffers => 'Pending Offers';

  @override
  String get homeDashboardMyReviews => 'My Reviews';

  @override
  String get homeDashboardLoadFailed => 'Unable to load dashboard metrics.';

  @override
  String get myReviewsPageTitle => 'My Reviews';

  @override
  String get myReviewsEmptyTitle => 'No reviews yet';

  @override
  String get myReviewsEmptyMessage => 'Your posted reviews will appear here.';

  @override
  String get myReviewsEditAction => 'Edit';

  @override
  String get myReviewsDeleteAction => 'Delete';

  @override
  String get myReviewsEditTitle => 'Edit Review';

  @override
  String get myReviewsRatingLabel => 'Rating';

  @override
  String get myReviewsCommentLabel => 'Comment';

  @override
  String get myReviewsCommentHint => 'Share your experience (optional)';

  @override
  String get myReviewsSubmit => 'Save';

  @override
  String get myReviewsCancel => 'Cancel';

  @override
  String get myReviewsDeleteConfirmTitle => 'Delete this review?';

  @override
  String get myReviewsDeleteConfirmMessage => 'This action cannot be undone.';

  @override
  String get myReviewsDeleteConfirmYes => 'Yes, Delete';

  @override
  String get myReviewsDeleteConfirmNo => 'No';

  @override
  String get myReviewsUpdatedSuccess => 'Review updated successfully.';

  @override
  String get myReviewsDeletedSuccess => 'Review deleted successfully.';

  @override
  String get myReviewsValidationRatingRequired => 'Please select a rating.';

  @override
  String get myReviewsLoadFailed =>
      'Unable to load your reviews. Please try again.';

  @override
  String get loadMoreButton => 'Load More';

  @override
  String get noMoreItems => 'No more items';

  @override
  String get chatbotTabLabel => 'Assistant';

  @override
  String get chatbotTitle => 'Wasla Assistant';

  @override
  String get chatbotHint => 'Ask about companies, offers, and services...';

  @override
  String get chatbotNewConversation => 'New Conversation';

  @override
  String get chatbotWelcomeMessage =>
      'Hello! I\'m your Wasla AI assistant. How can I help you today?';

  @override
  String get chatbotRestrictedTitle => 'AI Assistant';

  @override
  String get chatbotRestrictedMessage =>
      'Sign in to chat with our AI assistant and get personalized help.';

  @override
  String get chatbotNewChat => 'New Chat';

  @override
  String get chatbotHistoryTitle => 'Chat History';

  @override
  String get chatbotNoHistory => 'No previous chats';

  @override
  String get chatbotDeleteChat => 'Delete chat?';

  @override
  String get chatbotDeleteConfirm => 'This cannot be undone.';
}
