import 'package:bread_place/data/services/userlocation/user_location_service.dart';
import 'package:bread_place/domain/repositories/user_location_repository.dart';

class UserLocationRepositoryImpl implements UserLocationRepository {
  final UserLocationService _service;
  UserLocationRepositoryImpl(this._service);

  @override
  Future<({double latitude, double longitude})>getUserLocation() async {
      return _service.getUserLocation();
  }
}