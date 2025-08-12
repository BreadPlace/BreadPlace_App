import 'package:bread_place/domain/entities/liked_bakery_entity.dart';

enum LikeStatus { initial, loading, success, empty, error, geofenceLimitExceeded, geofenceInitSuccess }

class LikeState {
  final LikeStatus status;
  final List<LikedBakeryEntity> bakeries;
  final String? errorMessage;
  final bool hasLocalGeofence;

  const LikeState({
    required this.status,
    this.bakeries = const [],
    this.errorMessage,
    required this.hasLocalGeofence
  });

  LikeState copyWith({
    LikeStatus? status,
    List<LikedBakeryEntity>? bakeries,
    String? errorMessage,
    bool? hasLocalGeofence
  }) {
    return LikeState(
      status: status ?? this.status,
      bakeries: bakeries ?? this.bakeries,
      errorMessage: errorMessage ?? this.errorMessage,
        hasLocalGeofence : hasLocalGeofence ?? this.hasLocalGeofence
    );
  }
}
