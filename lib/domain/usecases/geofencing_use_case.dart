import 'package:bread_place/domain/repositories/geofencing_repository.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';
import 'package:flutter/services.dart';

class GeofencingUseCase {
  final UserLocalStorageRepository _userLocalStorageRepository;
  final GeofencingRepository _geofencingRepository;

  static const platform = MethodChannel('com.bread_place.geofencing');

  GeofencingUseCase({
    required UserLocalStorageRepository userLocalStorageRepository,
    required GeofencingRepository geofencingRepository
  })
      : _userLocalStorageRepository = userLocalStorageRepository,
        _geofencingRepository = geofencingRepository;

  void init() {
    _listenGeofencingEntered();
  }

  Future<void> setGeofencingLocations(List<String> locations) async {
    if (locations.isEmpty) {
      await _stopGeofencingLocations();
      return;
    }

    await _userLocalStorageRepository.saveGeofencingLocations(locations);
    final savedLocations = await _userLocalStorageRepository.getGeofencingLocations();
    await _geofencingRepository.setGeofencingLocations(savedLocations);
  }

  Future<void> setTestGeofencingLocations(List<String> locations) async {
    final regions = [
      '36.328690, 127.427554',
      '36.8065, 127.1522',
      '37.55467884, 126.9706069',
      '37.46333, 126.44000',
    ];

    await _geofencingRepository.setGeofencingLocations(regions);
  }

  Future<void> _stopGeofencingLocations() async {
    await _userLocalStorageRepository.removeGeofencingLocationAll();
    await _geofencingRepository.stopGeofencingLocations();
  }

  void _listenGeofencingEntered() {
    _geofencingRepository.onGeofencingEntered.listen((geofenceId) {
      print('🛰️ Geofencing entered: $geofenceId');
    });
  }
}