import 'package:bread_place/domain/entities/app_permission.dart';
import 'package:equatable/equatable.dart';

class PermissionState extends Equatable {
  final AppPermissionStatus locationStatus;
  final AppPermissionStatus locationAlwaysStatus;
  final AppPermissionStatus notificationStatus;

  const PermissionState({
    this.locationStatus = AppPermissionStatus.denied,
    this.locationAlwaysStatus = AppPermissionStatus.denied,
    this.notificationStatus = AppPermissionStatus.denied,
  });

  /// 지오펜스 등록을 위한 모든 권한이 허용되었는지 여부
  bool get isAllGranted =>
      locationStatus == AppPermissionStatus.granted &&
      locationAlwaysStatus == AppPermissionStatus.granted &&
      notificationStatus == AppPermissionStatus.granted;

  /// 푸시 알림이 허용되었는지 여부
  bool get isNotificationGranted =>
      notificationStatus == AppPermissionStatus.granted;

  /// 지도를 위한 위치 권한 허용 여부
  bool get isLocationPermissionGranted =>
      locationStatus == AppPermissionStatus.granted;

  PermissionState copyWith({
    AppPermissionStatus? locationStatus,
    AppPermissionStatus? locationAlwaysStatus,
    AppPermissionStatus? notificationStatus,
  }) {
    return PermissionState(
      locationStatus: locationStatus ?? this.locationStatus,
      locationAlwaysStatus: locationAlwaysStatus ?? this.locationAlwaysStatus,
      notificationStatus: notificationStatus ?? this.notificationStatus,
    );
  }

  @override
  List<Object?> get props => [
    locationStatus,
    locationAlwaysStatus,
    notificationStatus,
  ];
}