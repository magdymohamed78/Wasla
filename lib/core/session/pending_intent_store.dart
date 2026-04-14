import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'session_state.dart';

abstract class PendingIntentStore {
  Future<PendingIntent?> read();
  Future<void> save(PendingIntent intent);
  Future<void> clear();
}

class SharedPrefsPendingIntentStore implements PendingIntentStore {
  static const String _pendingIntentKey = 'session.pendingIntent';

  final SharedPreferences _preferences;

  SharedPrefsPendingIntentStore(this._preferences);

  @override
  Future<PendingIntent?> read() async {
    final raw = _preferences.getString(_pendingIntentKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final intent = PendingIntent.fromJson(decoded);
      if (!intent.isValidForContinuation) {
        await clear();
        return null;
      }

      return intent;
    } catch (_) {
      await clear();
      return null;
    }
  }

  @override
  Future<void> save(PendingIntent intent) {
    return _preferences.setString(
      _pendingIntentKey,
      jsonEncode(intent.toJson()),
    );
  }

  @override
  Future<void> clear() {
    return _preferences.remove(_pendingIntentKey);
  }
}
