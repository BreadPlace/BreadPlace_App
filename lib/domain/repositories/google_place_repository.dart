import 'package:bread_place/domain/entities/bakery.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GooglePlaceRepository {
  Future<List<Bakery>> searchText(String query);
  Future<List<Bakery>> searchNearby(LatLng searchLocation);
}