import 'package:bread_place/data/services/geofencing/geofencing_service.dart';
import 'package:bread_place/domain/repositories/geofencing_repository.dart';

class GeofencingRepositoryImpl implements GeofencingRepository {
  final GeofencingService service;

  GeofencingRepositoryImpl({
    required this.service,
  });

  @override
  Stream<String> get onGeofencingEntered => service.onGeofencingEntered;

  @override
  Future<void> setGeofencingLocations(List<String> locations) async {
    await service.setGeofencingLocations(locations);
  }

  @override
  Future<void> stopGeofencingLocations() async {
    await service.stopGeofencingLocations();
  }
}