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

extension LikedBakeryListExtension on List<LikedBakeryEntity> {
  /// 알림 허용된 베이커리들의 위치 정보, id 등을 추출하여 문자열 리스트로 변환
  List<String> get toGeofenceLocationString {
    return where((liked) => liked.isNotificationAllowed)
        .map((allowed) => allowed.bakery?.formattedLocationWithDetail)
        .whereType<String>()
        .toList();
  }
}