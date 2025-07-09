import 'package:bread_place/data/dto/mapper/permission_mapper.dart';
import 'package:bread_place/data/services/permission/permission_service.dart';
import 'package:bread_place/domain/entities/app_permission.dart';
import 'package:bread_place/domain/repositories/permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  final PermissionService _service;

  PermissionRepositoryImpl(this._service);

  @override
  Future<AppPermissionStatus> getPermissionStatus(AppPermission permission) async {
    final result = await _service.getPermissionStatus(permission.toPlatform);
    return result.toAppStatus;
  }

  @override
  Future<AppPermissionStatus> requestPermission(AppPermission permission) async {
    final result = await _service.requestPermission(permission.toPlatform);
    return result.toAppStatus;
  }

  @override
  Future<bool> ensurePermissionGranted(AppPermission permission) async {
    bool result = await _service.ensurePermissionGranted(permission.toPlatform);
    return result;
  }
}