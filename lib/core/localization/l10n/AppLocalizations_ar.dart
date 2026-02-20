// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'AppLocalizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get onboardingLogIn => 'تسجيل الدخول';

  @override
  String get onboardingNewUser => 'مستخدم جديد';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get supportPageTitle => 'الدعم';

  @override
  String get supportPageDescription =>
      'للدعم، يرجى التواصل معنا على support@wasla.com';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginEmail => 'البريد الإلكتروني';

  @override
  String get loginPassword => 'كلمة المرور';

  @override
  String get loginRememberMe => 'تذكرني';

  @override
  String get loginForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginSignIn => 'تسجيل الدخول';

  @override
  String get loginSignUp => 'ليس لديك حساب؟ سجل الآن';

  @override
  String get loginSignUpAction => 'سجل الآن';

  @override
  String get loginInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get loginEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get loginPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get loginEmailInvalid => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get loginUnexpectedError =>
      'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get loginNoConnection =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.';

  @override
  String get loginRateLimited => 'محاولات كثيرة. يرجى المحاولة لاحقاً.';

  @override
  String get loginSessionExpired => 'انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.';
}
