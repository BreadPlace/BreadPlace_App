part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

/// 처음 앱이 켜졌을 때
final class HomeAppInitiate extends HomeEvent {
  const HomeAppInitiate();
}

/// 특정 지역을 검색할 때
final class HomeSearchLocation extends HomeEvent {
  final LatLng location;
  const HomeSearchLocation({required this.location});
}

/// 특정 베이커르 마커를 눌렀을 때
final class HomeMarkerTapped extends HomeEvent {
  final String bakeryID;
  const HomeMarkerTapped({required this.bakeryID});
}

/// 지도를 눌렀을 때 (마커 해제)
final class HomeMapTapped extends HomeEvent {
  const HomeMapTapped();
}

/// 지도가 움직일 때
final class HomeMapMoved extends HomeEvent {
  final LatLng cameraPosition;
  const HomeMapMoved({required this.cameraPosition});
}

/// 지도가 멈췄을 때
final class HomeMapStopped extends HomeEvent {
  final LatLng lastPosition;
  const HomeMapStopped({required this.lastPosition});
}

/// 특정 베이커리를 선택했을 때
final class HomeSelectBakery extends HomeEvent {
  final TempBakeryEntity bakery;
  const HomeSelectBakery({required this.bakery});
}

/// 알림 버튼이 눌렸을 때
final class HomeBellIconTapped extends HomeEvent {
  const HomeBellIconTapped();
}




