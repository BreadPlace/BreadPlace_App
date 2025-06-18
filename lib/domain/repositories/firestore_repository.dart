import 'dart:io';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/entities/user_entity.dart';

abstract class FirestoreRepository {
  Future<bool> saveUser(UserEntity user);
  Future<UserEntity?> fetchUserDataByUid(String uid);
  Future<void> uploadBakeryReview(
      String userID,
      Bakery bakery,
      int starRate,
      String recommendBread,
      String content,
      File image
  );
}