import 'package:equatable/equatable.dart';

abstract class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object> get props => [];
}

class InitPermissionStatus extends PermissionEvent {}

/// 앱 최초 실행 시 전체 권한 요청
class RequestPermissionsOnFirstLaunch extends PermissionEvent {}

/// 전체 권한 확인
class CheckAllPermissionStatus extends PermissionEvent {}
class EnsureGeofencePermission extends PermissionEvent {}

/// 개별 권한 확인 및 요청
class CheckAndRequestLocationPermission extends PermissionEvent {}
class EnsureLocationPermission extends PermissionEvent {}
class EnsureLocationAlwaysPermission extends PermissionEvent {}
class EnsureNotificationPermission extends PermissionEvent {}