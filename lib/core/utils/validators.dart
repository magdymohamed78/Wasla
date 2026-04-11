class Validators {
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final _uppercaseRegex = RegExp(r'[A-Z]');
  static final _digitRegex = RegExp(r'\d');
  static final _specialCharRegex = RegExp(r'[^a-zA-Z0-9\s]');
  static final _strictSpecialCharRegex = RegExp(r'[!@#\$%\^&\*]');
  static final _phoneRegex = RegExp(r'^\d{11}$');
  // Accepts Latin letters, Arabic letters (U+0600–U+06FF), and spaces
  static final _nameLettersOnlyRegex = RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$');

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'email_empty';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'email_invalid';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'password_empty';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'name_empty';
    }
    if (value.trim().length > 100) {
      return 'name_too_long';
    }
    if (!_nameLettersOnlyRegex.hasMatch(value.trim())) {
      return 'name_letters_only';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (!_phoneRegex.hasMatch(value.trim())) {
      return 'phone_invalid';
    }
    return null;
  }

  static String? validatePasswordLength(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'password_empty';
    }
    if (value.trim().length < 8) {
      return 'password_too_short';
    }
    if (!_uppercaseRegex.hasMatch(value)) {
      return 'password_missing_uppercase';
    }
    if (!_digitRegex.hasMatch(value)) {
      return 'password_missing_number';
    }
    if (!_strictSpecialCharRegex.hasMatch(value)) {
      return 'password_missing_special';
    }
    return null;
  }

  static final _otpRegex = RegExp(r'^\d{6}$');

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'otp_empty';
    }
    if (!_otpRegex.hasMatch(value.trim())) {
      return 'otp_invalid';
    }
    return null;
  }

  static String? validatePasswordMatch(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'confirm_password_empty';
    }
    if (password != confirmPassword) {
      return 'passwords_do_not_match';
    }
    return null;
  }

  static bool hasMinLength(String password) => password.length >= 8;
  static bool hasUppercase(String password) => _uppercaseRegex.hasMatch(password);
  static bool hasNumber(String password) => _digitRegex.hasMatch(password);
  static bool hasSpecialChar(String password) => _strictSpecialCharRegex.hasMatch(password);
}
