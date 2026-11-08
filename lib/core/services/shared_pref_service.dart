import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Singleton instance
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Kept for callers that explicitly initialize the storage service.
  void init() {}

  /// Save any type of data (Everything is stored as String in Secure Storage)
  Future<void> saveData(String key, dynamic value) async {
    String valueToSave;

    if (value is String) {
      valueToSave = value;
    } else {
      // تحويل أي نوع بيانات آخر (int, bool, Map, List) إلى JSON String
      valueToSave = jsonEncode(value);
    }

    await _storage.write(key: key, value: valueToSave);
  }

  /// Get data as a String
  Future<String?> getData(String key) async {
    return await _storage.read(key: key);
  }

  /// Get and decode JSON object or specific types (int, bool, etc.)
  Future<dynamic> getDecodedData(String key) async {
    String? value = await _storage.read(key: key);
    if (value == null) return null;

    try {
      return jsonDecode(value);
    } catch (_) {
      // إذا لم يكن نصاً بتنسيق JSON، نرجعه كنص عادي
      return value;
    }
  }

  /// Remove a specific key
  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  /// Clear all secured data (Useful for Logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
