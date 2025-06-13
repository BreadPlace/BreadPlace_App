abstract class UserLocalStorageRepository {
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> removeUserId();
}