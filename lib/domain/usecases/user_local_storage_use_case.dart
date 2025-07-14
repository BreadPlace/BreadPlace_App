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

  /// 유저 ID 삭제하기
  Future<void> removeUserId() async {
    _repository.removeUserId();
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

  // Note: Index관리하기에 불편하면 사용하지 않고 삭제해도 좋을 것 같습니다.
  Future<void> removeGeofencingLocation(String location) async {
    return _repository.removeGeofencingLocation(location);
  }

  // Note: Index관리하기에 불편하면 사용하지 않고 삭제해도 좋을 것 같습니다.
  Future<void> addGeofencingLocation(String location) async {
    return _repository.addGeofencingLocation(location);
  }
}