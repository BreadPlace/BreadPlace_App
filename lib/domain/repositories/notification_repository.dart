import 'package:bread_place/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<void> init();
  Future<void> showNotification(NotificationEntity entity);
}