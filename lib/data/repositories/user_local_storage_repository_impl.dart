import 'package:bread_place/data/dto/mapper/user_mapper.dart';
import 'package:bread_place/data/services/local/user_local_storage.dart';
import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';

class UserLocalStorageRepositoryImpl implements UserLocalStorageRepository {
  final UserLocalStorageService _service;
  UserLocalStorageRepositoryImpl(this._service);

  @override
  Future<String?> getUserId() {
    return _service.getUserId();
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
  Future<void> saveUserNickname(String userNickname) {
    return _service.saveUserNickname(userNickname);
  }

  @override
  Future<void> removeUserData() async {
    await _service.removeUserData();
  }

  @override
  Future<void> saveUserData(UserEntity user) async {
    await _service.saveUserData(user.toDto());
  }

  @override
  UserEntity getUserData() {
    return _service.getUserData().toEntity();
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
  Future<bool> isFirstLaunch() {
    return _service.isFirstLaunch();
  }

  @override
  Future<void> setLaunched() {
    return _service.setLaunched();
  }
}