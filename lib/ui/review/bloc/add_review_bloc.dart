import 'dart:io';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/usecases/firestore_use_case.dart';
import 'package:bread_place/domain/usecases/user_local_storage_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'add_review_event.dart';

part 'add_review_state.dart';

class AddReviewBloc extends Bloc<AddReviewEvent, AddReviewState> {
  final FirestoreUseCase _firestoreUseCase;
  final UserLocalStorageUseCase _userLocalStorageUseCase;
  final Bakery _bakery;

  AddReviewBloc({
    required FirestoreUseCase firestoreUseCase,
    required UserLocalStorageUseCase userLocalStorageUseCase,
    required Bakery bakery,
  })
      : _firestoreUseCase = firestoreUseCase,
        _userLocalStorageUseCase = userLocalStorageUseCase,
        _bakery = bakery,
        super(AddReviewState(bakery: bakery)) {
    on<RateStar>(_onRateStar);
    on<AddPhoto>(_onAddPhoto);
    on<SaveReview>(_onSaveReview);
  }

  void _onRateStar(RateStar event, Emitter<AddReviewState> emit) {
    emit(state.copyWith(rate: event.rate));
  }

  Future<void> _onAddPhoto(AddPhoto event, Emitter<AddReviewState> emit) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);

      emit(state.copyWith(
        imageFile: imageFile
      ));
    }
  }

  Future<void> _onSaveReview(SaveReview event, Emitter<AddReviewState> emit) async {
    emit(AddReviewLoading(bakery: _bakery));

    final userID = await _userLocalStorageUseCase.getUserId();
    final starRate = state.rate;
    final imageFile = state.imageFile;
    final recommendBread = event.recommendBread;
    final content = event.content;

    await _firestoreUseCase.uploadBakeryReview(
        userID: userID!,
        bakery: _bakery,
        starRate: starRate,
        recommendBread: recommendBread,
        content: content,
        image: imageFile!,
    );

    emit(AddReviewComplete(bakery: _bakery));
  }
}
