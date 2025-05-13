import 'package:bread_place/data/dto/response/kakao/local_search/search_response.dart';

abstract class KakaoSearchRepository {
  Future<SearchResponse> searchPlaces(String query);
}