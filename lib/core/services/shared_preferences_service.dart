import 'package:shared_preferences/shared_preferences.dart';

/// خدمة التخزين العادي (SharedPreferences)
/// — تُستخدم للبيانات غير الحساسة مثل: onBoarding، إعدادات التطبيق، إلخ
/// — تُمسح تلقائياً عند إلغاء تثبيت التطبيق (على عكس Keychain/Secure Storage)
class SharedPreferencesService {
  // Singleton
  static final SharedPreferencesService _instance =
      SharedPreferencesService._internal();
  factory SharedPreferencesService() => _instance;
  SharedPreferencesService._internal();

  late SharedPreferences _prefs;

  /// يجب استدعاؤه مرة واحدة في main() قبل runApp
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs.getBool(key) ?? defaultValue;

  String? getString(String key) => _prefs.getString(key);

  int? getInt(String key) => _prefs.getInt(key);

  double? getDouble(String key) => _prefs.getDouble(key);

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<void> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  // ── Remove ────────────────────────────────────────────────────────────────

  Future<void> remove(String key) => _prefs.remove(key);

  Future<void> clearAll() => _prefs.clear();

  bool containsKey(String key) => _prefs.containsKey(key);
}
