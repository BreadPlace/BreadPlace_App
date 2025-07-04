import 'package:bread_place/domain/entities/bakery.dart';
import 'package:equatable/equatable.dart';

class LikedBakeryEntity extends Equatable {
  final bool isNotificationAllowed;
  final String updatedAt;
  final Bakery? bakery;

  LikedBakeryEntity({
    required this.isNotificationAllowed,
    required this.updatedAt,
    required this.bakery,
  });

  @override
  List<Object?> get props => [isNotificationAllowed, updatedAt, bakery?.id];
}
