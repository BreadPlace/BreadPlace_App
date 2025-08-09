import 'package:bread_place/domain/entities/app_permission.dart';
import 'package:bread_place/domain/repositories/permission_repository.dart';

class PermissionUseCase {
  final PermissionRepository _repository;

  PermissionUseCase({required PermissionRepository repository})
      : _repository = repository;

  Future<AppPermissionStatus> getPermissionStatus(AppPermission permission) async {
    return await _repository.getPermissionStatus(permission);
  }

  Future<AppPermissionStatus> ensureCameraPermission() async {
    return await _repository.ensurePermissionGranted(AppPermission.camera);
  }

  Future<AppPermissionStatus> ensureNotificationPermission() async {
    return await _repository.ensurePermissionGranted(AppPermission.notification);
  }

  Future<AppPermissionStatus> ensureLocationPermission() async {
    return await _repository.ensurePermissionGranted(AppPermission.location);
  }

  Future<AppPermissionStatus> ensureLocationAlwaysPermission() async {
    return await _repository.ensurePermissionGranted(AppPermission.locationAlways);
  }

  Future<void> openDeviceAppSettings() async {
    return await _repository.openDeviceAppSettings();
  }
}
