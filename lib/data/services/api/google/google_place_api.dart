import 'package:bread_place/data/dto/request/google/place/text_query_request.dart';
import 'package:bread_place/data/dto/response/google/place/text_query_response.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'google_place_api.g.dart';

@RestApi()
abstract class GooglePlaceApi {
  factory GooglePlaceApi(Dio dio, {String baseUrl}) = _GooglePlaceApi;

  /// 텍스트 문자열 및 특정 위치와 일치하는 장소의 목록을 반환
  @POST('v1/places:searchText')
  @Headers({'X-Goog-FieldMask': 'places.displayName,places.formattedAddress'}) // 응답 받을 데이터 유형 지정
  Future<TextQueryResponse> searchText({
    @Body() required TextQueryRequest body,
  });
}
