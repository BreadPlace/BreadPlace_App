import 'package:bread_place/config/constants/app_constants.dart';
import 'package:bread_place/domain/usecases/search_bakery_use_case.dart';
import 'package:bread_place/config/constants/exception/app_permission_exception.dart';
import 'package:bread_place/domain/usecases/user_location_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/entities/temp_bakery_entity.dart';
import 'package:bread_place/config/constants/app_locations.dart';
import 'package:bread_place/utils/calculate_distance.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SearchBakeryUseCase _searchBakeryUseCase;
  final UserLocationUseCase _userLocationUseCase;

  HomeBloc({
    required SearchBakeryUseCase searchBakeryUseCase,
    required UserLocationUseCase userLocationUseCase
  })
      : _searchBakeryUseCase = searchBakeryUseCase,
        _userLocationUseCase = userLocationUseCase,
        super(
        HomeScreenState(
          userLocation: AppLocations.seoulStation,
          recommendBakery: TempBakeryEntity.empty,
          lastSearchLocation: null,
          bakeryList: [],
          markerTappedBakery: null,
          mapCenter: null,

          hasLocationPermission: false,
          isFarFromLastSearch: true,
          isMapMoving: false,
        ),
      ) {
    on<HomeAppInitiate>(_onAppInitiate);
    on<HomeSearchLocation>(_onSearchLocation);
    on<HomeMarkerTapped>(_onMarkerTapped);
    on<HomeBellIconTapped>(_onBellIconTapped);
    on<HomeMapTapped>(_onMapTapped);
    on<HomeMapMoved>(_onMapMoved);
    on<HomeMapStopped>(_onMapStopped);
  }

  /// 앱의 Initiate 시점 결과 반환
  Future<void> _onAppInitiate(
      HomeAppInitiate event,
      Emitter<HomeState> emit
      ) async {
    try {
      // 권한이 있는 경우
      final currentPosition = await _userLocationUseCase.getUserLocation();

      final currentLatLng = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      // 사용자 위치 주변 베이커리 검색
      // final bakeryList = await _fetchNearby(
      //   LatLng(currentPosition.latitude, currentPosition.longitude),
      // );

      emit(
        (state as HomeScreenState).copyWith(
          hasLocationPermission: true,
          // bakeryList: bakeryList,
          lastSearchLocation: currentLatLng,
          userLocation: currentLatLng,
          mapCenter: currentLatLng,
        ),
      );
    } catch (error) {
      // TODO: 추후 에러 종류에 따라 분기처리 가능
      print(error.toString());
      if(error == AppPermissionDeniedException) {
        emit(
          HomeScreenState(
            userLocation: AppLocations.seoulStation,
            recommendBakery: TempBakeryEntity.empty,
            lastSearchLocation: null,
            bakeryList: [],
            markerTappedBakery: null,
            mapCenter: null,

            hasLocationPermission: false,
            isFarFromLastSearch: false,
            isMapMoving: false,
          ),
        );
      }
    }
  }

  /// 장소 검색
  Future<void> _onSearchLocation(
    HomeSearchLocation event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // 검색 위치
      final LatLng searchLocation = LatLng(
        event.location.latitude,
        event.location.longitude,
      );

      // 사용자 위치 주변 검색
      final result = await _searchNearBy(searchLocation, deduplicate: true);

      // 상태 방출
      emit(
        (state as HomeScreenState).copyWith(
          hasLocationPermission: true,
          lastSearchLocation: searchLocation,
          bakeryList: result,
        ),
      );
    } catch (e, stack) {
      print('🔥 네트워크 요청 중 오류 발생!');
      print('에러: $e');
      print('스택: $stack');
    }
  }

  void _onMarkerTapped(HomeMarkerTapped event, Emitter<HomeState> emit) {
    final Bakery? selectedBakery =
        state.bakeryList
            .where((bakery) => bakery.id == event.bakeryID)
            .firstOrNull;

    emit(
      (state as HomeScreenState).copyWith(markerTappedBakery: selectedBakery),
    );
  }

  void _onMapTapped(HomeMapTapped event, Emitter<HomeState> emit) {
    emit((state as HomeScreenState).copyWith(markerTappedBakery: null));
  }

  /// 알람 아이콘 버튼이 눌렸을 때
  void _onBellIconTapped(HomeBellIconTapped event, Emitter<HomeState> emit) {
    print('아이콘 버튼 눌림');
    // emit(HomeScreenState(
    //     userLocation: AppLocations.seoulStation,
    //     hasLocationPermission: false,
    //     nearbyBakeries: [],
    //     recommendBakery: TempBakeryEntity.empty,
    //     realnearbyBakeries: []));
  }

  void _onMapMoved(HomeMapMoved event, Emitter<HomeState> emit) {
    if (state.lastSearchLocation != null) {
      final distance = getDistanceKM(
        state.lastSearchLocation!,
        event.cameraPosition,
      );

      emit(
        (state as HomeScreenState).copyWith(
          isFarFromLastSearch: distance >= AppConstants.researchableKM,
          isMapMoving: true,
        ),
      );
    }
  }

  void _onMapStopped(HomeMapStopped event, Emitter<HomeState> emit) {
    emit(
        (state as HomeScreenState).copyWith(
          mapCenter: event.lastPosition,
          isMapMoving: false,
        )
    );
  }

  Future<List<Bakery>> _searchNearBy(
    LatLng location, {
    bool deduplicate = false,
  }) async {
    // 사용자 위치 주변 검색
    final result = await _searchBakeryUseCase.searchNearBy(
        latitude: location.latitude,
        longitude: location.longitude
    );

    // 기존 데이터 중복 제거 로직
    if (deduplicate) {
      final combined = [...state.bakeryList, ...result];

      final deduplicated =
          {for (final bakery in combined) bakery.id: bakery}.values.toList();
      return deduplicated;
    }

    return result;
  }
}
