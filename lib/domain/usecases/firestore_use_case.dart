import 'dart:io';

import 'package:bread_place/config/constants/app_enum/review_fetch_type.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/entities/bakery_review_entity.dart';
import 'package:bread_place/domain/entities/firebase_pagination_cursor.dart';
import 'package:bread_place/domain/entities/recommend_bakery_entity.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';

class FirestoreUseCase {
  final FirestoreRepository _repository;

  FirestoreUseCase({required FirestoreRepository repository})
    : _repository = repository;

  /// 베이커리 리뷰 업로드
  Future<void> uploadBakeryReview({
    required String userID,
    required String userNickName,
    required Bakery bakery,
    required int starRate,
    required String recommendBread,
    required String content,
    required File? image,
  }) async {
    await _repository.uploadBakeryReview(
        userID,
        userNickName,
        bakery,
        starRate,
        recommendBread,
        content,
        image
    );
  }

  /// 베이커리 리뷰 가져오기
  Future<({List<BakeryReviewEntity> reviews, FirebasePaginationCursor? lastDoc, bool isLast})> getBakeryReviews({
    required ReviewFetchType type,
    required String id,
    FirebasePaginationCursor? cursor,
  }) async {
    return await _repository.fetchBakeryReviews(type: type, id: id, cursor: cursor);
  }

  /// 추천 베이커리 가져오기
  Future<RecommendBakeryEntity> fetchRecommendBakery() async {
    return await _repository.fetchRecommendBakery();
  }
}
