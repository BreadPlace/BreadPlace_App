import 'package:bread_place/domain/entities/bakery.dart';

class NotificationEntity {
  final String title;
  final String body;
  final String payload;
  final Bakery? bakery;

  NotificationEntity({
    required this.title,
    required this.body,
    this.payload = '',
    this.bakery,
  });
}
