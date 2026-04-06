import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../core/constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Ensure preferences are initialized
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Token Management
  Future<void> saveToken(String token) async {
    await prefs.setString(AppConstants.tokenKey, token);
  }

  String? getToken() {
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<void> clearToken() async {
    await prefs.remove(AppConstants.tokenKey);
  }

  bool hasToken() {
    return prefs.containsKey(AppConstants.tokenKey);
  }

  // User Data Management
  Future<void> saveUser(Map<String, dynamic> userData) async {
    await prefs.setString(AppConstants.userKey, jsonEncode(userData));
  }

  Map<String, dynamic>? getUser() {
    final userString = prefs.getString(AppConstants.userKey);
    if (userString != null) {
      try {
        return jsonDecode(userString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> clearUser() async {
    await prefs.remove(AppConstants.userKey);
  }

  bool hasUser() {
    return prefs.containsKey(AppConstants.userKey);
  }

  // Theme Management
  Future<void> saveThemeMode(String themeMode) async {
    await prefs.setString(AppConstants.themeKey, themeMode);
  }

  String? getThemeMode() {
    return prefs.getString(AppConstants.themeKey);
  }

  Future<void> clearThemeMode() async {
    await prefs.remove(AppConstants.themeKey);
  }

  // Generic Storage Methods
  Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  Future<void> saveInt(String key, int value) async {
    await prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  Future<void> saveStringList(String key, List<String> value) async {
    await prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  Future<void> remove(String key) async {
    await prefs.remove(key);
  }

  Future<void> clear() async {
    await prefs.clear();
  }

  bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  // Authentication/// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return hasToken() && hasUser();
  }

  Future<void> logout() async {
    await Future.wait([
      clearToken(),
      clearUser(),
    ]);
  }

  // Cache Management
  Future<void> cacheData(String key, dynamic data, {Duration? expiration}) async {
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiration': expiration?.inMilliseconds,
    };
    await saveString(key, jsonEncode(cacheData));
  }

  Future<T?> getCachedData<T>(String key, T Function(dynamic) fromJson) async {
    final cacheString = getString(key);
    if (cacheString == null) return null;

    try {
      final cacheData = jsonDecode(cacheString) as Map<String, dynamic>;
      final timestamp = cacheData['timestamp'] as int;
      final expiration = cacheData['expiration'] as int?;

      if (expiration != null) {
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        if (currentTime - timestamp > expiration) {
          await remove(key); // Remove expired cache
          return null;
        }
      }

      return fromJson(cacheData['data']);
    } catch (e) {
      return null;
    }
  }

  // Search History
  Future<void> saveSearchHistory(String query) async {
    final history = getStringList('search_history') ?? [];
    history.remove(query); // Remove if exists
    history.insert(0, query); // Add to beginning
    if (history.length > 10) {
      history.removeLast(); // Keep only last 10
    }
    await saveStringList('search_history', history);
  }

  List<String> getSearchHistory() {
    return getStringList('search_history') ?? [];
  }

  Future<void> clearSearchHistory() async {
    await remove('search_history');
  }

  // Recently Viewed
  Future<void> saveRecentlyViewed(String itemId, {int maxItems = 20}) async {
    final recent = getStringList('recently_viewed') ?? [];
    recent.remove(itemId); // Remove if exists
    recent.insert(0, itemId); // Add to beginning
    if (recent.length > maxItems) {
      recent.removeLast();
    }
    await saveStringList('recently_viewed', recent);
  }

  List<String> getRecentlyViewed() {
    return getStringList('recently_viewed') ?? [];
  }

  Future<void> clearRecentlyViewed() async {
    await remove('recently_viewed');
  }
}
