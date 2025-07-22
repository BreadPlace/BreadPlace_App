import 'package:bread_place/config/constants/app_enum/review_fetch_type.dart';
import 'package:bread_place/domain/entities/bakery_review_entity.dart';
import 'package:bread_place/domain/entities/firebase_pagination_cursor.dart';
import 'package:bread_place/domain/usecases/firestore_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bread_place/domain/entities/bakery.dart';

part 'bakery_detail_event.dart';
part 'bakery_detail_state.dart';

class BakeryDetailBloc extends Bloc<BakeryDetailEvent, BakeryDetailState> {
  final FirestoreUseCase _firestoreUseCase;
  final Bakery _bakery;

  BakeryDetailBloc({
    required FirestoreUseCase firestoreUseCase,
    required Bakery bakery,
  })
      : _firestoreUseCase = firestoreUseCase,
        _bakery = bakery,
        super(BakeryDetailInitial(bakery: bakery)) {
      on<OnFetchReviews>(_getReviews);
      on<OnNewReview>(_onNewReviewAdded);
  }

  Future<void> _getReviews(OnFetchReviews event, Emitter<BakeryDetailState> emit) async {
    final currentState = state as BakeryDetailInitial;

    if(currentState.isFetchingReviews || currentState.isLastReview) {
      return;
    }

    emit(currentState.copyWith(isFetchingReviews: true));

    final response = await _firestoreUseCase.getBakeryReviews(
        type: ReviewFetchType.bakeryId,
        id: _bakery.id,
        cursor: currentState.cursor
    );

    emit(currentState.copyWith(
      reviews: [...(currentState.reviews ?? []), ...response.reviews],
      cursor: response.lastDoc,
      isFetchingReviews: false,
      isLastReview: response.isLast,
    ));
  }

  Future<void> _onNewReviewAdded(OnNewReview event, Emitter<BakeryDetailState> emit) async {
    final currentState = state as BakeryDetailInitial;

    emit(currentState.copyWith(isLastReview: false));
    await _getReviews(OnFetchReviews(), emit);
  }
}