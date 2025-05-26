import 'package:bread_place/data/dto/mapper/bakery_mapper.dart';
import 'package:bread_place/data/dto/request/google/place/text_query_request.dart';
import 'package:bread_place/data/dto/request/google/search_nearby/search_nearby_request.dart';
import 'package:bread_place/data/services/api/google/google_place_api.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/repositories/google_place_repository.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class GooglePlaceRepositoryImpl implements GooglePlaceRepository {
  final GooglePlaceApi _api;

  GooglePlaceRepositoryImpl({required GooglePlaceApi googlePlaceApi})
    : _api = googlePlaceApi;

  @override
  Future<List<Bakery>> searchText(String query) async {
    final request = TextQueryRequest(textQuery: query);
    final response = await _api.searchText(body: request);

    final bakeries =
        response.bakeries.map((dto) {
          return dto.toEntity();
        }).toList();

    return bakeries;
  }

  @override
  Future<List<Bakery>> searchNearby(LatLng searchLocation) async {
    final request = SearchNearbyRequest(
      includedTypes: ['bakery', 'cafe', 'bagel_shop'],
      locationRestriction: LocationRestriction(
        circle: Circle(
          center: Center(
            latitude: searchLocation.latitude,
            longitude: searchLocation.longitude,
          ),
          radius: 260,
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
}
