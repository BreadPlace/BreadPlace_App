import 'package:bread_place/domain/entities/app_permission.dart';
import 'package:bread_place/domain/usecases/permission_use_case.dart';
import 'package:bread_place/domain/usecases/user_local_storage_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'permission_event.dart';
import 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final PermissionUseCase _permissionUseCase;
  final UserLocalStorageUseCase _userLocalStorageUseCase;

  PermissionBloc({
    required PermissionUseCase permissionUseCase,
    required UserLocalStorageUseCase userLocalStorageUseCase,
  }) : _permissionUseCase = permissionUseCase,
       _userLocalStorageUseCase = userLocalStorageUseCase,
        super(const PermissionState()) {
    on<CheckAllPermissionStatus>(_onCheckAllPermissionStatus);
    on<RequestPermissionsOnFirstLaunch>(_onRequestInitialPermissions);
    on<EnsureLocationPermission>(_onEnsureLocationPermission);
    on<EnsureLocationAlwaysPermission>(_onEnsureLocationAlwaysPermission);
    on<EnsureNotificationPermission>(_onEnsureNotificationPermission);
    on<EnsureGeofencePermission>(_onEnsureGeofencePermission);
  }

  // 앱 첫 실행 시 필수 권한 요청 및 최초 실행 여부 저장
  Future<void> _onRequestInitialPermissions(
    RequestPermissionsOnFirstLaunch event,
    Emitter<PermissionState> emit,
  ) async {
    await _userLocalStorageUseCase.setLaunched();

    final locationStatus = await _permissionUseCase.ensureLocationPermission();
    final notificationStatus =
        await _permissionUseCase.ensureNotificationPermission();

    emit(
      state.copyWith(
        locationStatus: locationStatus,
        notificationStatus: notificationStatus,
      ),
    );
  }

  // 전체 권한 상태 확인
  Future<void> _onCheckAllPermissionStatus(CheckAllPermissionStatus event,
      Emitter<PermissionState> emit,) async {
    emit(state.copyWith(checkStatus: PermissionCheckStatus.checking));

    try {
      final location = await _permissionUseCase.getPermissionStatus(
          AppPermission.location);
      final locationAlways = await _permissionUseCase.getPermissionStatus(
          AppPermission.locationAlways);
      final notification = await _permissionUseCase.getPermissionStatus(
          AppPermission.notification);

      emit(
        state.copyWith(
          locationStatus: location,
          locationAlwaysStatus: locationAlways,
          notificationStatus: notification,
          checkStatus: PermissionCheckStatus.checked,
        ),
      );
    } catch (e) {
      print("_onCheckAllPermissionStatus error $e");
    }
  }

  // 위치 권한 요청
  Future<void> _onEnsureLocationPermission(
    EnsureLocationPermission event,
    Emitter<PermissionState> emit,
  ) async {
    final status = await _permissionUseCase.ensureLocationPermission();
    emit(state.copyWith(locationStatus: status));
  }

  // 항상 위치 허용 권한 요청
  Future<void> _onEnsureLocationAlwaysPermission(
    EnsureLocationAlwaysPermission event,
    Emitter<PermissionState> emit,
  ) async {
    final status = await _permissionUseCase.ensureLocationAlwaysPermission();
    emit(state.copyWith(locationAlwaysStatus: status));
  }

  // 알림 권한 요청
  Future<void> _onEnsureNotificationPermission(
    EnsureNotificationPermission event,
    Emitter<PermissionState> emit,
  ) async {
    final status = await _permissionUseCase.ensureNotificationPermission();
    emit(state.copyWith(notificationStatus: status));
  }

  // 지오펜스에 필요한 권한 중 granted가 아닌 것만 요청
  Future<void> _onEnsureGeofencePermission(EnsureGeofencePermission event, Emitter<PermissionState> emit) async {
    if (state.locationStatus != AppPermissionStatus.granted) {
      await _handleLocationPermission(emit);
    }

    if (state.locationAlwaysStatus != AppPermissionStatus.granted) {
      await _handleLocationAlwaysPermission(emit);
    }

    if (state.notificationStatus != AppPermissionStatus.granted) {
      await _handleNotificationPermission(emit);
    }
  }

  Future<void> _handleLocationPermission(Emitter<PermissionState> emit) async {
    switch (state.locationStatus) {
      case AppPermissionStatus.denied:
        await _permissionUseCase.ensureLocationPermission();
        break;
      default:
      // Todo: permanentlyDenied, restricted, granted 등 나머지 상태 상세 분기
        _permissionUseCase.openDeviceAppSettings();
        break;
    }
  }

  Future<void> _handleLocationAlwaysPermission(Emitter<PermissionState> emit) async {
    switch (state.locationAlwaysStatus) {
      case AppPermissionStatus.denied:
        await _permissionUseCase.ensureLocationAlwaysPermission();
        break;
      default:
      // Todo: permanentlyDenied, restricted, granted 등 나머지 상태 상세 분기
        _permissionUseCase.openDeviceAppSettings();
        break;
    }
  }

  Future<void> _handleNotificationPermission(Emitter<PermissionState> emit) async {
    switch (state.notificationStatus) {
      case AppPermissionStatus.denied:
        await _permissionUseCase.ensureNotificationPermission();
        break;
      default:
      // Todo: permanentlyDenied, restricted, granted 등 나머지 상태 상세 분기
        _permissionUseCase.openDeviceAppSettings();
        break;
    }
  }
}
