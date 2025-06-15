import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save a string value to storage
  static Future<void> setStorage(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Get a string value from storage
  static String? getStorage(String key) {
    return _prefs?.getString(key);
  }

  /// Remove a value from storage
  static Future<void> removeStorage(String key) async {
    await _prefs?.remove(key);
  }

  /// Clear all stored values
  static Future<void> clearStorage() async {
    await _prefs?.clear();
  }
}
