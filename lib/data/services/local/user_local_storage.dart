import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorageService {
  late SharedPreferencesWithCache _prefs;

  UserLocalStorageService();

  // Key 상수 정의
  final String _userIdKey = 'userId';
  final String _userNicknameKey = 'userNickname';

  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: <String>{
          _userIdKey,
          _userNicknameKey
        },
      ),
    );
  }

  /// ID
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
    await _prefs.reloadCache();
  }

  Future<String?> getUserId() async {
    return _prefs.getString(_userIdKey);
  }

  Future<void> removeUserId() async {
    await _prefs.remove(_userIdKey);
    await _prefs.reloadCache();
  }


  /// Nickname
  Future<void> saveUserNickname(String userNickname) async {
    await _prefs.setString(_userNicknameKey, userNickname);
    await _prefs.reloadCache();
  }

  Future<String?> getUserNickname() async {
    return _prefs.getString(_userNicknameKey);
  }

  Future<void> removeUserNickname() async {
    await _prefs.remove(_userNicknameKey);
    await _prefs.reloadCache();
  }
}
