import 'package:bread_place/domain/entities/app_permission.dart';
import 'package:permission_handler/permission_handler.dart';

/// AppPermission → Permission (platform enum)
extension AppPermissionMapper on AppPermission {
  Permission get toPlatform {
    switch (this) {
      case AppPermission.location:
        return Permission.location;
      case AppPermission.camera:
        return Permission.camera;
      case AppPermission.notification:
        return Permission.notification;
      case AppPermission.locationAlways:
        return Permission.locationAlways;
    }
  }
}

/// PermissionStatus → AppPermissionStatus (app enum)
extension AppPermissionStatusMapper on PermissionStatus {
  AppPermissionStatus get toAppStatus {
    switch (this) {
      case PermissionStatus.granted:
        return AppPermissionStatus.granted;
      case PermissionStatus.denied:
        return AppPermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return AppPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return AppPermissionStatus.restricted;
      case PermissionStatus.limited:
        return AppPermissionStatus.limited;
      case PermissionStatus.provisional:
        return AppPermissionStatus.provisional;
    }
  }
}