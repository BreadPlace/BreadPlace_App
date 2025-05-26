part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  final LatLng? userLocation;
  final TempBakeryEntity recommendBakery;
  final LatLng? lastSearchLocation;
  final List<Bakery> bakeryList;
  final Bakery? markerTappedBakery;

  final bool hasLocationPermission;

  const HomeState({
    required this.userLocation,
    required this.recommendBakery,
    required this.lastSearchLocation,
    required this.bakeryList,
    required this.markerTappedBakery,

    required this.hasLocationPermission,
  });
}

final class HomeScreenState extends HomeState {
  const HomeScreenState({
    required super.userLocation,
    required super.recommendBakery,
    required super.lastSearchLocation,
    required super.bakeryList,
    required super.markerTappedBakery,

    required super.hasLocationPermission,
  });

  @override
  List<Object?> get props => [
    userLocation,
    recommendBakery,
    lastSearchLocation,
    bakeryList,
    markerTappedBakery,

    hasLocationPermission,
  ];
}

extension HomeScreenStateCopy on HomeScreenState {
  HomeScreenState copyWith({
    LatLng? userLocation,
    TempBakeryEntity? recommendBakery,
    LatLng? lastSearchLocation,
    List<Bakery>? bakeryList,
    Bakery? markerTappedBakery,

    bool? hasLocationPermission,
  }) {
    return HomeScreenState(
      userLocation: userLocation ?? this.userLocation,
      recommendBakery: recommendBakery ?? this.recommendBakery,
      lastSearchLocation: lastSearchLocation ?? this.lastSearchLocation,
      bakeryList: bakeryList ?? this.bakeryList,
      markerTappedBakery: markerTappedBakery,

      hasLocationPermission: hasLocationPermission ?? this.hasLocationPermission,
    );
  }
}