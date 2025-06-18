import 'dart:io';

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
      Bakery bakery,
      int starRate,
      String recommendBread,
      String content,
      File image
  ) async {
    const userNickName = '닉네임저장필요';

    // Firebase Storage에 이미지 저장
    final fileName = 'review_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imageReference = FirebaseStorage.instance.ref('users/$userID/reviews/$fileName');
    final uploadTask = await imageReference.putFile(image);
    final imageUrl = await uploadTask.ref.getDownloadURL();

    final reviewData = {
      'writerId' : userID,
      'writerNickName' : userNickName,
      'targetId' : bakery.id,
      'recommendBread' : recommendBread,
      'reviewText' : content,
      'rating' : starRate,
      'imageUrl' : imageUrl,
      'createdAt' : FieldValue.serverTimestamp()
    };

    // 리뷰 컬렉션에 리뷰 저장
    final reviewReference = await FirebaseFirestore.instance
        .collection('reviews')
        .add(reviewData);

    // User의 review 목록에 저장
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .update({'reviews' : FieldValue.arrayUnion([reviewReference.id])});
  }
}
