import 'package:bread_place/domain/entities/bakery_review_entity.dart';
import 'package:bread_place/domain/entities/firebase_pagination_cursor.dart';

enum MyReviewStatus { initial, loading, success, empty, error }

class MyReviewState {
  final MyReviewStatus status;
  final List<BakeryReviewEntity> reviews;
  final FirebasePaginationCursor? cursor;
  final bool isLastReview;

  const MyReviewState({
    required this.status,
    this.reviews = const [],
    this.cursor,
    this.isLastReview = false,
  });

  MyReviewState copyWith({
    MyReviewStatus? status,
    List<BakeryReviewEntity>? reviews,
    FirebasePaginationCursor? cursor,
    bool? isLastReview,
  }) {
    return MyReviewState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      cursor: cursor ?? this.cursor,
      isLastReview: isLastReview ?? this.isLastReview,
    );
  }
}
