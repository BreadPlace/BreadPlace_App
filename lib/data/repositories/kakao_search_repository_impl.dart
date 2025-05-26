import 'package:bread_place/data/services/api/kakao/kakao_local_api.dart';
import 'package:bread_place/domain/entities/kakao_group_code.dart';
import 'package:bread_place/domain/entities/place.dart';
import 'package:bread_place/domain/repositories/kakao_search_repository.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class KakaoSearchRepositoryImpl implements KakaoSearchRepository {
  final KakaoLocalApi _kakaoLocalApi;

  KakaoSearchRepositoryImpl({required KakaoLocalApi kakaoLocalApi})
    : _kakaoLocalApi = kakaoLocalApi;

  @override
  Future<List<Place>> searchPlaces(String query, String? x, String? y) async {
    final response = await _kakaoLocalApi.searchPlaces(
      query: query,
      x: x,
      y: y,
    );

    // 카페(CE7) 또는 음식점(FD6) 중에서
    // 이름이나 카테고리에 "빵", "베이커리"가 포함된 것만 필터링
    final filteredResults = response.documents.where((doc) {
      final isBakeryGroup =
          doc.categoryGroupCode == 'CE7' || doc.categoryGroupCode == 'FD6';
      final isBakeryCategoryName =
          doc.categoryName.contains('베이커리') || doc.categoryName.contains('제과');
      final hasBakeryKeyword =
          doc.placeName.contains('빵') ||
          doc.placeName.contains('베이커리') ||
          doc.placeName.contains('제과') ||
          doc.placeName.contains('디저트');

      return isBakeryGroup && (isBakeryCategoryName || hasBakeryKeyword);
    });

    // DTO -> Entity
    return filteredResults.map((result) {
      return Place(
        id: result.id,
        name: result.placeName,
        roadAddress: result.roadAddressName,
        placeUrl: result.placeUrl,
        distance: result.distance,
        categoryName: result.categoryName,
        categoryGroupCode: result.categoryGroupCode,
        imagePath: 'assets/images/Croissant.png',
        x: result.x,
        y: result.y,
      );
    }).toList();
  }

  @override
  Future<List<Place>> searchLocation(LatLng query) async {
    final futures = List.generate(10, (index) {
      final page = index + 1;
      return _kakaoLocalApi.searchLocation(
        groupCode: KakaoGroupCode.retaurant.value,
        longitude: '36.0190',
        latitude: '129.3435',
        // longitude: query.longitude.toString(),
        // latitude: query.latitude.toString(),
        page: page,
      );
    });

    final responseList = await Future.wait(futures);
    final response = responseList.expand((res) => res.documents).toList();

    // 이름이나 카테고리에 "빵", "베이커리"가 포함된 것만 필터링
    final filteredResults = response.where((doc) {
      final isBakeryCategoryName =
          doc.categoryName.contains('베이커리') ||
              doc.categoryName.contains('빵') ||
              doc.categoryName.contains('디저트') ||
              doc.categoryName.contains('카페') ||
              doc.categoryName.contains('간식') ||
              doc.categoryName.contains('제과')
      ;
      final hasBakeryKeyword =
          doc.placeName.contains('빵') ||
              doc.placeName.contains('베이커리') ||
              doc.placeName.contains('제과') ||
              doc.placeName.contains('간식') ||
              doc.placeName.contains('디저트') ||
              doc.placeName.contains('카페');

      return isBakeryCategoryName || hasBakeryKeyword;
      // return true;
    });

    // DTO -> Entity
    return filteredResults.map((doc) {
      return Place(
        id: doc.id,
        name: doc.placeName,
        roadAddress: doc.roadAddressName,
        placeUrl: doc.placeUrl,
        distance: doc.distance,
        categoryName: doc.categoryName,
        categoryGroupCode: doc.categoryGroupCode,
        imagePath: 'assets/image/Croissant.png',
        x: doc.x,
        y: doc.y,
      );
    }).toList();
  }
}