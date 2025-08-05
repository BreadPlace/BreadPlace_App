import 'package:bread_place/config/constants/app_constants.dart';
import 'package:bread_place/data/dto/mapper/bakery_mapper.dart';
import 'package:bread_place/data/dto/request/google/search_nearby/search_nearby_request.dart';
import 'package:bread_place/data/dto/request/google/text_search/text_search_request.dart';
import 'package:bread_place/data/services/api/google/google_place_api.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/repositories/google_place_repository.dart';

class GooglePlaceRepositoryImpl implements GooglePlaceRepository {
  final GooglePlaceApi _api;

  GooglePlaceRepositoryImpl({required GooglePlaceApi googlePlaceApi})
    : _api = googlePlaceApi;

  @override
  Future<List<Bakery>> searchText(String query) async {
    final request = TextSearchRequest(textQuery: query);
    final response = await _api.searchText(body: request);

    final results = response.bakeries
        .where((dto) => dto.types.any(['cafe', 'bakery'].contains))
        .map((dto) => dto.toEntity())
        .toList();

    return results;
  }

  @override
  Future<List<Bakery>> searchNearBy({
    required double latitude,
    required double longitude,
  }) async {
    final request = SearchNearbyRequest(
      includedTypes: ['bakery', 'cafe', 'bagel_shop'],
      locationRestriction: LocationRestriction(
        circle: Circle(
          center: Center(
            latitude: latitude,
            longitude: longitude,
          ),
          radius: AppConstants.searchRadiusMeter,
        ),
      ),
    );

    final response = await _api.searchNearby(body: request);

    final bakeries =
        response.bakeries.map((dto) {
          return dto.toEntity();
        }).toList();

    return bakeries;
  }

  @override
  Future<String> getPlacePhotoUri(String photoName) async {
    final response = await _api.getPlacePhotoUri(photoName: photoName);
    final photoUri = response.photoUri ?? '';

    return photoUri;
  }

  @override
  Future<Bakery> searchPlaceDetail(String bakeryId) async {
    final response = await _api.searchPlaceDetail(placeId: bakeryId);
    return response.toEntity();
  }
}
