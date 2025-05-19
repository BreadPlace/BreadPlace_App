import 'package:bread_place/domain/repositories/kakao_search_repository.dart';
import 'package:bread_place/ui/search/bloc/search_event.dart';
import 'package:bread_place/ui/search/bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final KakaoSearchRepository _repository;

  SearchBloc(this._repository) : super(SearchInitial()) {
    on<SearchPlace>(getSearchPlace);
  }

  Future<void> getSearchPlace(
    SearchPlace event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    final currentPosition = await Geolocator.getCurrentPosition();

    try {
      final results = await _repository.searchPlaces(
        event.keyword,
        currentPosition.longitude.toString(),
        currentPosition.latitude.toString(),
      );
      emit(SearchSuccess(results));
    } catch (e) {}
  }
}
