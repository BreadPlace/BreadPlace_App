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
}