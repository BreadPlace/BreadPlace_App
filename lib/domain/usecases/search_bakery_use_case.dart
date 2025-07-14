import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/repositories/google_place_repository.dart';
import 'package:bread_place/utils/async_utils.dart';

class SearchBakeryUseCase {
  final GooglePlaceRepository _repository;

  SearchBakeryUseCase({required GooglePlaceRepository repository})
    : _repository = repository;

  /// 키워드, 텍스트 등으로 장소 검색
  Future<List<Bakery>> searchPlace(String text) async {
    List<Bakery> bakeryList = [];

    // 장소 정보 검색
    try {
      bakeryList = await _repository.searchText(text);
    } catch (e, trace) {
      print("searchText 에러 $e, $trace");
    }

    // photoUri 할당
    final assignedBakeries = await Future.wait(
      bakeryList.map(_getPhotoUriAssignedBakery),
    );

    return assignedBakeries;
  }

  Future<List<Bakery>> searchNearBy({
    required double latitude,
    required double longitude,
  }) async {
    final bakeryList = await _repository.searchNearBy(latitude: latitude, longitude: longitude);

    // photoUri 할당
    final assignedBakeries = await AsyncUtils.withBatchLimit(
        itemList: bakeryList,
        mapper: _getPhotoUriAssignedBakery
    );

    return assignedBakeries;
  }

  /// 구글 PlaceId 와 일치하는 장소 검색
  Future<Bakery?> searchPlaceById(String placeId) async {
    try {
      // 장소 정보 검색
      final bakery = await _repository.searchPlaceDetail(placeId);

      // photoUri 할당
      final assignedBakery = await _getPhotoUriAssignedBakery(bakery);

      return assignedBakery;
    } catch (e, trace) {
      print("searchPlaceById 에러 $e, $trace");
      return null;
    }
  }

  Future<Bakery> _getPhotoUriAssignedBakery(Bakery bakery) async {
    if(bakery.photoId.isEmpty) return bakery;

    try {
      final photoUri = await _repository.getPlacePhotoUri(bakery.photoId);
      return bakery.copyWith(photoUri: photoUri);
    } catch(e, trace) {
      print("photoUri 에러 $e, $trace");
      return bakery;
    }
  }
}