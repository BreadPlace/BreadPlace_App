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
}