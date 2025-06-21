import 'package:bread_place/domain/entities/bakery.dart';
import 'package:equatable/equatable.dart';

class LikedBakeryEntity extends Equatable {
  final bool isNotify;
  final String updatedAt;
  final Bakery? bakery;

  LikedBakeryEntity({
    required this.isNotify,
    required this.updatedAt,
    required this.bakery,
  });

  @override
  List<Object?> get props => [isNotify, updatedAt, bakery?.id];
}
