import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

const String _secureStorageMigratedKey = 'secure_storage_migrated';

const List<String> _legacyAuthKeys = [
  'auth_token',
  'user_id',
  'customer_id',
  'lead_id',
  'first_name',
  'last_name',
  'user_email',
];

Future<void> _clearLegacyAuthData(SharedPreferences prefs) async {
  final migrated = prefs.getBool(_secureStorageMigratedKey) ?? false;
  if (!migrated) {
    for (final key in _legacyAuthKeys) {
      await prefs.remove(key);
    }
    await prefs.setBool(_secureStorageMigratedKey, true);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  await _clearLegacyAuthData(sharedPreferences);
  runApp(App(sharedPreferences: sharedPreferences));
}
 