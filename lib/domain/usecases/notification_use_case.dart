import 'package:bread_place/domain/repositories/notification_repository.dart';
import 'package:bread_place/domain/repositories/permission_repository.dart';

class NotificationUseCase {
  final NotificationRepository _notificationRepository;
  final PermissionRepository _permissionRepository;

  NotificationUseCase({
    required NotificationRepository notificationRepository,
    required PermissionRepository permissionRepository,
  }) : _notificationRepository = notificationRepository,
       _permissionRepository = permissionRepository;

  Future<void> initService() async {
    await _notificationRepository.init();
  }

  Future<void> openDeviceAppSettings() async {
    await _permissionRepository.openDeviceAppSettings();
  }
}