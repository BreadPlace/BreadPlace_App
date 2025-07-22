import 'package:equatable/equatable.dart';

abstract class MyReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBakeryReview extends MyReviewEvent {}