import 'dart:io';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/entities/liked_bakery_entity.dart';
import 'package:bread_place/domain/entities/user_entity.dart';

abstract class FirestoreRepository {
  Future<bool> saveUser(UserEntity user);
  Future<UserEntity?> fetchUserDataByUid(String uid);
  Future<void> uploadBakeryReview(
      String userID,
      String userNickName,
      Bakery bakery,
      int starRate,
      String recommendBread,
      String content,
      File? image
  );
  Future<void> addLiked(String userId, LikedBakeryEntity bakery, bool isNotify);
  Future<void> removeLiked(String userId, String bakeryId);
  Future<List<LikedBakeryEntity>> fetchLikedBakeries(String userId);
}