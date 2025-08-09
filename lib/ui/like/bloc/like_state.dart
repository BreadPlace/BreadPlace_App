import 'package:bread_place/domain/entities/liked_bakery_entity.dart';

enum LikeStatus { initial, loading, success, empty, error, geofenceLimitExceeded, geofenceInitSuccess }

class LikeState {
  final LikeStatus status;
  final List<LikedBakeryEntity> bakeries;
  final String? errorMessage;

  const LikeState({
    required this.status,
    this.bakeries = const [],
    this.errorMessage,
  });

  LikeState copyWith({
    LikeStatus? status,
    List<LikedBakeryEntity>? bakeries,
    String? errorMessage,
  }) {
    return LikeState(
      status: status ?? this.status,
      bakeries: bakeries ?? this.bakeries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
