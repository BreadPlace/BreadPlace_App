part of 'bakery_detail_bloc.dart';

abstract class BakeryDetailState extends Equatable {
  const BakeryDetailState();

  @override
  List<Object?> get props => [];
}

class BakeryDetailInitial extends BakeryDetailState {
  final Bakery bakery;
  final List<BakeryReviewEntity>? reviews;
  final FirebasePaginationCursor? cursor;
  final bool isFetchingReviews;
  final bool isLastReview;

  const BakeryDetailInitial({
    required this.bakery,
    this.reviews,
    this.cursor,
    this.isFetchingReviews = false,
    this.isLastReview = false,
  });

  BakeryDetailInitial copyWith({
    Bakery? bakery,
    List<BakeryReviewEntity>? reviews,
    FirebasePaginationCursor? cursor,
    bool? isFetchingReviews,
    bool? isLastReview,
  }) {
    return BakeryDetailInitial(
      bakery: bakery ?? this.bakery,
      reviews: reviews ?? this.reviews,
      cursor: cursor ?? this.cursor,
      isFetchingReviews: isFetchingReviews ?? this.isFetchingReviews,
      isLastReview: isLastReview ?? this.isLastReview
    );
  }

  @override
  List<Object?> get props => [reviews, isFetchingReviews, isLastReview];
}