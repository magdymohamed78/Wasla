import 'dart:ui';

abstract class LocaleRepository {
  Future<Locale?> getSavedLocale();
  Future<void> saveLocale(Locale locale);
}
