part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  final LatLng? userLocation;
  final RecommendBakeryEntity? recommendBakery;
  final Bakery? selectedRecommendBakery;
  final LatLng? lastSearchLocation;
  final List<Bakery> bakeryList;
  final Bakery? markerTappedBakery;
  final LatLng? mapCenter;

  final bool hasLocationPermission;
  final bool isFarFromLastSearch;
  final bool isMapMoving;
  final bool isLoadingBakery;

  const HomeState({
    required this.userLocation,
    required this.recommendBakery,
    required this.selectedRecommendBakery,
    required this.lastSearchLocation,
    required this.bakeryList,
    required this.markerTappedBakery,
    required this.mapCenter,

    required this.hasLocationPermission,
    required this.isFarFromLastSearch,
    required this.isMapMoving,
    required this.isLoadingBakery,
  });
}

final class HomeScreenState extends HomeState {
  const HomeScreenState({
    required super.userLocation,
    required super.recommendBakery,
    required super.selectedRecommendBakery,
    required super.lastSearchLocation,
    required super.bakeryList,
    required super.markerTappedBakery,
    required super.mapCenter,

    required super.hasLocationPermission,
    required super.isFarFromLastSearch,
    required super.isMapMoving,
    required super.isLoadingBakery,
  });

  @override
  List<Object?> get props => [
    userLocation,
    recommendBakery,
    selectedRecommendBakery,
    lastSearchLocation,
    bakeryList,
    markerTappedBakery,
    mapCenter,

    hasLocationPermission,
    isFarFromLastSearch,
    isMapMoving,
    isLoadingBakery,
  ];
}

extension HomeScreenStateCopy on HomeScreenState {
  HomeScreenState copyWith({
    LatLng? userLocation,
    RecommendBakeryEntity? recommendBakery,
    Bakery? selectedRecommendBakery,
    LatLng? lastSearchLocation,
    List<Bakery>? bakeryList,
    Bakery? markerTappedBakery,
    LatLng? mapCenter,

    bool? hasLocationPermission,
    bool? isFarFromLastSearch,
    bool? isMapMoving,
    bool? isLoadingBakery
  }) {
    return HomeScreenState(
      userLocation: userLocation ?? this.userLocation,
      recommendBakery: recommendBakery ?? this.recommendBakery,
      selectedRecommendBakery: selectedRecommendBakery ?? this.selectedRecommendBakery,
      lastSearchLocation: lastSearchLocation ?? this.lastSearchLocation,
      bakeryList: bakeryList ?? this.bakeryList,
      markerTappedBakery: markerTappedBakery ?? this.markerTappedBakery,
      mapCenter: mapCenter ?? this.mapCenter,

      hasLocationPermission: hasLocationPermission ?? this.hasLocationPermission,
      isFarFromLastSearch: isFarFromLastSearch ?? this.isFarFromLastSearch,
      isMapMoving: isMapMoving ?? this.isMapMoving,
      isLoadingBakery: isLoadingBakery ?? this.isLoadingBakery,
    );
  }
}
