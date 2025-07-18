import 'package:bread_place/data/services/local/user_local_storage.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';

class UserLocalStorageRepositoryImpl implements UserLocalStorageRepository {
  final UserLocalStorageService _service;
  UserLocalStorageRepositoryImpl(this._service);

  @override
  Future<String?> getUserId() {
    return _service.getUserId();
  }

  @override
  Future<void> removeUserId() {
    return _service.removeUserId();
  }

  @override
  Future<void> saveUserId(String userId) {
    return _service.saveUserId(userId);
  }

  @override
  Future<String?> getUserNickname() {
    return _service.getUserNickname();
  }

  @override
  Future<void> removeUserNickname() {
    return _service.removeUserNickname();
  }

  @override
  Future<void> saveUserNickname(String userNickname) {
    return _service.saveUserNickname(userNickname);
  }

  @override
  Future<void> saveUserIdAndNickname(String userId, String userNickname) {
    return _service.saveUserIdAndNickname(userId, userNickname);
  }

  @override
  Future<void> removeUserIdAndNickname() {
    return _service.removeUserIdAndNickname();
  }

  // Geofencing
  @override
  Future<void> saveGeofencingLocations(List<String> locations) {
    return _service.saveGeofencingLocations(locations);
  }

  @override
  Future<List<String>> getGeofencingLocations() {
    return _service.getGeofencingLocations();
  }

  @override
  Future<void> removeGeofencingLocationAll() {
    return _service.removeGeofencingLocationAll();
  }

  @override
  Future<void> removeGeofencingLocation(String location) {
    return _service.removeGeofencingLocation(location);
  }

  @override
  Future<void> addGeofencingLocation(String location) {
    return _service.addGeofencingLocation(location);
  }
}