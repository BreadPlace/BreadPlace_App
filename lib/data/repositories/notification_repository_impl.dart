import 'package:bread_place/data/services/notification/local_notification_service.dart';
import 'package:bread_place/domain/entities/notification_entity.dart';
import 'package:bread_place/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final LocalNotificationService _service;

  NotificationRepositoryImpl(this._service);


  @override
  Future<void> init() async {
    _service.init();
  }

  @override
  Future<void> showNotification(NotificationEntity entity) async {
    await _service.showNotification(
      title: entity.title,
      body: entity.body,
      payload: entity.payload,
    );
  }
}
