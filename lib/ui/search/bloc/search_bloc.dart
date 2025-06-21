import 'package:bread_place/domain/usecases/search_bakery_use_case.dart';
import 'package:bread_place/ui/search/bloc/search_event.dart';
import 'package:bread_place/ui/search/bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchBakeryUseCase _useCase;

  SearchBloc(this._useCase) : super(SearchInitial()) {
    on<SearchPlaceByText>(_onSearchPlaceByText);
    on<SearchPlaceById>(_onSearchPlaceById);
  }

  Future<void> _onSearchPlaceByText(
    SearchPlaceByText event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    try {
      final results = await _useCase.searchPlace(event.keyword);
      emit(SearchSuccess(bakeries: results));
    } catch (e) {
      emit(SearchFailure("text 로 장소 검색 실패: ${e.toString()}"));
    }
  }

  Future<void> _onSearchPlaceById(
    SearchPlaceById event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    final result = await _useCase.searchPlaceById(event.placeId);

    if (result == null) {
      emit(SearchFailure("id로 장소 검색 실패"));
    } else {

      emit(SearchSuccess(bakeries: [result]));
    }
  }
}
