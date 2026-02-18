import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../locale_repository.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final LocaleRepository _localeRepository;

  LocaleCubit(this._localeRepository)
      : super(const LocaleState(locale: Locale('en')));

  Future<void> init() async {
    final savedLocale = await _localeRepository.getSavedLocale();
    if (savedLocale != null) {
      emit(LocaleState(locale: savedLocale));
    }
  }

  Future<void> changeLocale(Locale locale) async {
    await _localeRepository.saveLocale(locale);
    emit(LocaleState(locale: locale));
  }
}
