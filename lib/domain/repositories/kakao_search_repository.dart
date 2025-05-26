import 'package:bread_place/domain/entities/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class KakaoSearchRepository {
  Future<List<Place>> searchPlaces(String query, String? x, String? y);
  Future<List<Place>> searchLocation(LatLng query);
}