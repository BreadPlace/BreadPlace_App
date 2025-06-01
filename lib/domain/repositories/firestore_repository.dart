import 'package:bread_place/domain/entities/user_entity.dart';

abstract class FirestoreRepository {
  Future<bool> saveUser(UserEntity user);
}