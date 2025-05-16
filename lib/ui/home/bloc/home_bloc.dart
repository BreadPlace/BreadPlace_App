import 'package:bread_place/domain/entities/temp_bakery_entity.dart';
import 'package:bread_place/ui/home/bloc/latlng_extension.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(
    HomeScreenState(
        userLocation: AppLocations.seoulStation,
        hasLocationPermission: false,
        nearbyBakeries: [],
        recommendBakery: TempBakeryEntity.empty),
  ) {
    on<HomeAppInitiate>(_onAppInitiate);
    on<HomeSetMapUserLocation>(_onSetMapUserLocation);
  }

  void _onSetMapUserLocation(
    HomeSetMapUserLocation event,
    Emitter<HomeState> emit,
  ) {
    emit(
      HomeScreenState(
        userLocation: AppLocations.seoulStation,
        hasLocationPermission: true,
        nearbyBakeries: [TempBakeryEntity.empty],
        recommendBakery: TempBakeryEntity.empty,
      ),
    );
  }

  Future<void> _onAppInitiate(
    HomeAppInitiate event,
    Emitter<HomeState> emit,
  ) async {
    // 권한 확인
    final hasPermission = await _checkLocationPermission();

    // 권한이 없는 경우
    if (!hasPermission) {
      emit(
        HomeScreenState(
          userLocation: AppLocations.seoulStation,
          hasLocationPermission: false,
          nearbyBakeries: [],
          recommendBakery: TempBakeryEntity.empty,
        ),
      );
    }

    final currentPosition = await Geolocator.getCurrentPosition();

    emit(
      (state as HomeScreenState).copyWith(
        hasLocationPermission: true,
        userLocation: LatLng(
          currentPosition.latitude,
          currentPosition.longitude,
        ),
      ),
    );
  }

  Future<bool> _checkLocationPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
