import 'package:bread_place/data/dto/mapper/user_mapper.dart';
import 'package:bread_place/data/services/firebase/firestore_service.dart';
import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirestoreService _service;

  FirestoreRepositoryImpl(this._service);

  @override
  Future<bool> saveUser(UserEntity user) async {
     return await _service.saveUserId(user.toDto());
  }

  @override
  Future<bool> isExistingUser(String uid) async {
      return await _service.isExistingUser(uid);
  }
}