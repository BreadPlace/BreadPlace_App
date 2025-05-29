import 'package:bread_place/domain/usecases/search_bakery_use_case.dart';
import 'package:bread_place/ui/search/bloc/search_event.dart';
import 'package:bread_place/ui/search/bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchBakeryUseCase _useCase;

  SearchBloc(this._useCase) : super(SearchInitial()) {
    on<SearchPlace>(onSearchPlace);
  }

  Future<void> onSearchPlace(
    SearchPlace event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    try {
      final results = await _useCase.searchPlace(event.keyword);
      emit(SearchSuccess(bakeries: results));
    } catch (e) {
      emit(SearchFailure("검색 실패: ${e.toString()}"));
    }
  }
}
