import 'package:bread_place/data/dto/request/google/place/text_query_request.dart';
import 'package:bread_place/data/services/api/google/google_place_api.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/repositories/google_place_repository.dart';

class GooglePlaceRepositoryImpl implements GooglePlaceRepository {
  final GooglePlaceApi _api;

  GooglePlaceRepositoryImpl({required GooglePlaceApi googlePlaceApi})
      : _api = googlePlaceApi;

  @override
  Future<List<Bakery>> searchText(String query) async {
    final request = TextQueryRequest(textQuery: query);
    final response = await _api.searchText(body: request);

    final bakeries = response.bakeries.map((dto) {
      return Bakery(
          displayName: dto.displayName.text,
          languageCode: dto.displayName.languageCode,
          formattedAddress: dto.formattedAddress
      );
    }).toList();

    return bakeries;
}}
