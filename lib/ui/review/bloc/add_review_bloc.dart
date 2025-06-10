import 'package:bread_place/domain/entities/bakery.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_review_event.dart';

part 'add_review_state.dart';

class AddReviewBloc extends Bloc<AddReviewEvent, AddReviewState> {
  AddReviewBloc(Bakery bakery) : super(AddReviewState(bakery: bakery)) {
    on<RateStar>(_onRateStar);
  }

  void _onRateStar(RateStar event, Emitter<AddReviewState> emit) {
    print('copy: ${event.rate}');
    emit(state.copyWith(rate: event.rate));
  }
}
