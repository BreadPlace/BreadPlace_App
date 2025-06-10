part of 'add_review_bloc.dart';

class AddReviewState extends Equatable {
  final Bakery bakery;
  final int rate;

  const AddReviewState({required this.bakery, this.rate = 5});

  @override
  List<Object?> get props => [bakery, rate];
}

extension AddReviewCopy on AddReviewState {
  AddReviewState copyWith(
      {
        Bakery? bakery,
        int? rate
      }) {
    return AddReviewState(
      bakery: bakery ?? this.bakery,
      rate: rate ?? this.rate,
    );
  }
}