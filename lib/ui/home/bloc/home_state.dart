part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  final LatLng? userLocation;
  final bool hasLocationPermission;
  final List<TempBakeryEntity> nearbyBakeries;
  final TempBakeryEntity recommendBakery;

  const HomeState({
    required this.userLocation,
    required this.hasLocationPermission,
    required this.nearbyBakeries,
    required this.recommendBakery,
  });
}

final class HomeScreenState extends HomeState {
  const HomeScreenState({
    required super.userLocation,
    required super.hasLocationPermission,
    required super.nearbyBakeries,
    required super.recommendBakery,
  });

  @override
  List<Object?> get props => [
    userLocation,
    hasLocationPermission,
    nearbyBakeries,
    recommendBakery,
  ];
}

extension HomeScreenStateCopy on HomeScreenState {
  HomeScreenState copyWith({
    LatLng? userLocation,
    bool? hasLocationPermission,
    List<TempBakeryEntity>? nearbyBakeries,
    TempBakeryEntity? recommendBakery,
  }) {
    return HomeScreenState(
        userLocation: userLocation ?? this.userLocation,
        hasLocationPermission: hasLocationPermission ?? this.hasLocationPermission,
        nearbyBakeries: nearbyBakeries ?? this.nearbyBakeries,
        recommendBakery: recommendBakery ?? this.recommendBakery
    );
  }
}