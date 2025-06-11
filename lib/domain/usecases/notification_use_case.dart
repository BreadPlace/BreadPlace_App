import 'package:bread_place/domain/entities/notification_entity.dart';
import 'package:bread_place/domain/repositories/notification_repository.dart';

class NotificationUseCase {
  final NotificationRepository _repository;

  NotificationUseCase(this._repository);

  Future<void> initService() async {
    await _repository.init();
  }

  Future<void> showNotification() async {
    final test = NotificationEntity(
        title: '유스케이스 테스트',
        body: '냠냠'
    );

    await _repository.showNotification(test);
  }
}