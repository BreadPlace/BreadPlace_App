import 'package:bread_place/domain/entities/user_entity.dart';

abstract class UserLocalStorageRepository {
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> saveUserNickname(String userNickname);
  Future<String?> getUserNickname();
  Future<void> saveUserData(UserEntity user);
  Future<void> removeUserData();
  UserEntity getUserData();

  // GeofencingLocations
  Future<void>saveGeofencingLocations(List<String> locations);
  Future<List<String>>getGeofencingLocations();
  Future<void>removeGeofencingLocationAll();
  Future<void>removeGeofencingLocation(String location);
  Future<void>addGeofencingLocation(String location);
}