import 'dart:io';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/entities/bakery_review_entity.dart';
import 'package:bread_place/domain/entities/liked_bakery_entity.dart';
import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/entities/firebase_pagination_cursor.dart';

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
  Future<({List<BakeryReviewEntity> reviews, FirebasePaginationCursor? lastDoc, bool isLast})> fetchBakeryReviews({
    required Bakery bakery,
    FirebasePaginationCursor? cursor
  });
  Future<void> addLiked(String userId, LikedBakeryEntity bakery, bool isNotificationAllowed);
  Future<void> removeLiked(String userId, String bakeryId);
  Future<List<LikedBakeryEntity>> fetchLikedBakeries(String userId);
  Future<bool> toggleBakeryNotification(String userId, String bakeryId, bool isNotificationAllowed);
  Future<void> updateUserNickname(UserEntity user);
}