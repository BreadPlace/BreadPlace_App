import 'dart:io';

import 'package:bread_place/config/constants/app_enum/review_fetch_type.dart';
import 'package:bread_place/data/dto/mapper/bakery_review_mapper.dart';
import 'package:bread_place/data/dto/mapper/liked_bakery_mapper.dart';
import 'package:bread_place/data/dto/mapper/user_mapper.dart';
import 'package:bread_place/data/services/firebase/firestore_service.dart';
import 'package:bread_place/data/services/image/image_compress_service.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/entities/bakery_review_entity.dart';
import 'package:bread_place/domain/entities/liked_bakery_entity.dart';
import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/entities/firebase_pagination_cursor.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirestoreService _service;
  final ImageCompressService _imageCompressService;

  FirestoreRepositoryImpl({
    required FirestoreService service,
    required ImageCompressService imageCompressService,
  }) : _service = service,
       _imageCompressService = imageCompressService;

  @override
  Future<bool> saveUser(UserEntity user) async {
    return await _service.saveUserId(user.toDto());
  }

  @override
  Future<UserEntity?> fetchUserDataByUid(String uid) async {
    final userDto = await _service.fetchUserDataByUid(uid);
    if (userDto != null) {
      return userDto.toEntity();
    }
    return null;
  }

  Future<void> uploadBakeryReview(
    String userID,
    String userNickName,
    Bakery bakery,
    int starRate,
    String recommendBread,
    String content,
    File? image,
  ) async {
    File? compressedImage;

    if (image != null) {
      compressedImage = await _imageCompressService.compressImage(image: image);
    }

    await _service.uploadBakeryReview(
      userID,
      userNickName,
      bakery,
      starRate,
      recommendBread,
      content,
      compressedImage,
    );
  }

  @override
  Future<List<LikedBakeryEntity>> fetchLikedBakeries(String userId) async {
    final likedBakeries = await _service.fetchLikedBakeries(userId);
    return likedBakeries.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addLiked(String userId, LikedBakeryEntity bakery, bool isNotificationAllowed) async {
    final dto = bakery.toDto();
    await _service.addLikedBakery(userId, dto, isNotificationAllowed);
  }

  @override
  Future<void> removeLiked(String userId, String bakeryId) async {
    await _service.removeLikedBakery(userId, bakeryId);
  }

  // 베이커리 리뷰 가져오기
  @override
  Future<({List<BakeryReviewEntity> reviews, FirebasePaginationCursor? lastDoc, bool isLast})> fetchBakeryReviews({
    required ReviewFetchType type,
    required String id,
    FirebasePaginationCursor? cursor
  }) async {

    // 페이징 객체로 변환
    final lastDoc = cursor?.raw is DocumentSnapshot
        ? cursor!.raw as DocumentSnapshot
        : null;

    final response = await _service.fetchBakeryReview(
        type: type,
        id: id,
        lastDoc: lastDoc
    );

    final reviewsDto = response.reviews;
    final reviewEntity = reviewsDto.map((review) => review.toEntity()).toList();
    final fetchedLastDoc = FirebasePaginationCursor(response.lastDoc);

    return (reviews: reviewEntity, lastDoc: fetchedLastDoc, isLast: response.isLast);
  }

  @override
  Future<bool> toggleBakeryNotification(String userId, String bakeryId, bool isNotificationAllowed) {
    return _service.toggleBakeryNotification(userId, bakeryId, isNotificationAllowed);
  }

  @override
  Future<void> updateUserNickname(UserEntity user) async {
    await _service.updateUserNicknameByUid(user: user.toDto());
  }

  @override
  Future<void> deleteAllUserInfo(String uid) async {
    await _service.deleteAllUserInfo(uid: uid);
  }
}
