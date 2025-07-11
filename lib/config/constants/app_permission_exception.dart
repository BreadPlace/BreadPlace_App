import 'package:bread_place/domain/entities/app_permission.dart';

abstract class AppPermissionException implements Exception {
  AppPermissionStatus get status;

  String get message => _statusMessage(status);

  @override
  String toString() => 'AppPermissionException($status): $message';

  static String _statusMessage(AppPermissionStatus status) {
    switch(status) {
      case AppPermissionStatus.granted:
        return '권한이 허용된 상태입니다.';
      case AppPermissionStatus.denied:
        return '권한이 거부되었습니다.';
      case AppPermissionStatus.permanentlyDenied:
        return '권한이 거부되었고 다시 묻지 않는 상태입니다.';
      case AppPermissionStatus.restricted:
        return 'OS 또는 관리자 설정에 의해 권한이 제한되었습니다.(iOS 전용)';
      case AppPermissionStatus.limited:
        return '사진 권한 일부만 허용되었습니다.(iOS 14+)';
      case AppPermissionStatus.provisional:
        return '푸시 알림에 한해 임시 허용되었습니다.(iOS 12+)';
    }
  }
}

class AppPermissionDeniedException extends AppPermissionException {
  @override
  AppPermissionStatus get status => AppPermissionStatus.denied;
}

class AppPermissionPermanentlyDeniedException extends AppPermissionException {
  @override
  AppPermissionStatus get status => AppPermissionStatus.permanentlyDenied;
}

class AppPermissionRestrictedException extends AppPermissionException {
  @override
  AppPermissionStatus get status => AppPermissionStatus.restricted;
}

class AppPermissionLimitedException extends AppPermissionException {
  @override
  AppPermissionStatus get status => AppPermissionStatus.limited;
}

class AppPermissionProvisionalException extends AppPermissionException {
  @override
  AppPermissionStatus get status => AppPermissionStatus.provisional;
}