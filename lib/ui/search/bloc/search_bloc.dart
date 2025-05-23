import 'package:bread_place/domain/repositories/google_place_repository.dart';
import 'package:bread_place/ui/search/bloc/search_event.dart';
import 'package:bread_place/ui/search/bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GooglePlaceRepository _repository;

  SearchBloc(this._repository) : super(SearchInitial()) {
    on<SearchPlace>(onSearchPlace);
  }

  Future<void> onSearchPlace(
    SearchPlace event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    try {
      final results = await _repository.searchText(event.keyword);
      emit(SearchSuccess(bakeries: results));
    } catch (e) {}
  }
}
