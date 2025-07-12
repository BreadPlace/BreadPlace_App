import 'package:bread_place/domain/entities/bakery.dart';

abstract class GooglePlaceRepository {
  Future<List<Bakery>> searchText(String query);
  Future<List<Bakery>> searchNearBy({
    required double latitude,
    required double longitude
  });
  Future<String> getPlacePhotoUri(String photoName);
  Future<Bakery> searchPlaceDetail(String placeId);
}