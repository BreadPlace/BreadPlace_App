part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  final LatLng? userLocation;
  final TempBakeryEntity recommendBakery;
  final LatLng? lastSearchLocation;
  final List<Bakery> bakeryList;
  final Bakery? markerTappedBakery;
  final LatLng? mapCenter;

  final bool hasLocationPermission;
  final bool isFarFromLastSearch;
  final bool isMapMoving;

  const HomeState({
    required this.userLocation,
    required this.recommendBakery,
    required this.lastSearchLocation,
    required this.bakeryList,
    required this.markerTappedBakery,
    required this.mapCenter,

    required this.hasLocationPermission,
    required this.isFarFromLastSearch,
    required this.isMapMoving,
  });
}

final class HomeScreenState extends HomeState {
  const HomeScreenState({
    required super.userLocation,
    required super.recommendBakery,
    required super.lastSearchLocation,
    required super.bakeryList,
    required super.markerTappedBakery,
    required super.mapCenter,

    required super.hasLocationPermission,
    required super.isFarFromLastSearch,
    required super.isMapMoving
  });

  @override
  List<Object?> get props => [
    userLocation,
    recommendBakery,
    lastSearchLocation,
    bakeryList,
    markerTappedBakery,
    mapCenter,

    hasLocationPermission,
    isFarFromLastSearch,
    isMapMoving,
  ];
}

extension HomeScreenStateCopy on HomeScreenState {
  HomeScreenState copyWith({
    LatLng? userLocation,
    TempBakeryEntity? recommendBakery,
    LatLng? lastSearchLocation,
    List<Bakery>? bakeryList,
    Bakery? markerTappedBakery,
    LatLng? mapCenter,

    bool? hasLocationPermission,
    bool? isFarFromLastSearch,
    bool? isMapMoving,
  }) {
    return HomeScreenState(
      userLocation: userLocation ?? this.userLocation,
      recommendBakery: recommendBakery ?? this.recommendBakery,
      lastSearchLocation: lastSearchLocation ?? this.lastSearchLocation,
      bakeryList: bakeryList ?? this.bakeryList,
      markerTappedBakery: markerTappedBakery ?? this.markerTappedBakery,
      mapCenter: mapCenter ?? this.mapCenter,

      hasLocationPermission: hasLocationPermission ?? this.hasLocationPermission,
      isFarFromLastSearch: isFarFromLastSearch ?? this.isFarFromLastSearch,
      isMapMoving: isMapMoving ?? this.isMapMoving,
    );
  }
}
