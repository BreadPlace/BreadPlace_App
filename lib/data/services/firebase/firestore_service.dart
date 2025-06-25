import 'dart:io';

import 'package:bread_place/data/dto/response/firebase/liked_bakery_dto.dart';
import 'package:bread_place/data/dto/response/firebase/user_dto.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService(this._db);

  // 저장되지 않은 사용자라면 신규 저장
  Future<bool> saveUserId(UserDto user) async {
    try {
      final data = await fetchUserDataByUid(user.uid);

      if (data != null) {
        return false;
      }

      // 새로운 사용자 등록
      await _db.collection('users').doc(user.uid).set(user.toJson());
      return true;
    } catch (e) {
      print("사용자 저장 중 오류: $e");
      return false;
    }
  }

  // 특정 uid를 가진 사용자를 조회
  Future<UserDto?> fetchUserDataByUid(String uid) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('users').doc(uid).get();

      if (!snapshot.exists) {
        print("파이어베이스에 등록되지 않은 uid 입니다: $uid");
        return null;
      }

      final data = snapshot.data() as Map<String, dynamic>;
      return UserDto.fromJson(data);
    } catch (e) {
      print("사용자 정보 조회 중 오류 발생 (UID: $uid): $e");
      return null;
    }
  }

  // 특정 uid를 가진 유저에 베이커리 리뷰 추가
  Future<void> uploadBakeryReview(
      String userID,
      String userNickName,
      Bakery bakery,
      int starRate,
      String recommendBread,
      String content,
      File? image
  ) async {

    // Firebase Storage에 이미지 저장
    String? imageUrl;
    if (image != null) {
      final fileName = 'review_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageReference = FirebaseStorage.instance.ref('users/$userID/reviews/$fileName');
      final uploadTask = await imageReference.putFile(image);
      imageUrl = await uploadTask.ref.getDownloadURL();
    }

    // 리뷰 객체 생성
    final reviewData = {
      'writerId' : userID,
      'writerNickName' : userNickName,
      'targetId' : bakery.id,
      'recommendBread' : recommendBread,
      'reviewText' : content,
      'rating' : starRate,
      if (imageUrl != null) 'imageUrl' : imageUrl,
      'createdAt' : FieldValue.serverTimestamp()
    };

    // 리뷰 컬렉션에 리뷰 저장
    final reviewReference = await FirebaseFirestore.instance
        .collection('reviews')
        .add(reviewData);

    // User의 review 목록에 저장
    await FirebaseFirestore.instance.collection('users').doc(userID).update({
      'reviews': FieldValue.arrayUnion([reviewReference.id]),
    });

    // 베이커리 경로 참조
    final bakeryReviewDocReference = FirebaseFirestore.instance
        .collection('bakeryReviews')
        .doc(bakery.id);

    // 베이커리에 대한 문서가 존재하는지 확인
    final snapShot = await bakeryReviewDocReference.get();

    if(snapShot.exists) {
      // 문서가 있을 경우 리뷰 ID 추가
      await bakeryReviewDocReference.update({
        'reviews': FieldValue.arrayUnion([reviewReference.id]),
      });
    } else {
      // 문서가 없을 경우 문서 생성 후 리뷰 ID 배열 추가
      await bakeryReviewDocReference.set({
        'reviews': [reviewReference.id]
      });
    }
  }

  // 특정 uid를 가진 사용자의 liked_bakeries 가져오기
  Future<List<LikedBakeryDto>> fetchLikedBakeries(String userId) async {
    final snapshot = await _db.collection('users').doc(userId).collection(
        'liked_bakeries')
        .orderBy('updatedAt', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    final results = snapshot.docs.map((doc) {
      final data = doc.data();
      return LikedBakeryDto.fromJson({
        ...data,
        'bakeryId': doc.id
      });
    }).toList();

    return results;
  }

  Future<void> removeLikedBakery(String userId, String bakeryId) async {
    await _db.collection('users').doc(userId)
        .collection('liked_bakeries').doc(bakeryId)
        .delete();
  }

  Future<void> addLikedBakery(String userId, LikedBakeryDto dto,
      bool isNotify) async {
    await _db.collection('users').doc(userId)
        .collection('liked_bakeries').doc(dto.bakeryId)
        .set(dto.toJson());
  }
}
