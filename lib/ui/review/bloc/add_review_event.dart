part of 'add_review_bloc.dart';

sealed class AddReviewEvent {
  const AddReviewEvent();
}

/// 별점 입력
class RateStar extends AddReviewEvent {
  final int rate;
  const RateStar({required this.rate});
}