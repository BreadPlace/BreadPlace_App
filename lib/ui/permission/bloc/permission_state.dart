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

  PermissionState copyWith({
    AppPermissionStatus? locationStatus,
    AppPermissionStatus? locationAlwaysStatus,
    AppPermissionStatus? notificationStatus,
    AppPermissionStatus? cameraStatus,
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