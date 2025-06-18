part of 'add_review_bloc.dart';

sealed class AddReviewEvent {
  const AddReviewEvent();
}

/// 별점 입력
class RateStar extends AddReviewEvent {
  final int rate;
  const RateStar({required this.rate});
}

/// 사진 추가
class AddPhoto extends AddReviewEvent {
  const AddPhoto();
}

/// 사진 추가
class SaveReview extends AddReviewEvent {
  final String recommendBread;
  final String content;

  const SaveReview({
    required this.recommendBread,
    required this.content,
  });
}