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

    // DTO -> Entity
    return response.documents.map((doc) {
      return Place(
        id: doc.id,
        name: doc.placeName,
        roadAddress: doc.roadAddressName,
        placeUrl: doc.placeUrl,
        distance: doc.distance.isEmpty ? null : doc.distance,
      );
    }).toList();
  }
}
