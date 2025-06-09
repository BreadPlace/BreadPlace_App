part of 'add_review_bloc.dart';

abstract class AddReviewState extends Equatable {
  const AddReviewState();

  @override
  List<Object?> get props => [];
}

class AddReviewInitial extends AddReviewState {
  final Bakery bakery;

  const AddReviewInitial({
    required this.bakery
  });

  @override
  List<Object?> get props => [];
}