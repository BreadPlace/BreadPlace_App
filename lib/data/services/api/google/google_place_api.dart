import 'package:bread_place/data/dto/request/google/place/text_query_request.dart';
import 'package:bread_place/data/dto/request/google/search_nearby/search_nearby_request.dart';
import 'package:bread_place/data/dto/response/google/place/place_photo_response.dart';
import 'package:bread_place/data/dto/response/google/place/text_query_response.dart';
import 'google_place_endpoint.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'google_place_api.g.dart';

@RestApi()
abstract class GooglePlaceApi {
  factory GooglePlaceApi(Dio dio, {String baseUrl}) = _GooglePlaceApi;

  /// 텍스트 문자열 및 특정 위치와 일치하는 장소의 목록을 반환
  @POST(GooglePlaceEndpoint.searchText)
  Future<TextQueryResponse> searchText({
    @Body() required TextQueryRequest body,
  });

  @POST('v1/places:searchNearby')
  Future<TextQueryResponse> searchNearby({
    @Body() required SearchNearbyRequest body,
  });

  /// photoName 으로 photoUri 가져오기
  @GET(GooglePlaceEndpoint.getPlacePhotoUri)
  Future<PlacePhotoResponse> getPlacePhotoUri({
    @Path('name') required String photoName,
    @Query('skipHttpRedirect') bool skipHttpRedirect = true, // true = Json 반환, false = byte 반환
  });
}