import 'dart:io';

import 'package:bread_place/config/constants/app_enum/review_fetch_type.dart';
import 'package:bread_place/data/dto/response/firebase/bakery_review_dto.dart';
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
    File? image,
  ) async {
    final createdTime = DateTime.now().toIso8601String();

    // Firebase Storage에 이미지 저장
    String? imageUrl;
    if (image != null) {
      final fileName = 'review_$createdTime.jpg';
      final imageReference = FirebaseStorage.instance.ref(
        'users/$userID/reviews/$fileName',
      );
      final uploadTask = await imageReference.putFile(image);
      imageUrl = await uploadTask.ref.getDownloadURL();
    }

    // 리뷰 Documentation 객체 생성
    final reviewData = {
      'writerId': userID,
      'writerNickName': userNickName,
      'bakeryId': bakery.id,
      'bakeryName': bakery.displayName,
      'recommendBread': recommendBread,
      'reviewText': content,
      'rating': starRate,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'createdAt': createdTime,
    };

    // reviews Collection에 Documentation 객체 저장
    final reviewReference = await FirebaseFirestore.instance
        .collection('reviews')
        .add(reviewData);

    // users의 reviews Collection에 리뷰 참조 정보 저장
    await _db
        .collection('users')
        .doc(userID)
        .collection('reviews')
        .doc(reviewReference.id)
        .set({'createdAt': createdTime, 'rating': starRate});

    // bakery의 reviews Collection에 리뷰 참조 정보 저장
    await _db
        .collection('bakery')
        .doc(bakery.id)
        .collection('reviews')
        .doc(reviewReference.id)
        .set({'createdAt': createdTime, 'rating': starRate});
  }

  // 베이커리 리뷰 가져오기
  Future<
    ({List<BakeryReviewDto> reviews, DocumentSnapshot? lastDoc, bool isLast})
  >
  fetchBakeryReview({
    required ReviewFetchType type,
    required String id,
    int limit = 10,
    DocumentSnapshot? lastDoc,
  }) async {
    final reviewReference = switch (type) {
      ReviewFetchType.userId => _db.collection('users').doc(id).collection('reviews'),
      ReviewFetchType.bakeryId => _db.collection('bakery').doc(id).collection('reviews'),
    };

    Query query = reviewReference
        .orderBy('createdAt', descending: false)
        .limit(limit);

    // 페이징 대응
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    // 베이커리의 ReviewID들 획득
    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      return (reviews: <BakeryReviewDto>[], lastDoc: lastDoc, isLast: true);
    }

    // 베이커리의 ReviewID를 통해 리뷰 데이터 획득
    final reviewDocs = await Future.wait(
      snapshot.docs.map((doc) async {
        final reviewId = doc.id;
        final fullReview = await _db.collection('reviews').doc(reviewId).get();

        if (!fullReview.exists) return null;

        final data = fullReview.data()!;
        return BakeryReviewDto.fromJson(data);
      }),
    );

    final lastDocTo = snapshot.docs.last;

    return (
      reviews: reviewDocs.whereType<BakeryReviewDto>().toList(),
      lastDoc: lastDocTo,
      isLast: false,
    );
  }

  // 특정 uid를 가진 사용자의 liked_bakeries 가져오기
  Future<List<LikedBakeryDto>> fetchLikedBakeries(String userId) async {
    final snapshot =
        await _db
            .collection('users')
            .doc(userId)
            .collection('liked_bakeries')
            .orderBy('updatedAt', descending: true)
            .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    final results =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return LikedBakeryDto.fromJson({...data, 'bakeryId': doc.id});
        }).toList();

    return results;
  }

  Future<void> removeLikedBakery(String userId, String bakeryId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('liked_bakeries')
        .doc(bakeryId)
        .delete();
  }

  Future<void> addLikedBakery(
    String userId,
    LikedBakeryDto dto,
    bool isNotificationAllowed,
  ) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('liked_bakeries')
        .doc(dto.bakeryId)
        .set(dto.toJson());
  }

  Future<bool> toggleBakeryNotification(
    String userId,
    String bakeryId,
    bool isNotificationAllowed,
  ) async {
    final DocumentReference bakeryDoc = _db
        .collection('users')
        .doc(userId)
        .collection('liked_bakeries')
        .doc(bakeryId);

    try {
      await bakeryDoc.update({'isNotificationAllowed': isNotificationAllowed});
      return true;
    } catch (e) {
      print("toggleBakeryNotification error : $e");
      return false;
    }
  }

  Future<void> updateUserNicknameByUid({
    required UserDto user,
  }) async {
    final docRef = _db.collection('users').doc(user.uid);

    await docRef.update({
      'nickname': user.nickname,
      'updatedAt': user.updatedAt,
    });
  }

  Future<void> deleteAllUserInfo({
    required String uid,
  }) async {
    final batch = _db.batch();

    final reviewsReference = await _db
        .collection('users')
        .doc(uid)
        .collection('reviews')
        .get();

    for (final doc in reviewsReference.docs){
      final reviewId = doc.id;

      // 1. users/{uid}/reviews/{reviewId} 삭제
      batch.delete(doc.reference);

      // 2. reviews/{reviewId} 삭제
      final reviewReference = _db
          .collection('reviews')
          .doc(reviewId);

      batch.delete(reviewReference);

      // 3. bakery/{bakeryId}/reviews/{reviewId} 삭제
      final reviewDoc = await reviewReference.get();

      if(reviewDoc.exists){
        final data = reviewDoc.data();
        final bakeryId = data?['bakeryId'];

        if(bakeryId != null && bakeryId is String){
          final bakeryReviewReference = _db
              .collection('bakery')
              .doc(bakeryId)
              .collection('reviews')
              .doc(reviewId);

          batch.delete(bakeryReviewReference);
        }

        // 4. 리뷰 이미지 삭제
        final imageUrl = data?['imageUrl'];

        if(imageUrl != null && imageUrl is String){
          final imageReference = FirebaseStorage.instance.refFromURL(imageUrl);
          await imageReference.delete();
        }
      }
    }

    // 5. users/{uid}/liked_bakeries 삭제
    final likedBakeriesReference = await _db
        .collection('users')
        .doc(uid)
        .collection('liked_bakeries')
        .get();

    for (final doc in likedBakeriesReference.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();

    // 6. (users/{uid}) 삭제
    await _db.collection('users')
        .doc(uid)
        .delete();
  }

  // 'users' 컬렉션의 사용자 문서 닉네임 업데이트를 배치에 추가
  void _addUserNicknameUpdateToBatch({
    required WriteBatch batch,
    required UserDto user
  }) {
    final userDocRef = _db.collection('users').doc(user.uid);

    batch.update(userDocRef, {
      'nickname': user.nickname,
      'updatedAt': user.updatedAt,
    });
  }

  // 'reviews' 컬렉션의 모든 리뷰 닉네임 업데이트를 배치에 추가
  Future<void> _addReviewNicknameUpdatesToBatch({
    required WriteBatch batch,
    required String userId,
    required String newNickname,
  }) async {

    final querySnapshot = await _db
        .collection('reviews')
        .where('writerId', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'writerNickName': newNickname});
      }
    }
  }

  // 닉네임 변경 + 기존 리뷰들의 닉네임 업데이트 하는 통합 함수
  Future<void> updateAllUserAndReviewNicknames({required UserDto user}) async {
    final batch = _db.batch();

    try {
      _addUserNicknameUpdateToBatch(batch: batch, user: user);
      await _addReviewNicknameUpdatesToBatch(batch: batch, userId: user.uid, newNickname: user.nickname);

      // 모든 배치 작업을 한 번에 커밋
      await batch.commit();

    } catch (e) {
      print("닉네임 변경 프로세스 중 오류 발생: $e");
      rethrow;
    }
  }
}
