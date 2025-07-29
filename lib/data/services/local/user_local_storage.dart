import 'package:bread_place/data/dto/response/firebase/user_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorageService {
  late SharedPreferencesWithCache _prefs;

  UserLocalStorageService();

  // Key 상수 정의
  final String _userIdKey = 'userId';
  final String _userNicknameKey = 'userNickname';
  final String _userCreatedAtKey = 'userCreatedAt';
  final String _geofencingLocationsKey = 'geofencingLocationsKey';
  final String _firstLaunchKey = 'is_first_launch';

  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: <String>{
          _userIdKey,
          _userNicknameKey,
          _userCreatedAtKey,
          _geofencingLocationsKey,
          _firstLaunchKey
        },
      ),
    );
  }

  // 앱 최초 실행 여부 확인
  Future<bool> isFirstLaunch() async {
    final isFirst = _prefs.getBool(_firstLaunchKey);
    return isFirst ?? true;
  }

  // 최초 실행 이후 플래그 저장
  Future<void> setLaunched() async {
    await _prefs.setBool(_firstLaunchKey, false);
  }

  /// ID
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
    await _prefs.reloadCache();
  }

  Future<String?> getUserId() async {
    return _prefs.getString(_userIdKey);
  }

  /// Nickname
  Future<void> saveUserNickname(String userNickname) async {
    await _prefs.setString(_userNicknameKey, userNickname);
    await _prefs.reloadCache();
  }

  Future<String?> getUserNickname() async {
    return _prefs.getString(_userNicknameKey);
  }

  /// CreatedAt
  Future<void> saveUserCreatedAt(String userCreatedAt) async {
    await _prefs.setString(_userCreatedAtKey, userCreatedAt);
    await _prefs.reloadCache();
  }

  /// ID, Nickname, CreatedAt
  UserDto getUserData() {
    String uid = _prefs.getString(_userIdKey) ?? '';
    String nickname = _prefs.getString(_userNicknameKey) ?? '닉네임 정보 없음';
    String createdAt = _prefs.getString(_userCreatedAtKey) ?? '생성일 정보 없음';

    return UserDto(uid: uid, nickname: nickname, createdAt: createdAt);
  }

  Future<void> saveUserData(UserDto user) async {
    await _prefs.setString(_userIdKey, user.uid);
    await _prefs.setString(_userNicknameKey, user.nickname);
    await _prefs.setString(_userCreatedAtKey, user.createdAt);
    await _prefs.reloadCache();
  }

  Future<void> removeUserData() async {
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userNicknameKey);
    await _prefs.remove(_userCreatedAtKey);
    await _prefs.reloadCache();
  }

  /// GeofencingLocations
  Future<void> saveGeofencingLocations(List<String> locations) async {
    await _prefs.setStringList(_geofencingLocationsKey, locations);
    await _prefs.reloadCache();
  }

  Future<List<String>> getGeofencingLocations() async {
    return _prefs.getStringList(_geofencingLocationsKey) ?? [];
  }

  Future<void> removeGeofencingLocationAll() async {
    await _prefs.remove(_geofencingLocationsKey);
    await _prefs.reloadCache();
  }
}
