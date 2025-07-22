import 'package:bread_place/config/constants/app_enum/review_fetch_type.dart';
import 'package:bread_place/domain/usecases/firestore_use_case.dart';
import 'package:bread_place/domain/usecases/user_local_storage_use_case.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_review_event.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyReviewBloc extends Bloc<MyReviewEvent, MyReviewState> {
  final FirestoreUseCase _firestoreUseCase;
  final UserLocalStorageUseCase _userLocalStorageUseCase;

  MyReviewBloc({
    required FirestoreUseCase firestoreUseCase,
    required UserLocalStorageUseCase userLocalStorageUseCase
  })
      : _firestoreUseCase = firestoreUseCase,
        _userLocalStorageUseCase = userLocalStorageUseCase,
        super(MyReviewState(status: MyReviewStatus.initial)) {
    on<FetchBakeryReview>(_getReviews);
  }


  Future<void> _getReviews(FetchBakeryReview event, Emitter<MyReviewState> emit) async {
    if(state.status == MyReviewStatus.loading || state.isLastReview) {
      return;
    }

    emit(state.copyWith(status: MyReviewStatus.loading));

    final uid = await _userLocalStorageUseCase.getUserId();
    if(uid == null){
      emit(state.copyWith(status: MyReviewStatus.error));
      return;
    }

    final response = await _firestoreUseCase.getBakeryReviews(
        type: ReviewFetchType.userId,
        id: uid,
        cursor: state.cursor
    );

    emit(state.copyWith(
      reviews: [...state.reviews, ...response.reviews],
      cursor: response.lastDoc,
      status: MyReviewStatus.success,
      isLastReview: response.isLast,
    ));
  }
}