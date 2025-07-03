import 'dart:async';

abstract class GeofencingRepository {
  Future<void> setGeofencingLocations(List<String> locations);
  Future<void> stopGeofencingLocations();

  Stream<String> get onGeofencingEntered;
}