import 'package:bread_place/config/constants/exception/geofence_exception.dart';
import 'package:bread_place/domain/entities/notification_entity.dart';
import 'package:bread_place/domain/repositories/geofencing_repository.dart';
import 'package:bread_place/domain/repositories/notification_repository.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';

class GeofencingUseCase {
  final UserLocalStorageRepository _userLocalStorageRepository;
  final GeofencingRepository _geofencingRepository;
  final NotificationRepository _notificationRepository;

  GeofencingUseCase({
    required UserLocalStorageRepository userLocalStorageRepository,
    required GeofencingRepository geofencingRepository,
    required NotificationRepository notificationRepository,
  })
      : _userLocalStorageRepository = userLocalStorageRepository,
        _geofencingRepository = geofencingRepository,
        _notificationRepository = notificationRepository;

  void init() {
    _listenGeofencingEntered();
  }

  // 주어진 위치 리스트를 로컬에 저장하고, 네이티브 지오펜스 등록
  Future<void> setGeofencingLocations(List<String> locations) async {
    if (locations.isEmpty) {
      await stopGeofencingLocations();
      return;
    }

    await _userLocalStorageRepository.saveGeofencingLocations(locations);
    final savedLocations = await getLocalSavedLocations();
    await _geofencingRepository.setGeofencingLocations(savedLocations);
  }

  // 로컬 저장소에 저장된 위치를 가져와 네이티브 지오펜스 등록
  Future<void> initializeGeofenceFromLocalStorage() async {
    final savedLocations = await getLocalSavedLocations();

    if(savedLocations.isEmpty) {
      await stopGeofencingLocations();
      return;
    }

    await _geofencingRepository.setGeofencingLocations(savedLocations);
  }

  Future<void> stopGeofencingLocations() async {
    await _userLocalStorageRepository.removeGeofencingLocationAll();
    await _geofencingRepository.stopGeofencingLocations();
  }

  Future<void> _listenGeofencingEntered() async {
    _geofencingRepository.onGeofencingEntered.listen((geofenceId) async {
      String displayName = await findBakeryNameByPlaceId(geofenceId);

      final notificationEntity = NotificationEntity(
        title: '가고싶던 빵집이 근처에 있어요!',
        body: '$displayName 근처에 진입',
      );

      _notificationRepository.showNotification(notificationEntity);
    });
  }

  Future<List<String>> getLocalSavedLocations() async {
    return await _userLocalStorageRepository.getGeofencingLocations();
  }

  Future<void> updateGeofenceLocation(String location) async {
    final savedLocations = await getLocalSavedLocations();
    final isAlreadySaved = savedLocations.contains(location);
    List<String> updatedLocations;

    if (isAlreadySaved) {
      updatedLocations = savedLocations.where((e) => e != location).toList();
    } else {
      updatedLocations = [...savedLocations, location];
    }

    if(canAddMoreGeofence(updatedLocations)) {
      await setGeofencingLocations(updatedLocations);
    } else {
      throw GeofenceLimitExceededException();
    }
  }

  Future<String> findBakeryNameByPlaceId(String geofenceId) async {
    final savedLocations = await getLocalSavedLocations();

    for (final location in savedLocations) {
      final parts = location.split('|');
      if (parts.length != 4) continue;

      final id = parts[0];
      final name = parts[1];

      if (id == geofenceId) {
        return name;
      }
    }
    return '베이커리 이름 정보 없음';
  }

  bool canAddMoreGeofence(List<String> locations) {
    const int maxGeofenceCount = 20;
    return locations.length <= maxGeofenceCount;
  }
}