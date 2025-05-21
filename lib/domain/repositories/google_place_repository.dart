import 'package:bread_place/domain/entities/bakery.dart';

abstract class GooglePlaceRepository {
  Future<List<Bakery>> searchText(String query);
}