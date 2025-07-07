import 'package:bread_place/domain/entities/bakery.dart';
import 'package:equatable/equatable.dart';

abstract class LikeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLikedBakeries extends LikeEvent {}

class AddLike extends LikeEvent {
  final Bakery bakery;
  final bool isNotificationAllowed;

  AddLike({required this.isNotificationAllowed, required this.bakery});

  @override
  List<Object?> get props => [bakery, isNotificationAllowed];
}

class RemoveLike extends LikeEvent {
  final Bakery bakery;
  final bool isNotificationAllowed;

  RemoveLike({required this.bakery, required this.isNotificationAllowed});

  @override
  List<Object?> get props => [bakery, isNotificationAllowed];
}

class ToggleNotification extends LikeEvent {
  final Bakery bakery;
  final bool isNotificationAllowed;

  ToggleNotification({
    required this.bakery,
    required this.isNotificationAllowed,
  });
}

class AddGeofence extends LikeEvent {}

class RemoveGeofence extends LikeEvent {}
