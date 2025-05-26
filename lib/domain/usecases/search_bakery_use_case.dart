import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/repositories/google_place_repository.dart';

class SearchBakeryUseCase {
  final GooglePlaceRepository _repository;

  SearchBakeryUseCase({required GooglePlaceRepository repository})
    : _repository = repository;

  Future<List<Bakery>> searchPlace(String text) async {
    List<Bakery> bakeryList = [];

    // 장소 정보 검색
    try {
      bakeryList = await _repository.searchText(text);
    } catch (e, trace) {
      print("searchText 에러 $e, $trace");
    }

    // photoUri 할당
    for (final bakery in bakeryList) {
      final photoName = bakery.photoId;
      if (photoName.isNotEmpty) {
        try {
          final photoUri = await _repository.getPlacePhotoUri(photoName);
          bakery.photoUri = photoUri;
        } catch (e, trace) {
          print("photoUri 에러 $e, $trace");
        }
      }
    }

    return bakeryList;
  }
}
