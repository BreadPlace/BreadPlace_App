import 'package:bread_place/domain/entities/app_permission.dart';

abstract class PermissionRepository {
  Future<AppPermissionStatus> getPermissionStatus(AppPermission permission);
  Future<AppPermissionStatus> requestPermission(AppPermission permission);
  Future<bool> ensurePermissionGranted(AppPermission permission);
}