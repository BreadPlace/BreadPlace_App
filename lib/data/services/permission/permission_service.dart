import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// 권한 상태만 확인
  Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await permission.status;
    }
    // 지원하지 않는 플랫폼
    return PermissionStatus.denied;
  }

  /// 권한 요청만
  Future<PermissionStatus> requestPermission(Permission permission) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await permission.request();
    }
    return PermissionStatus.denied;
  }

  /// 권한 상태 확인 후 없으면 요청. 최종 권한 허용 여부를 bool로 반환
  Future<bool> ensurePermissionGranted(Permission permission) async {
    final status = await getPermissionStatus(permission);

    if (status.isGranted) return true;

    final result = await requestPermission(permission);
    return result.isGranted;
  }

  /// 앱 설정 화면으로 유도
  Future<void> openDeviceAppSettings() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await openAppSettings();
    }
  }
}