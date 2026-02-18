import 'package:flutter/widgets.dart';

class LocaleState {
  final Locale locale;

  const LocaleState({required this.locale});

  LocaleState copyWith({Locale? locale}) {
    return LocaleState(
      locale: locale ?? this.locale,
    );
  }
}
