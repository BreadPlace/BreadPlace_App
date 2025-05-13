import 'package:bread_place/data/dto/response/kakao/local_search/search_response.dart';
import 'package:bread_place/data/services/api/kakao/kakao_local_api.dart';
import 'package:bread_place/domain/repositories/kakao_search_repository.dart';

class KakaoSearchRepositoryImpl implements KakaoSearchRepository {
  final KakaoLocalApi _kakaoLocalApi;
  
  KakaoSearchRepositoryImpl({required KakaoLocalApi kakaoLocalApi}) : _kakaoLocalApi = kakaoLocalApi;
  
  @override
  Future<SearchResponse> searchPlaces(String query) async {
    return await _kakaoLocalApi.searchPlaces(query);
  }
}