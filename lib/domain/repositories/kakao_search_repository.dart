import 'package:bread_place/domain/entities/place.dart';

abstract class KakaoSearchRepository {
  Future<List<Place>> searchPlaces(String query, String? x, String? y);
}