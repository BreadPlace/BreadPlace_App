import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> getNotificationPermissionStatus() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await Permission.notification.status;
    }
    return PermissionStatus.denied;
  }

  Future<PermissionStatus> requestNotificationPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await Permission.notification.request();
    }
    return PermissionStatus.denied;
  }

  Future<PermissionStatus> getLocationPermissionStatus() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await Permission.location.status;
    }
    return PermissionStatus.denied;
  }

  Future<PermissionStatus> requestLocationPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await Permission.location.request();
    }
    return PermissionStatus.denied;
  }

  Future<PermissionStatus> getCameraPermissionStatus() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await Permission.camera.status;
    }
    return PermissionStatus.denied;
  }

  Future<PermissionStatus> requestCameraPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await Permission.camera.request();
    }
    return PermissionStatus.denied;
  }

  /// 권한 요청 및 허용 여부 확인
  Future<bool> ensurePermissionGranted(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    final result = await permission.request();
    return result.isGranted;
  }
}