abstract class UserLocalStorageRepository {
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> removeUserId();
  Future<void> saveUserNickname(String userNickname);
  Future<String?> getUserNickname();
  Future<void> removeUserNickname();
}