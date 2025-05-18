import 'package:bread_place/data/services/api/kakao/kakao_local_api.dart';
import 'package:bread_place/domain/entities/place.dart';
import 'package:bread_place/domain/repositories/kakao_search_repository.dart';

class KakaoSearchRepositoryImpl implements KakaoSearchRepository {
  final KakaoLocalApi _kakaoLocalApi;

  KakaoSearchRepositoryImpl({required KakaoLocalApi kakaoLocalApi})
    : _kakaoLocalApi = kakaoLocalApi;

  @override
  Future<List<Place>> searchPlaces(String query) async {
    final response = await _kakaoLocalApi.searchPlaces(query);

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
        distance: result.distance.isEmpty ? null : result.distance,
        categoryName: result.categoryName,
        categoryGroupCode:
            result.categoryGroupCode.isEmpty ? null : result.categoryGroupCode,
        imagePath: 'assets/images/Croissant.png',
      );
    }).toList();
  }
}
