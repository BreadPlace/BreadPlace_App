import 'package:bread_place/domain/entities/bakery.dart';
import 'package:equatable/equatable.dart';

abstract class LikeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLikedBakeries extends LikeEvent {}

class AddLike extends LikeEvent {
  final Bakery bakery;
  final bool isNotify;

  AddLike({required this.isNotify, required this.bakery});

  @override
  List<Object?> get props => [bakery, isNotify];
}

class RemoveLike extends LikeEvent {
  final Bakery bakery;
  final bool isNotify;

  RemoveLike({required this.bakery, required this.isNotify});

  @override
  List<Object?> get props => [bakery, isNotify];
}