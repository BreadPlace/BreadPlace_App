import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import 'package:bread_place/data/dto/response/kakao/local_search/search_response.dart';

part 'kakao_local_api.g.dart';

@RestApi()
abstract class KakaoLocalApi {
  factory KakaoLocalApi(Dio dio, {String baseUrl}) = _KakaoLocalApi;

  @GET("/v2/local/search/keyword.json")
  Future<SearchResponse> searchPlaces({
    @Query("query") required String query,
    @Query("x") String? x,
    @Query("y") String? y,
  });

  @GET("/v2/local/search/category.json")
  Future<SearchResponse> searchLocation({
    @Query("category_group_code") required String groupCode,
    @Query("x") required String longitude,
    @Query("y") required String latitude,
    @Query("radius") int radius = 500,
    @Query("sort") String sort = 'distance',
    @Query('page') int page = 1
  });
}
