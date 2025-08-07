import 'package:bread_place/domain/entities/app_permission.dart';

abstract class PermissionRepository {
  Future<AppPermissionStatus> getPermissionStatus(AppPermission permission);
  Future<AppPermissionStatus> ensurePermissionGranted(AppPermission permission);
  Future<void> openDeviceAppSettings();
}