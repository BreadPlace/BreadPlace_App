import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';

class UserLocalStorageUseCase {
  final UserLocalStorageRepository _repository;

  UserLocalStorageUseCase({required UserLocalStorageRepository repository})
      : _repository = repository;

  /// 유저 UID 가져오기
  Future<String?> getUserId() async {
    final userID = await _repository.getUserId();
    return userID;
  }

  /// 유저 닉네임 가져오기
  Future<String?> getUserNickname() async {
    final userNickname = await _repository.getUserNickname();
    return userNickname;
  }

  /// Uid & Nickname & CreatedAt
  Future<void> saveUserData(UserEntity user) async {
    _repository.saveUserData(user);
  }

  UserEntity getUserData() {
    return _repository.getUserData();
  }

  /// GeofencingLocations
  Future<void> saveGeofencingLocations(List<String> locations) async {
    return _repository.saveGeofencingLocations(locations);
  }

  Future<List<String>> getGeofencingLocations() async {
    final locations = _repository.getGeofencingLocations();
    return locations;
  }

  Future<void> removeGeofencingLocationAll() async {
    return _repository.removeGeofencingLocationAll();
  }

  Future<bool> isFirstLaunch() async {
    return _repository.isFirstLaunch();
  }

  Future<void> setLaunched() async {
    return _repository.setLaunched();
  }
}