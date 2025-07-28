import 'package:bread_place/domain/entities/app_permission.dart';
import 'package:bread_place/domain/repositories/permission_repository.dart';

class PermissionUseCase {
  final PermissionRepository _repository;

  PermissionUseCase({required PermissionRepository repository})
      : _repository = repository;

  Future<void> getPermissionStatus(AppPermission permission) async {
    await _repository.getPermissionStatus(permission);
  }

  Future<void> requestInitialPermissions() async {
      await _repository.requestPermission(AppPermission.location);
      await _repository.requestPermission(AppPermission.notification);
      await _repository.requestPermission(AppPermission.camera);
  }

  Future<bool> ensureCameraPermission() async {
    return await _repository.ensurePermissionGranted(AppPermission.camera);
  }

  Future<bool> ensureNotificationPermission() async {
    return await _repository.ensurePermissionGranted(AppPermission.notification);
  }

  Future<bool> ensureLocationPermission() async {
    return await _repository.ensurePermissionGranted(AppPermission.location);
  }

  Future<bool> ensureLocationAlwaysPermission() async {
    return await _repository.ensurePermissionGranted(AppPermission.locationAlways);
  }
}
