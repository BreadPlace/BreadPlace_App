part of 'add_review_bloc.dart';

class AddReviewState extends Equatable {
  final Bakery bakery;
  final int rate;
  final File? imageFile;

  const AddReviewState({
    required this.bakery,
    this.rate = 5,
    this.imageFile
  });

  @override
  List<Object?> get props => [bakery, rate, imageFile];
}

extension AddReviewCopy on AddReviewState {
  AddReviewState copyWith(
      {
        Bakery? bakery,
        int? rate,
        File? imageFile,
      }) {
    return AddReviewState(
      bakery: bakery ?? this.bakery,
      rate: rate ?? this.rate,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}