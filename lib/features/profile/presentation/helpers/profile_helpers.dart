import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String valueOrDash(String? value) {
  final normalized = (value ?? '').trim();
  return normalized.isEmpty ? '-' : normalized;
}

String combineCityZip(String? city, String? zipCode) {
  final cityValue = (city ?? '').trim();
  final zipValue = (zipCode ?? '').trim();

  if (cityValue.isEmpty && zipValue.isEmpty) {
    return '-';
  }

  if (cityValue.isNotEmpty && zipValue.isNotEmpty) {
    return '$cityValue, $zipValue';
  }

  return cityValue.isNotEmpty ? cityValue : zipValue;
}

String formatDate(BuildContext context, DateTime? value) {
  if (value == null) {
    return '-';
  }

  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMd(locale).format(value.toLocal());
}
