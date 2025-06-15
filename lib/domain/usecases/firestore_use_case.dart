import 'dart:io';

import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';

class FirestoreUseCase {
  final FirestoreRepository _repository;

  FirestoreUseCase({required FirestoreRepository repository})
    : _repository = repository;

  /// 베이커리 리뷰 업로드
  Future<void> uploadBakeryReview({
    required String userID,
    required Bakery bakery,
    required int starRate,
    required String recommendBread,
    required String content,
    required File image,
  }) async {
    await _repository.uploadBakeryReview(
        userID,
        bakery,
        starRate,
        recommendBread,
        content,
        image
    );
  }
}
