import 'package:bread_place/domain/entities/liked_bakery_entity.dart';
import 'package:equatable/equatable.dart';

enum LikeStatus {
  initial,
  loading,
  success,
  empty,
  error,
  geofenceLimitExceeded,
  geofenceInitSuccess,
}

class LikeState extends Equatable {
  final LikeStatus status;
  final List<LikedBakeryEntity> bakeries;
  final String? errorMessage;
  final bool hasLocalGeofence;
  final LikedBakeryEntity? selectedBakery;

  const LikeState({
    required this.status,
    this.bakeries = const [],
    this.errorMessage,
    required this.hasLocalGeofence,
    this.selectedBakery,
  });

  LikeState copyWith({
    LikeStatus? status,
    List<LikedBakeryEntity>? bakeries,
    String? errorMessage,
    bool? hasLocalGeofence,
    LikedBakeryEntity? selectedBakery,
  }) {
    return LikeState(
      status: status ?? this.status,
      bakeries: bakeries ?? this.bakeries,
      errorMessage: errorMessage ?? this.errorMessage,
      hasLocalGeofence: hasLocalGeofence ?? this.hasLocalGeofence,
      selectedBakery: selectedBakery ?? this.selectedBakery,
    );
  }
  @override
  List<Object?> get props => [
    status,
    bakeries,
    errorMessage,
    hasLocalGeofence,
    selectedBakery,
  ];

}
