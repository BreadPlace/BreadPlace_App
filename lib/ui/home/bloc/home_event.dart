part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

// 처음 앱이 켜졌을 때
final class HomeAppInitiate extends HomeEvent {
  const HomeAppInitiate();
}

// 알림 버튼이 눌렸을 때
final class HomeBellIconTapped extends HomeEvent {
  const HomeBellIconTapped();
}

final class HomeSelectBakery extends HomeEvent {
  const HomeSelectBakery();
}

final class HomeSearchPlace extends HomeEvent {
  const HomeSearchPlace();
}

final class HomeSetMapUserLocation extends HomeEvent {
  const HomeSetMapUserLocation();
}





