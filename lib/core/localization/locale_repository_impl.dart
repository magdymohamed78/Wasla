import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_repository.dart';

class LocaleRepositoryImpl implements LocaleRepository {
  static const String _localeKey = 'app_locale';
  static const List<String> _supportedLocales = [
    'en',
    'ar',
    'de',
    'fr',
    'it',
    'es',
  ];

  final SharedPreferences _prefs;

  LocaleRepositoryImpl(this._prefs);

  @override
  Future<Locale?> getSavedLocale() async {
    final savedLocale = _prefs.getString(_localeKey);
    if (savedLocale == null) {
      return null;
    }
    if (!_supportedLocales.contains(savedLocale)) {
      return const Locale('en');
    }
    return Locale(savedLocale);
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    final languageCode = locale.languageCode;
    if (_supportedLocales.contains(languageCode)) {
      await _prefs.setString(_localeKey, languageCode);
    } else {
      await _prefs.setString(_localeKey, 'en');
    }
  }
}
