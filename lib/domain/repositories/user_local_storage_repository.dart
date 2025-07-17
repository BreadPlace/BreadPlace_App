abstract class UserLocalStorageRepository {
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> removeUserId();
  Future<void> saveUserNickname(String userNickname);
  Future<String?> getUserNickname();
  Future<void> removeUserNickname();
  Future<void> saveUserIdAndNickname(String userId, String userNickname);
  Future<void> removeUserIdAndNickname();

  // GeofencingLocations
  Future<void>saveGeofencingLocations(List<String> locations);
  Future<List<String>>getGeofencingLocations();
  Future<void>removeGeofencingLocationAll();
  Future<void>removeGeofencingLocation(String location);
  Future<void>addGeofencingLocation(String location);
}