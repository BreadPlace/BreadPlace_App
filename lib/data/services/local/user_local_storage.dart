import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorage {
  static late final SharedPreferencesWithCache _prefs;

  // Key 상수 정의
  static const String _userIdKey = 'userId';

  static Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{_userIdKey},
      ),
    );
  }

  static Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
    await _prefs.reloadCache();
  }

  static Future<String?> getUserId() async {
    return _prefs.getString(_userIdKey);
  }

  static Future<void> removeUserId() async {
    await _prefs.remove(_userIdKey);
    await _prefs.reloadCache();
  }
}
