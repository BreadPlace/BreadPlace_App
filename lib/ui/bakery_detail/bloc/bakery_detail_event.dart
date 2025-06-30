part of 'bakery_detail_bloc.dart';

sealed class BakeryDetailEvent {
  const BakeryDetailEvent();
}

class OnFetchReviews extends BakeryDetailEvent {}
class OnNewReview extends BakeryDetailEvent {}